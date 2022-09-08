import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/user/user.dart';

class UserService {
  UserService();

  final _instance = Firestore.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<UserProfile> getUserProfile(String uid) async {
    var userDoc = await userCollection.document(uid).get();

    return UserProfile.fromJson(uid, userDoc.data);
  }

  Future addToken(String userUid, String token) async {
    var userRef = userCollection.document(userUid);
    await userRef.setData(
      {
        'fcmTokens': FieldValue.arrayUnion([token]),
      },
      merge: true,
    );
  }

  Future syncUnseenNotificationCount(
    List<Connection> connections,
    String userUid,
  ) async {
    int unseenNotificationCount = 0;
    for (var connection in connections) {
      unseenNotificationCount += connection.unseenNotificationCount ?? 0;
    }

    var userRef = userCollection.document(userUid);
    await userRef.updateData({
      'unseenNotificationCount': unseenNotificationCount,
    });
    FlutterAppBadger.updateBadgeCount(unseenNotificationCount);
  }
}
