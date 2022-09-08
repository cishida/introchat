import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/introRequest/intro_request.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';

class IntroService {
  IntroService();

  final _instance = Firestore.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference introchatContactCollection =
      Firestore.instance.collection('introchatContacts');
  final CollectionReference introCollection =
      Firestore.instance.collection('intros');
  final CollectionReference introRequestCollection =
      Firestore.instance.collection('introRequests');
  final CollectionReference conversationCollection =
      Firestore.instance.collection('conversations');

  // Query users with list of phone numbers
  Future<List<DocumentSnapshot>> getUserDocuments(List<String> emails) async {
    // var lowercaseEmails = emails.map((e) => e.toLowerCase());
    var snapshots = await _instance
        .collection('users')
        .where('email', whereIn: emails)
        .getDocuments();

    return snapshots.documents;
  }

  Future<Intro> getIntro(String uid) async {
    var introDoc = await introCollection.document(uid).get();

    return Intro.fromJson(uid, introDoc.data);
  }

  Future<IntroRequest> getIntroRequest(String uid) async {
    var introRequestDoc = await introRequestCollection.document(uid).get();

    return IntroRequest.fromJson(uid, introRequestDoc.data);
  }

  Future<List<Intro>> getAllIntros(String userId) async {
    var snapshot = await _instance
        .collection('users')
        .document(userId)
        .collection('intros')
        .getDocuments();

    List<Intro> intros = [];

    for (var document in snapshot.documents) {
      var introDocument = await _instance
          .collection('intros')
          .document(document.documentID)
          .get();
      Intro intro = Intro.fromJson(document.documentID, introDocument.data);
      var fromUserDocument =
          await _instance.collection('users').document(intro.fromUid).get();
      intro.fromUserProfile = UserProfile.fromJson(
          fromUserDocument.documentID, fromUserDocument.data);
      intro.toUserProfiles = [];
      for (var toUid in intro.toUids) {
        var toUserDocument =
            await _instance.collection('users').document(toUid).get();
        var toUser = UserProfile.fromJson(
            toUserDocument.documentID, toUserDocument.data);
        if (toUser != null) {
          if (toUser.preuser != null && toUser.preuser) {
            var toContactDocuments = await _instance
                .collection('introchatContacts')
                .where('email', isEqualTo: toUser.email.toLowerCase())
                .getDocuments();
            IntrochatContact contact = IntrochatContact.fromJson(
                toContactDocuments.documents.first.documentID,
                toContactDocuments.documents.first.data);
            toUser.displayName =
                contact.getCorrectDisplayName(intro.fromUserProfile.uid);
          }
          intro.toUserProfiles.add(toUser);
        }
      }

      intros.add(intro);
    }

    return intros;
  }

  Future<List<UserProfile>> getIntroUserProfiles(Intro intro) async {
    var fromUserFuture = userCollection.document(intro.fromUid).get();
    var firstUserFuture = userCollection.document(intro.toUids[0]).get();
    var secondUserFuture = userCollection.document(intro.toUids[1]).get();

    List<DocumentSnapshot> users = await Future.wait([
      fromUserFuture,
      firstUserFuture,
      secondUserFuture,
    ]);

    List<UserProfile> userProfiles = [];
    userProfiles.add(UserProfile.fromJson(intro.fromUid, users[0].data));
    userProfiles.add(UserProfile.fromJson(intro.toUids[0], users[1].data));
    userProfiles.add(UserProfile.fromJson(intro.toUids[1], users[2].data));

    return userProfiles;
  }

  Future<List<UserProfile>> getIntroRequestUserProfiles(
      IntroRequest introRequest) async {
    var fromUserDoc = await userCollection.document(introRequest.fromUid).get();
    var connectorUserDoc =
        await userCollection.document(introRequest.connectorUid).get();

    List<UserProfile> userProfiles = [];
    userProfiles
        .add(UserProfile.fromJson(introRequest.fromUid, fromUserDoc.data));
    userProfiles.add(
        UserProfile.fromJson(introRequest.connectorUid, connectorUserDoc.data));

    return userProfiles;
  }

  Future requestIntro({
    UserProfile fromUser,
    Connection connectorConnection,
    String introchatContactUid,
    String text,
  }) async {
    var batch = _instance.batch();
    var introRequestDoc = introRequestCollection.document();
    IntroRequest introRequest = IntroRequest(
      uid: introRequestDoc.documentID,
      fromUid: fromUser.uid,
      connectorUid: connectorConnection.uid,
      introchatContactUid: introchatContactUid,
      text: text,
      created: Timestamp.now(),
    );
    batch.setData(introRequestDoc, introRequest.toJson());

    Message introRequestMessage = Message(
      content: text,
      introRequestUid: introRequestDoc.documentID,
      created: Timestamp.now(),
      recipientUids: [connectorConnection.uid],
      notificationContent: 'Sent you an Intro Request',
    );

    batch.setData(
        conversationCollection
            .document(connectorConnection.conversationUid)
            .collection('messages')
            .document(),
        introRequestMessage.toJson());

    ConnectionService connectionService = ConnectionService();
    await connectionService.updateMostRecentActivity(
      senderProfile: fromUser,
      senderMessage: 'Intro request sent',
      connection: connectorConnection,
      receiverMessage: 'Sent you an Intro Request',
    );

    return batch.commit();
  }

  Future createIntro({
    String fromUid,
    String text,
    List<IntrochatContact> contacts,
  }) async {
    var batch = _instance.batch();

    List<String> emails = contacts.map((contact) {
      return contact.email;
    }).toList();

    // Get from user
    var fromUserSnapshot = await userCollection.document(fromUid).get();
    var fromUser = UserProfile.fromJson(
        fromUserSnapshot.documentID, fromUserSnapshot.data);

    var firstUserDocSnapshot =
        await userCollection.document(contacts.first.userId).get();
    var secondUserDocSnapshot =
        await userCollection.document(contacts.last.userId).get();

    // Get first user or create new profile
    UserProfile firstUser = UserProfile();
    var firstUserDocument;
    if (firstUserDocSnapshot.exists) {
      firstUser = UserProfile.fromJson(
          firstUserDocSnapshot.documentID, firstUserDocSnapshot.data);
      firstUserDocument = userCollection.document(firstUser.uid);
    } else {
      var firstPreUserSnapshot = await userCollection
          .where('email', isEqualTo: contacts.first.email.toLowerCase())
          .getDocuments();
      if (firstPreUserSnapshot.documents.length > 0) {
        firstUser = UserProfile.fromJson(
            firstPreUserSnapshot.documents.first.documentID,
            firstPreUserSnapshot.documents.first.data);
        firstUserDocument = userCollection
            .document(firstPreUserSnapshot.documents.first.documentID);
      } else {
        firstUserDocument = userCollection.document();
        firstUser = UserProfile(
          uid: firstUserDocument.documentID,
          email: contacts.first.email,
          preuser: true,
        );
        batch.setData(firstUserDocument, firstUser.toJson());
      }
    }

    // Get second user or create new profile
    var secondUserDocument;
    UserProfile secondUser = UserProfile();
    if (secondUserDocSnapshot.exists) {
      secondUser = UserProfile.fromJson(
          secondUserDocSnapshot.documentID, secondUserDocSnapshot.data);
      secondUserDocument = userCollection.document(secondUser.uid);
    } else {
      var secondPreUserSnapshot = await userCollection
          .where('email', isEqualTo: contacts.last.email.toLowerCase())
          .getDocuments();
      if (secondPreUserSnapshot.documents.length > 0) {
        secondUser = UserProfile.fromJson(
            secondPreUserSnapshot.documents.first.documentID,
            secondPreUserSnapshot.documents.first.data);
        secondUserDocument = userCollection
            .document(secondPreUserSnapshot.documents.first.documentID);
      } else {
        secondUserDocument = userCollection.document();
        secondUser = UserProfile(
          uid: secondUserDocument.documentID,
          email: contacts.last.email,
          preuser: true,
        );
        batch.setData(secondUserDocument, secondUser.toJson());
      }
    }

    List<UserProfile> userProfiles = [
      fromUser,
      firstUser,
      secondUser,
    ];

    // Get introchatContacts
    // List<IntrochatContact> introchatContacts = [];
    // for (var userProfile in userProfiles) {
    var firstIntrochatContactSnapshot = await introchatContactCollection
        .where('email', isEqualTo: firstUser.email)
        .limit(1)
        .getDocuments();
    var firstIntrochatContactDoc =
        firstIntrochatContactSnapshot.documents.first;
    IntrochatContact firstIntrochatContact = IntrochatContact.fromJson(
      firstIntrochatContactDoc.documentID,
      firstIntrochatContactDoc.data,
    );

    var secondIntrochatContactSnapshot = await introchatContactCollection
        .where('email', isEqualTo: secondUser.email)
        .limit(1)
        .getDocuments();
    var secondIntrochatContactDoc =
        secondIntrochatContactSnapshot.documents.first;
    IntrochatContact secondIntrochatContact = IntrochatContact.fromJson(
      secondIntrochatContactDoc.documentID,
      secondIntrochatContactDoc.data,
    );
    // }

    // Make sure introduced contacts get added to each others contact
    firstIntrochatContact.userContactNames[userProfiles[2].uid] =
        firstIntrochatContact.displayName ??
            firstIntrochatContact.userContactNames[userProfiles[0].uid];
    secondIntrochatContact.userContactNames[userProfiles[1].uid] =
        secondIntrochatContact.displayName ??
            secondIntrochatContact.userContactNames[userProfiles[0].uid];

    batch.updateData(
      firstIntrochatContactDoc.reference,
      firstIntrochatContact.toJson(),
    );

    batch.updateData(
      secondIntrochatContactDoc.reference,
      secondIntrochatContact.toJson(),
    );

    // Create intro
    DocumentReference introDocument = introCollection.document();
    Intro intro = Intro(
      uid: introDocument.documentID,
      fromUid: fromUid,
      text: text,
      toUids: [firstUser.uid, secondUser.uid],
      created: Timestamp.now(),
    );

    // Create intro document and user references to intros
    batch.setData(introDocument, intro.toJson());
    batch.setData(
      userCollection.document(fromUid).collection('intros').document(intro.uid),
      {},
    );
    batch.setData(
      firstUserDocument.collection('intros').document(intro.uid),
      {},
    );
    batch.setData(
      secondUserDocument.collection('intros').document(intro.uid),
      {},
    );

    // Create conversations
    // ConversationService conversationService = ConversationService();
    // String fromFirst =
    //     conversationService.getConversationUid([fromUid, firstUser.uid]);
    // String fromSecond =
    //     conversationService.getConversationUid([fromUid, secondUser.uid]);
    // String firstSecond =
    //     conversationService.getConversationUid([firstUser.uid, secondUser.uid]);
    var conversationCollection = _instance.collection('conversations');
    var fromFirstConversationDoc = conversationCollection.document();
    var fromSecondConversationDoc = conversationCollection.document();
    var firstSecondConversationDoc = conversationCollection.document();

    var fromFirstConnectionDoc = await userCollection
        .document(fromUid)
        .collection('connections')
        .document(firstUser.uid)
        .get();
    var firstFromConnectionDoc = await userCollection
        .document(firstUser.uid)
        .collection('connections')
        .document(fromUid)
        .get();
    if (fromFirstConnectionDoc.exists) {
      fromFirstConversationDoc = conversationCollection
          .document(fromFirstConnectionDoc.data['conversationUid']);
    }

    var fromSecondConnectionDoc = await userCollection
        .document(fromUid)
        .collection('connections')
        .document(secondUser.uid)
        .get();
    var secondFromConnectionDoc = await userCollection
        .document(secondUser.uid)
        .collection('connections')
        .document(fromUid)
        .get();
    if (fromSecondConnectionDoc.exists) {
      fromSecondConversationDoc = conversationCollection
          .document(fromSecondConnectionDoc.data['conversationUid']);
    }

    var firstSecondConnectionDoc = await userCollection
        .document(firstUser.uid)
        .collection('connections')
        .document(secondUser.uid)
        .get();
    var secondFirstConnectionDoc = await userCollection
        .document(secondUser.uid)
        .collection('connections')
        .document(firstUser.uid)
        .get();
    if (firstSecondConnectionDoc.exists) {
      firstSecondConversationDoc = conversationCollection
          .document(firstSecondConnectionDoc.data['conversationUid']);
    }

    // batch.setData(conversationCollection.document(fromFirst), {});
    // batch.setData(conversationCollection.document(fromSecond), {});
    // batch.setData(conversationCollection.document(firstSecond), {});

    // Intro
    Message introMessage = Message(
      content: text,
      introUid: introDocument.documentID,
      created: Timestamp.now(),
      senderUid: fromUid,
    );

    introMessage.recipientUids = [firstUser.uid];
    introMessage.notificationContent = 'Sent you an intro';
    batch.setData(
        conversationCollection
            .document(fromFirstConversationDoc.documentID)
            .collection('messages')
            .document(),
        introMessage.toJson());

    introMessage.recipientUids = [secondUser.uid];
    batch.setData(
        conversationCollection
            .document(fromSecondConversationDoc.documentID)
            .collection('messages')
            .document(),
        introMessage.toJson());

    introMessage.recipientUids = [firstUser.uid, secondUser.uid];
    introMessage.notificationContent = 'Intro by ${fromUser.displayName}';
    batch.setData(
        conversationCollection
            .document(firstSecondConversationDoc.documentID)
            .collection('messages')
            .document(),
        introMessage.toJson());

    Connection connection = Connection(
      conversationUid: fromFirstConversationDoc.documentID,
      mostRecentActivity: Timestamp.now(),
      lastMessage:
          'Intro made to ${contacts.last.getCorrectDisplayName(fromUid)}',
    );

    // From user connections
    if (!fromFirstConnectionDoc.exists) {
      connection.status = ConnectionStatus.pending;
    } else {
      connection.status = ConnectionStatusExtension.fromString(
          fromFirstConnectionDoc.data['status']);
    }
    batch.setData(
      fromFirstConnectionDoc.reference,
      connection.toJson(),
    );

    connection.conversationUid = fromSecondConversationDoc.documentID;
    connection.lastMessage =
        'Intro made to ${contacts.first.getCorrectDisplayName(fromUid)}';
    if (!fromSecondConnectionDoc.exists) {
      connection.status = ConnectionStatus.pending;
    } else {
      connection.status = ConnectionStatusExtension.fromString(
          fromSecondConnectionDoc.data['status']);
    }
    batch.setData(
      fromSecondConnectionDoc.reference,
      connection.toJson(),
    );

    // First user connections
    connection.conversationUid = fromFirstConversationDoc.documentID;
    connection.lastMessage = 'Sent you an intro';
    if (!firstFromConnectionDoc.exists) {
      connection.status = ConnectionStatus.unaccepted;
    } else {
      connection.status = ConnectionStatusExtension.fromString(
          firstFromConnectionDoc.data['status']);
    }
    batch.setData(
      firstFromConnectionDoc.reference,
      connection.toJson(),
    );

    connection.conversationUid = firstSecondConversationDoc.documentID;
    connection.lastMessage = 'Intro by ${fromUser.displayName}';
    if (!firstSecondConnectionDoc.exists) {
      connection.status = ConnectionStatus.unaccepted;
      connection.temporaryDisplayName =
          contacts.last.getCorrectDisplayName(fromUid);
    } else {
      connection.status = ConnectionStatusExtension.fromString(
          firstSecondConnectionDoc.data['status']);
      connection.temporaryDisplayName =
          firstSecondConnectionDoc.data['temporaryDisplayName'];
    }
    batch.setData(
      firstSecondConnectionDoc.reference,
      connection.toJson(),
    );

    // Second user connections
    connection.conversationUid = fromSecondConversationDoc.documentID;
    connection.lastMessage = 'Sent you an intro';
    if (!secondFromConnectionDoc.exists) {
      connection.status = ConnectionStatus.unaccepted;
    } else {
      connection.status = ConnectionStatusExtension.fromString(
          secondFromConnectionDoc.data['status']);
    }
    batch.setData(
      secondFromConnectionDoc.reference,
      connection.toJson(),
    );

    connection.conversationUid = firstSecondConversationDoc.documentID;
    connection.lastMessage = 'Intro by ${fromUser.displayName}';
    if (!secondFirstConnectionDoc.exists) {
      connection.status = ConnectionStatus.unaccepted;
      connection.temporaryDisplayName =
          contacts.first.getCorrectDisplayName(fromUid);
    } else {
      connection.status = ConnectionStatusExtension.fromString(
          secondFirstConnectionDoc.data['status']);
      connection.temporaryDisplayName =
          secondFirstConnectionDoc.data['temporaryDisplayName'];
    }
    batch.setData(
      secondFirstConnectionDoc.reference,
      connection.toJson(),
    );

    return batch.commit();
  }
}
