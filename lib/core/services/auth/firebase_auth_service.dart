import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/google/google_http_client.dart';
import 'package:introchat/core/utils/constants/strings.dart';

class FirebaseAuthService implements AuthService {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference conversationCollection =
      Firestore.instance.collection('conversations');
  final CollectionReference introCollection =
      Firestore.instance.collection('intros');
  final CollectionReference introchatContactCollection =
      Firestore.instance.collection('introchatContacts');

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts',
      "https://www.googleapis.com/auth/userinfo.email",
    ],
  );

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    return User(
      uid: user.uid,
    );
  }

  // @override
  // Stream<GoogleSignInAccount> get onCurrentUserChanged {
  //   return _googleSignIn.onCurrentUserChanged;
  //   // return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  // }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<Map<String, String>> currentAuthHeaders() async {
    var currentUser = _googleSignIn.currentUser;
    return await _googleSignIn.currentUser.authHeaders;
  }

  @override
  Future<User> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future _createUserProfile(FirebaseUser user) async {
    var batch = Firestore.instance.batch();

    final DocumentReference userProfileDoc = userCollection.document(user.uid);
    // Set new user data
    batch.setData(userProfileDoc, {
      'displayName': user.displayName ?? user.email,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoUrl': user.photoUrl,
      'onboarded': false,
      'preuser': false,
      'unseenNotificationCount': 1,
    });

    var introchatContactSnapshot = await introchatContactCollection
        .where('email', isEqualTo: user.email.toLowerCase())
        .getDocuments();
    if (introchatContactSnapshot.documents.length > 0) {
      var introchatContactDoc = introchatContactCollection
          .document(introchatContactSnapshot.documents.first.documentID);
      batch.updateData(
        introchatContactDoc,
        {
          'displayName': user.displayName,
          'userId': user.uid,
          'photoUrl': user.photoUrl,
        },
      );
    } else {
      IntrochatContact introchatContact = IntrochatContact(
        displayName: user.displayName ?? user.email,
        email: user.email,
        created: Timestamp.now(),
        userContactNames: {},
        userId: user.uid,
        photoUrl: user.photoUrl,
      );
      batch.setData(
        introchatContactCollection.document(),
        introchatContact.toJson(),
      );
    }

    var newConversationDoc = conversationCollection.document();
    batch.setData(
      newConversationDoc,
      {'created': Timestamp.now()},
    );

    var messages = [
      Message(
        content: ConstantStrings.ONBOARDING_MESSAGE,
        created: Timestamp.now(),
        senderUid: ConstantStrings.TEAM_INTROCHAT_UID,
        recipientUids: [userProfileDoc.documentID],
        notificationContent: ConstantStrings.ONBOARDING_MESSAGE,
      ),
    ];
    batch.setData(newConversationDoc.collection('messages').document(),
        messages[0].toJson());

    var connection = Connection(
      conversationUid: newConversationDoc.documentID,
      lastMessage: messages[0].content,
      mostRecentActivity: Timestamp.now(),
      status: ConnectionStatus.accepted,
      unseenNotificationCount: 1,
    );
    batch.setData(
      userProfileDoc
          .collection('connections')
          .document(ConstantStrings.TEAM_INTROCHAT_UID),
      connection.toJson(),
    );

    var oldUserSnapshot = await userCollection
        .where('email', isEqualTo: user.email.toLowerCase())
        .getDocuments();
    if (oldUserSnapshot.documents.length > 0) {
      var oldUserDoc = oldUserSnapshot.documents.first;
      var oldUserConnectionSnapshot = await userCollection
          .document(oldUserDoc.documentID)
          .collection('connections')
          .getDocuments();
      for (var connectionDocument in oldUserConnectionSnapshot.documents) {
        // Need to copy all connection and delete old ones
        var connectionOldUserSnapshot = await userCollection
            .document(connectionDocument.documentID)
            .collection('connections')
            .document(oldUserDoc.documentID)
            .get();
        var connectionNewUserDocument = userCollection
            .document(connectionDocument.documentID)
            .collection('connections')
            .document(userProfileDoc.documentID);
        var connection = Connection.fromJson(
            connectionOldUserSnapshot.documentID,
            connectionOldUserSnapshot.data);
        batch.setData(connectionNewUserDocument, connection.toJson());
        batch.delete(userCollection
            .document(connectionDocument.documentID)
            .collection('connections')
            .document(oldUserDoc.documentID));

        batch.setData(
            userProfileDoc
                .collection('connections')
                .document(connectionDocument.documentID),
            connectionDocument.data);
      }

      var oldUserIntroSnapshot = await userCollection
          .document(oldUserDoc.documentID)
          .collection('intros')
          .getDocuments();
      for (var userIntroDocument in oldUserIntroSnapshot.documents) {
        batch.setData(
            userProfileDoc
                .collection('intros')
                .document(userIntroDocument.documentID),
            userIntroDocument.data);

        var introDocument =
            await introCollection.document(userIntroDocument.documentID).get();

        Intro intro =
            Intro.fromJson(introDocument.documentID, introDocument.data);
        for (var i = 0; i < intro.toUids.length; i++) {
          if (intro.toUids[i] == oldUserDoc.documentID) {
            intro.toUids[i] = userProfileDoc.documentID;
          }
        }

        batch.setData(introCollection.document(userIntroDocument.documentID),
            intro.toJson());
      }
    }

    return batch.commit();
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //     .catchError((onError) {
    //   print("Error $onError");
    // });

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));

        FirebaseUser user = authResult.user;

        if (user != null) {
          final userProfileDoc = await Firestore.instance
              .collection('users')
              .document(user.uid)
              .get();
          if (!userProfileDoc.exists) {
            await _createUserProfile(user);
          }

          // final authHeaders = await _googleSignIn.currentUser.authHeaders;

          // final httpClient = GoogleHttpClient(authHeaders);

          // var data = await PeopleApi(httpClient).people.connections.list(
          //       'people/me',
          //       personFields: 'names,emailAddresses',
          //       pageSize: 100,
          //     );
          // print('Data: $data');
        }

        return _userFromFirebase(user);
      } else {
        print('missing google auth token');
      }
    } else {
      print('User cancelled sign in');
    }
  }

  @override
  void sendVerificationCode(String phone) {
    // FirebasePhoneAuth.instantiate(phoneNumber: phone);
    return null;
  }

  @override
  Future<User> signInWithPhone(String smsCode) {
    // FirebasePhoneAuth.signInWithPhoneNumber(smsCode: smsCode);
    return null;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
