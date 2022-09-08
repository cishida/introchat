import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/conversation.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/constants/strings.dart';

class ConnectionService {
  ConnectionService();

  final _instance = Firestore.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference connectionCollection =
      Firestore.instance.collection('connections');
  final CollectionReference introchatContactCollection =
      Firestore.instance.collection('introchatContacts');

  Connection _connectionFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return Connection.fromJson(
        snapshot.documentID,
        Map<String, dynamic>.from(snapshot.data),
      );
    } else {
      return null;
    }
  }

  // Get connection stream
  Stream<Connection> connection(String userUid, String connectionUid) {
    return userCollection
        .document(userUid)
        .collection('connections')
        .document(connectionUid)
        .snapshots()
        .map(_connectionFromSnapshot);
  }

  Future updateLastViewed(String currentUserUid, String connectionUid) async {
    var batch = _instance.batch();
    final DocumentReference connectionDoc = userCollection
        .document(currentUserUid)
        .collection('connections')
        .document(connectionUid);

    batch.updateData(
      connectionDoc,
      {
        'lastViewed': Timestamp.now().microsecondsSinceEpoch,
        'unseenNotificationCount': 0,
      },
    );
    return batch.commit();
  }

  Future requestConnection(
    String currentUserUid,
    IntrochatContact introchatContact,
  ) {
    var batch = _instance.batch();

    var conversationCollection = _instance.collection('conversations');
    var conversationDoc = conversationCollection.document();
    Conversation conversation = Conversation(created: Timestamp.now());

    Connection connection = Connection(
      lastViewed: Timestamp.now(),
      conversationUid: conversationDoc.documentID,
      lastMessage: 'Connection pending',
      status: ConnectionStatus.pending,
      mostRecentActivity: Timestamp.now(),
    );

    batch.setData(
        userCollection
            .document(currentUserUid)
            .collection('connections')
            .document(introchatContact.userId),
        connection.toJson());

    connection.lastMessage = 'Connection Request';
    connection.lastViewed = null;
    connection.status = ConnectionStatus.unaccepted;
    batch.setData(
        userCollection
            .document(introchatContact.userId)
            .collection('connections')
            .document(currentUserUid),
        connection.toJson());

    Message directConnectionMessage = Message(
      content: '⚡  Direct Connection  ⚡️',
      directConnection: true,
      created: Timestamp.now(),
      senderUid: currentUserUid,
      recipientUids: [connection.uid],
      notificationContent: '⚡  Direct Connection Request ⚡️',
    );

    batch.setData(conversationDoc.collection('messages').document(),
        directConnectionMessage.toJson());

    return batch.commit();
  }

  Future acceptConnection(
      UserProfile currentUser, Connection connection) async {
    var batch = _instance.batch();

    final DocumentReference currentConnectionDoc = userCollection
        .document(currentUser.uid)
        .collection('connections')
        .document(connection.uid);
    var requesterConnectionDoc = await userCollection
        .document(connection.uid)
        .collection('connections')
        .document(currentUser.uid)
        .get();

    var requesterConnection = Connection.fromJson(
        requesterConnectionDoc.documentID, requesterConnectionDoc.data);

    if (requesterConnection.status == ConnectionStatus.pending ||
        requesterConnection.status == ConnectionStatus.accepted) {
      batch.updateData(
          userCollection
              .document(connection.uid)
              .collection('connections')
              .document(currentUser.uid),
          {
            'status': 'accepted',
            'mostRecentActivity': Timestamp.now().microsecondsSinceEpoch,
            'lastMessage': 'Connection Accepted',
            'unseenNotificationCount': 1,
          });

      IntrochatContactService introchatContactService =
          IntrochatContactService(uid: currentUser.uid);
      var currentIntrochatContact = await introchatContactService
          .getIntrochatContactFromEmail(currentUser.email);
      var requesterIntrochatContact = await introchatContactService
          .getIntrochatContactFromEmail(connection.userProfile.email);

      currentIntrochatContact.userContactNames[connection.uid] =
          currentUser.displayName;
      requesterIntrochatContact.userContactNames[currentUser.uid] =
          connection.userProfile.displayName;

      batch.updateData(
        introchatContactCollection.document(currentIntrochatContact.uid),
        currentIntrochatContact.toJson(),
      );
      batch.updateData(
        introchatContactCollection.document(requesterIntrochatContact.uid),
        requesterIntrochatContact.toJson(),
      );
    }

    batch.updateData(currentConnectionDoc, {
      'status': 'accepted',
      'mostRecentActivity': Timestamp.now().microsecondsSinceEpoch,
      'lastMessage': 'Connection Accepted',
      'unseenNotificationCount': 1,
    });

    return batch.commit();
  }

  Future blockConnection(String currentUserUid, String connectionUid) async {
    return userCollection
        .document(currentUserUid)
        .collection('connections')
        .document(connectionUid)
        .updateData({'status': 'blocked'});
  }

  Future unblockConnection(String currentUserUid, String connectionUid) async {
    return userCollection
        .document(currentUserUid)
        .collection('connections')
        .document(connectionUid)
        .updateData({
      'status': 'accepted',
      'mostRecentActivity': Timestamp.now().microsecondsSinceEpoch,
      'lastMessage': 'Unblocked',
      'unseenNotificationCount': 1,
    });
  }

  Future<UserProfile> getConnectionUserProfile(String uid) async {
    var userDoc = await userCollection.document(uid).get();
    if (userDoc.exists) {
      return UserProfile.fromJson(uid, userDoc.data);
    } else {
      return null;
    }
  }

  Future<int> getUserChatCount(String uid) async {
    var connectionDocs = await userCollection
        .document(uid)
        .collection('connections')
        .where('status', isEqualTo: 'accepted')
        .getDocuments();

    return connectionDocs.documents.length;
  }

  Future updateMostRecentActivity({
    UserProfile senderProfile,
    String senderMessage,
    Connection connection,
    String receiverMessage,
  }) async {
    var batch = _instance.batch();
    var senderConnectionDoc = userCollection
        .document(senderProfile.uid)
        .collection('connections')
        .document(connection.uid);
    batch.updateData(
      senderConnectionDoc,
      {
        'lastMessage': senderMessage,
        'mostRecentActivity': Timestamp.now().microsecondsSinceEpoch,
        'lastViewed': Timestamp.now().microsecondsSinceEpoch + 1,
      },
    );

    if (connection.uid != ConstantStrings.TEAM_INTROCHAT_UID) {
      var receiverConnectionSnap = await userCollection
          .document(connection.uid)
          .collection('connections')
          .document(senderProfile.uid)
          .get();

      Connection receiverConnection =
          Connection.fromJson(senderProfile.uid, receiverConnectionSnap.data);

      if (connection.uid != ConstantStrings.TEAM_INTROCHAT_UID &&
          receiverConnection.status == ConnectionStatus.accepted) {
        receiverConnection.lastMessage = receiverMessage;
        receiverConnection.mostRecentActivity = Timestamp.now();
        receiverConnection.unseenNotificationCount =
            (receiverConnection.unseenNotificationCount ?? 0) + 1;
        batch.updateData(
          receiverConnectionSnap.reference,
          receiverConnection.toJson(),
        );
      }
    }

    return batch.commit();
  }

  Future createConnectionWithPreUser(
    String currentUserUid,
    IntrochatContact introchatContact,
  ) async {
    var batch = _instance.batch();
    UserProfile preUser = UserProfile();
    var preUserDocument;

    var preUserSnapshot = await userCollection
        .where('email', isEqualTo: introchatContact.email.toLowerCase())
        .getDocuments();

    if (preUserSnapshot.documents.length > 0) {
      preUser = UserProfile.fromJson(preUserSnapshot.documents.first.documentID,
          preUserSnapshot.documents.first.data);
      preUserDocument =
          userCollection.document(preUserSnapshot.documents.first.documentID);
    } else {
      preUserDocument = userCollection.document();
      preUser = UserProfile(
        uid: preUserDocument.documentID,
        email: introchatContact.email,
        preuser: true,
      );
      batch.setData(preUserDocument, preUser.toJson());
    }

    var conversationCollection = _instance.collection('conversations');
    var conversationDoc = conversationCollection.document();
    Conversation conversation = Conversation(created: Timestamp.now());
    var connectionDoc = await userCollection
        .document(currentUserUid)
        .collection('connections')
        .document(preUser.uid)
        .get();
    if (connectionDoc.exists) {
      conversationDoc = conversationCollection
          .document(connectionDoc.data['conversationUid']);
    }

    Connection connection = Connection(
      lastViewed: Timestamp.now(),
      conversationUid: conversationDoc.documentID,
      lastMessage: 'Connection pending',
      status: ConnectionStatus.pending,
      mostRecentActivity: Timestamp.now(),
    );

    batch.setData(
        userCollection
            .document(currentUserUid)
            .collection('connections')
            .document(preUser.uid),
        connection.toJson());

    connection.lastMessage = 'Connection Request';
    connection.status = ConnectionStatus.unaccepted;
    batch.setData(
        userCollection
            .document(preUser.uid)
            .collection('connections')
            .document(currentUserUid),
        connection.toJson());

    Message directConnectionMessage = Message(
      content: '⚡  Direct Connection  ⚡️',
      directConnection: true,
      created: Timestamp.now(),
      senderUid: currentUserUid,
      recipientUids: [connection.uid],
      notificationContent: '⚡  Direct Connection Request  ⚡️',
    );

    batch.setData(conversationDoc.collection('messages').document(),
        directConnectionMessage.toJson());

    return batch.commit();
  }
}
