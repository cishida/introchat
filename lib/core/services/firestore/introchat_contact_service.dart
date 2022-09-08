import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/services/google/google_http_client.dart';

class IntrochatContactService {
  final String uid;
  IntrochatContactService({this.uid});

  final _instance = Firestore.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference introchatContactCollection =
      Firestore.instance.collection('introchatContacts');

  Future updateIntrochatContact(IntrochatContact introchatContact) async {
    var batch = _instance.batch();
    final DocumentReference introchatContactDocument =
        introchatContactCollection.document(introchatContact.uid);

    batch.setData(introchatContactDocument, introchatContact.toJson());

    return batch.commit();
  }

  Future<IntrochatContact> getIntrochatContactFromEmail(String email) async {
    var snapshot = await introchatContactCollection
        .where('email', isEqualTo: email.toLowerCase())
        .getDocuments();
    if (snapshot.documents.length > 0) {
      return IntrochatContact.fromJson(
        snapshot.documents.first.documentID,
        snapshot.documents.first.data,
      );
    } else {
      return null;
    }
  }

  Future<IntrochatContact> getIntrochatContact(String uid) async {
    var introchatContactDoc =
        await introchatContactCollection.document(uid).get();
    if (introchatContactDoc.exists) {
      return IntrochatContact.fromJson(uid, introchatContactDoc.data);
    } else {
      return null;
    }
  }

  Future<IntrochatContact> getIntrochatContactFromUser(String uid) async {
    var snapshot = await introchatContactCollection
        .where('userId', isEqualTo: uid)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      return IntrochatContact.fromJson(
        snapshot.documents.first.documentID,
        snapshot.documents.first.data,
      );
    } else {
      return null;
    }
  }

  // Conversation list from snapshot
  List<IntrochatContact> _introchatContactListFromSnapshot(
      QuerySnapshot snapshot) {
    List<IntrochatContact> introchatContacts = [];
    for (var document in snapshot.documents) {
      var introchatContact = IntrochatContact.fromJson(
        document.documentID,
        document.data,
      );
      if (introchatContact.userId != uid) {
        introchatContacts.add(introchatContact);
      }
    }
    introchatContacts.sort((a, b) {
      return a
          .getCorrectDisplayName(uid)
          .toLowerCase()
          .compareTo(b.getCorrectDisplayName(uid).toLowerCase());
    });

    return introchatContacts;
    // return snapshot.documents.map((doc) {
    //   final data = doc.data;

    //   return IntrochatContact.fromJson(doc.documentID, data);
    // }).toList();
  }

  // Get contacts stream
  Stream<List<IntrochatContact>> get introchatContacts {
    return introchatContactCollection
        .where('userContactNames.$uid', isGreaterThan: '')
        .snapshots()
        .map(_introchatContactListFromSnapshot);
  }

  // Future<List<IntrochatContacts

  Future<List<IntrochatContact>> getIntrochatContacts({String userId}) async {
    var searchId = userId ?? uid;
    var querySnapshot = await introchatContactCollection
        .where('userContactNames.$searchId', isGreaterThan: '')
        .getDocuments();
    List<IntrochatContact> introchatContacts = [];
    if (querySnapshot != null && querySnapshot.documents.isNotEmpty) {
      for (var document in querySnapshot.documents) {
        if (document.exists) {
          var introchatContact = IntrochatContact.fromJson(
            document.documentID,
            Map<String, dynamic>.from(document.data),
          );

          introchatContacts.add(introchatContact);
        }
      }
    }
    if (introchatContacts.isNotEmpty) {
      introchatContacts.sort((a, b) {
        return a
            .getCorrectDisplayName(uid)
            .toLowerCase()
            .compareTo(b.getCorrectDisplayName(uid).toLowerCase());
      });
    }
    return introchatContacts;
  }

  // Future addConnectedUidToIntrochatContact(
  //   IntrochatContact introchatContact,
  //   String connectedUserId,
  // ) async {
  //   introchatContact.connectedUserIds.add(connectedUserId);
  //   return await introchatContactCollection
  //       .document(introchatContact.uid)
  //       .updateData(introchatContact.toJson());
  // }

  // Future addUserContactNameToIntrochatContact(
  //   IntrochatContact introchatContact,
  //   String userContactName,
  // ) async {
  //   if (introchatContact.userContactNames == null) {
  //     introchatContact.userContactNames = {};
  //   }

  //   introchatContact.userContactNames[uid] = userContactName;
  //   return await introchatContactCollection
  //       .document(introchatContact.uid)
  //       .updateData(introchatContact.toJson());
  // }

  Future updateContacts(List<Person> people) async {
    List<Future> futureArray = [];
    List<WriteBatch> batchList = [];
    batchList.add(_instance.batch());
    int operationCounter = 0;
    int batchIndex = 0;

    // Stopwatch stopwatch = new Stopwatch()..start();

    Future.wait(people.map((person) async {
      if (person.emailAddresses != null) {
        for (var email in person.emailAddresses) {
          var displayName = '';
          // TODO: Use ? but read about it first
          if (person.names != null &&
              person.names.first != null &&
              person.names.first.displayName != null) {
            displayName = person.names.first.displayName;
          } else {
            displayName = email.value.toLowerCase();
          }

          var snapshot = await introchatContactCollection
              .where('email', isEqualTo: email.value.toLowerCase())
              .limit(1)
              .getDocuments();
          if (snapshot.documents.length > 0) {
            var introchatDoc = snapshot.documents.first;
            IntrochatContact introchatContact = IntrochatContact.fromJson(
              introchatDoc.documentID,
              introchatDoc.data,
            );

            if (introchatContact.userContactNames == null) {
              introchatContact.userContactNames = {};
            }

            introchatContact.userContactNames[uid] = displayName;
            if (introchatContact.userId != uid) {
              batchList[batchIndex].updateData(
                introchatContactCollection.document(introchatContact.uid),
                introchatContact.toJson(),
              );
            }
          } else {
            IntrochatContact introchatContact = IntrochatContact(
              displayName: null,
              email: email.value.toLowerCase(),
              created: Timestamp.now(),
              // connectedUserIds: [uid],
              userContactNames: {uid: displayName},
            );
            var introchatContactDocument =
                introchatContactCollection.document();

            batchList[batchIndex]
                .setData(introchatContactDocument, introchatContact.toJson());
          }

          operationCounter++;

          if (operationCounter == 498) {
            batchList.add(_instance.batch());
            batchIndex++;
            operationCounter++;
          }
        }
      }
    })).then((value) {
      batchList.forEach((batch) async {
        await batch.commit();
        // print(stopwatch.elapsed);
      });
    });

    // for (var person in people) {
    //   if (person.emailAddresses != null) {
    //     for (var email in person.emailAddresses) {
    //       var displayName = '';
    //       if (person.names != null &&
    //           person.names.first != null &&
    //           person.names.first.displayName != null) {
    //         displayName = person.names.first.displayName;
    //       } else {
    //         displayName = email.value;
    //       }

    //       var snapshot = await introchatContactCollection
    //           .where('email', isEqualTo: email.value)
    //           .getDocuments();
    //       if (snapshot.documents.length > 0) {
    //         var introchatDoc = snapshot.documents.first;
    //         IntrochatContact introchatContact = IntrochatContact.fromJson(
    //           introchatDoc.documentID,
    //           introchatDoc.data,
    //         );
    //         // if (!introchatContact.connectedUserIds.contains(uid)) {
    //         //   futureArray.add(
    //         //     addConnectedUidToIntrochatContact(
    //         //       introchatContact,
    //         //       uid,
    //         //     ),
    //         //   );
    //         // }

    //         if (introchatContact.userContactNames == null) {
    //           introchatContact.userContactNames = {};
    //         }

    //         introchatContact.userContactNames[uid] = displayName;
    //         batchList[batchIndex].updateData(
    //           introchatContactCollection.document(introchatContact.uid),
    //           {
    //             'userContactNames': {uid: displayName},
    //           },
    //         );
    //         // futureArray.add(introchatContactCollection
    //         //     .document(introchatContact.uid)
    //         //     .updateData({
    //         //   'userContactNames': {uid: displayName}
    //         // }));

    //       } else {
    //         IntrochatContact introchatContact = IntrochatContact(
    //           displayName: null,
    //           email: email.value,
    //           created: Timestamp.now(),
    //           // connectedUserIds: [uid],
    //           userContactNames: {uid: displayName},
    //         );
    //         var introchatContactDocument =
    //             introchatContactCollection.document();

    //         batchList[batchIndex]
    //             .setData(introchatContactDocument, introchatContact.toJson());
    //         // futureArray.add(
    //         //   introchatContactDocument.setData(introchatContact.toJson()),
    //         // );
    //       }

    //       operationCounter++;

    //       if (operationCounter == 498) {
    //         batchList.add(_instance.batch());
    //         batchIndex++;
    //         operationCounter++;
    //       }
    //     }
    //   }
    // }

    // batchList.forEach((batch) async {
    //   await batch.commit();
    // });

    // print(stopwatch.elapsed);

    return null;
  }

  Future<void> syncGoogleContacts() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts',
        "https://www.googleapis.com/auth/userinfo.email",
      ],
    );

    try {
      final GoogleSignInAccount googleUser =
          await _googleSignIn.signInSilently(suppressErrors: false);
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authHeaders = await _googleSignIn.currentUser.authHeaders;

        final httpClient = GoogleHttpClient(authHeaders);

        var data = await PeopleApi(httpClient).people.connections.list(
              'people/me',
              personFields: 'names,emailAddresses',
              pageSize: 2000,
            );

        await updateContacts(data.connections);
      } else {
        _googleSignIn.signOut();
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } catch (e) {
      print(e);
      _googleSignIn.signOut();
    }
  }
}
