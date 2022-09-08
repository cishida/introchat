import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: Make serializable
class Conversation {
  final String uid;
  final Timestamp created;

  Conversation({this.uid, this.created});
}
