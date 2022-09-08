import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:introchat/core/models/message/message.dart';

class ConversationService {
  ConversationService();

  final _instance = Firestore.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference conversationCollection =
      Firestore.instance.collection('conversations');
  List<Message> sendingMessages = [];

  // User data list from snapshot
  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Message.fromJson(Map<String, dynamic>.from(doc.data));
    }).toList();
  }

  // Get messages stream
  Stream<List<Message>> messages(String uid) {
    return conversationCollection
        .document(uid)
        .collection('messages')
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  // Send message
  Future<bool> sendMessage(String uid, Message message) async {
    try {
      var messageDocument = conversationCollection
          .document(uid)
          .collection('messages')
          .document();
      if (message.imageFile != null) {
        message.imageDownloadUrl = '';
        await messageDocument.setData(message.toJson());

        StorageReference ref = FirebaseStorage.instance
            .ref()
            .child('${messageDocument.documentID}_message_image');
        StorageUploadTask uploadTask = ref.putFile(message.imageFile);
        message.imageDownloadUrl =
            await (await uploadTask.onComplete).ref.getDownloadURL();
      }

      await messageDocument.setData(message.toJson());
      return true;
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }
}
