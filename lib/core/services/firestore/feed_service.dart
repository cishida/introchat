import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introchat/core/models/contact_joined/contact_joined.dart';
import 'package:introchat/core/models/intro/intro.dart';

class FeedService {
  FeedService();

  final _instance = Firestore.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<List> getAllFeedObjects(String userId) async {
    var snapshot = await _instance
        .collection('users')
        .document(userId)
        .collection('feedObjects')
        .orderBy('created', descending: true)
        .getDocuments();

    List feedObjects = [];
    for (var document in snapshot.documents) {
      var data = document.data;
      if (data['type'] == 'intro') {
        feedObjects.add(Intro.fromJson(document.documentID, document.data));
      } else {
        feedObjects
            .add(ContactJoined.fromJson(document.documentID, document.data));
      }
    }

    return feedObjects;
  }
}
