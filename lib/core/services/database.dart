import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/strings.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection references
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference conversationCollection =
      Firestore.instance.collection('conversations');

  // Future signUpUser(String phoneNumber) async {
  //   var db = Firestore.instance;
  //   var batch = db.batch();

  //   final DocumentReference userCollectionDocument =
  //       userCollection.document(uid);
  //   // Set new user data
  //   batch.setData(userCollection.document(uid),
  //       {'onboarded': false, 'phoneNumber': phoneNumber});

  //   var newConversationDoc = conversationCollection.document();
  //   batch.setData(newConversationDoc, {'created': Timestamp.now()});

  //   var messages = [
  //     Message(
  //       content: ConstantStrings.ONBOARDING_MESSAGE,
  //       created: Timestamp.now(),
  //       senderUid: ConstantStrings.TEAM_INTROCHAT_UID,
  //     ),
  //   ];
  //   batch.setData(newConversationDoc.collection('messages').document(),
  //       messages[0].toJson());

  //   batch.setData(
  //     userCollectionDocument
  //         .collection('connections')
  //         .document(ConstantStrings.TEAM_INTROCHAT_UID),
  //     {
  //       'conversationUid': newConversationDoc.documentID,
  //       'name': 'Team Introchat',
  //       'lastMessage': messages[0].content,
  //       'created': Timestamp.now()
  //     },
  //   );

  //   return batch.commit();
  // }

  Future updateUserProfile(Map<String, dynamic> map) async {
    var db = Firestore.instance;
    var batch = db.batch();
    final DocumentReference userCollectionDocument =
        userCollection.document(uid);

    batch.updateData(userCollectionDocument, map);

    return batch.commit();
  }

  // Connection list from snapshot
  List<Connection> _connectionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Connection.fromJson(doc.documentID, doc.data);
    }).toList();

    // return snapshot.documents.map((doc) {
    //   final data = doc.data;

    //   return Connection(
    //     uid: doc.documentID ?? '',
    //     conversationUid: data['conversationUid'] ?? '',
    //     mostRecentActivity: data['mostRecentActivity'] ?? Timestamp.now(),
    //     lastMessage: data['lastMessage'] ?? '',
    //     // name: data['name'] ?? '',
    //     // photoUrl: data['photoUrl'] ?? '',
    //   );
    // }).toList();
  }

  // Get connections stream
  Stream<List<Connection>> get connections {
    return userCollection
        .document(uid)
        .collection('connections')
        .snapshots()
        .map(_connectionListFromSnapshot);
  }

  // Intro list from snapshot
  List<Intro> _introListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Intro.fromJson(doc.documentID, doc.data);
    }).toList();
  }

  // Get feed objects stream
  Stream<List<Intro>> get feedObjects {
    return userCollection
        .document(uid)
        .collection('feedObjects')
        .snapshots()
        .map(_introListFromSnapshot);
  }

  // User data list from snapshot
  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Message.fromJson(Map<String, dynamic>.from(doc.data));
    }).toList();
  }

  // Get messages stream
  Stream<List<Message>> messages(String conversationUid) {
    return conversationCollection
        .document(conversationUid)
        .collection('messages')
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  // UserProfile from snapshot
  UserProfile _userProfileFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return UserProfile.fromJson(
        snapshot.documentID,
        Map<String, dynamic>.from(snapshot.data),
      );
    } else {
      return null;
    }
  }

  // Get current user data doc stream
  Stream<UserProfile> get userProfile {
    return userCollection
        .document(uid)
        .snapshots()
        .map(_userProfileFromSnapshot);
  }

  // Send message
  Future<bool> sendMessage(String conversationUid, Message message) async {
    try {
      conversationCollection
          .document(conversationUid)
          .collection('messages')
          .document()
          .setData(message.toJson());
      return true;
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }
}
