import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/services/google/google_http_client.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/screens/home/components/email_invite/email_invite.dart';
import 'package:introchat/ui/screens/home/components/profile/profile.dart';
import 'package:introchat/ui/screens/home/search/request_connection/request_connection.dart';
import 'package:provider/provider.dart';

class AddContact extends StatefulWidget {
  const AddContact({
    Key key,
  }) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  var instance = Firestore.instance;
  final CollectionReference introchatContactCollection =
      Firestore.instance.collection('introchatContacts');
  Map<String, String> _contact = {
    'firstName': '',
    'lastName': '',
    'email': '',
  };

  updateContact(String key, String text) {
    if (mounted) {
      setState(() {
        _contact[key] = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_contact['email'] == null ||
                          _contact['email'] == '' ||
                          !EmailValidator.validate(_contact['email'])) {
                        print('Invalid email');
                        return;
                      }

                      createGoogleContact();
                      await createIntrochatContact();
                    },
                    child: Image.asset(
                      'assets/images/done-button.png',
                      height: 36.0,
                    ),
                  ),
                ],
              ),
            ),
            StandardCard(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 23.0,
                      top: 10.0,
                      bottom: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/add-contact-icon.png',
                          height: 16.0,
                          width: 13.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Add Contact',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: ConstantColors.CHAT_TIMESTAMP,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AddContactInput(
                    placeholder: 'First Name',
                    contactKey: 'firstName',
                    update: updateContact,
                  ),
                  AddContactInput(
                    placeholder: 'Last Name',
                    contactKey: 'lastName',
                    update: updateContact,
                  ),
                  AddContactInput(
                    placeholder: 'Email Address',
                    contactKey: 'email',
                    update: updateContact,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            StandardCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Adding this contact here also saves\nthem in your Google Contacts.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantColors.CHAT_TIMESTAMP,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToRequestConnection(IntrochatContact introchatContact) async {
    UserService userService = UserService();
    UserProfile userProfile =
        await userService.getUserProfile(introchatContact.userId);

    Navigator.of(context).pop(null);

    Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return RequestConnection(
            userProfile: userProfile,
            introchatContact: introchatContact,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  void _goToEmailInvite(IntrochatContact introchatContact) {
    Navigator.popUntil(
      context,
      ModalRoute.withName(ConstantRoutes.Root),
    );

    if (introchatContact.userId == null) {
      Navigator.of(context).push(
        MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return EmailInvite(
              contact: introchatContact,
            );
          },
          fullscreenDialog: true,
        ),
      );
    }
  }

  _goToConnection(Connection connection) async {
    UserService userService = UserService();
    UserProfile userProfile = await userService.getUserProfile(connection.uid);

    Navigator.of(context).pop(null);

    Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return Profile(
            userProfile: userProfile,
            connection: connection,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  Future createIntrochatContact() async {
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    final connections = Provider.of<List<Connection>>(context, listen: false);
    var introchatContactDocument = introchatContactCollection.document();
    var batch = instance.batch();
    String displayName;

    if (_contact['firstName'] != '' || _contact['lastName'] != '') {
      displayName = _contact['firstName'] + ' ' + _contact['lastName'];
    } else {
      displayName = _contact['email'].toLowerCase();
    }

    var route = 'email';
    IntrochatContact introchatContact;
    Connection enteredConnection;

    var snapshot = await introchatContactCollection
        .where('email', isEqualTo: _contact['email'].toLowerCase())
        .getDocuments();
    if (snapshot.documents.length > 0) {
      var introchatDoc = snapshot.documents.first;
      introchatContact = IntrochatContact.fromJson(
        introchatDoc.documentID,
        introchatDoc.data,
      );

      if (introchatContact.userContactNames == null) {
        introchatContact.userContactNames = {};
      }

      if (introchatContact.userId != null) {
        route = 'request';
      }

      for (var connection in connections) {
        if (connection.uid == introchatContact.userId &&
            connection.status != ConnectionStatus.pending) {
          route = 'connected';
          enteredConnection = connection;
          break;
        }
      }

      introchatContact.userContactNames[userProfile.uid] = displayName;
      batch.updateData(
        introchatContactCollection.document(introchatContact.uid),
        introchatContact.toJson(),
      );
    } else {
      introchatContact = IntrochatContact(
        displayName: displayName,
        email: _contact['email'].toLowerCase(),
        created: Timestamp.now(),
        // connectedUserIds: [uid],
        userContactNames: {userProfile.uid: displayName},
      );

      batch.setData(introchatContactDocument, introchatContact.toJson());
    }

    await batch.commit();
    FocusScope.of(context).unfocus();
    switch (route) {
      case 'email':
        _goToEmailInvite(introchatContact);
        break;
      case 'request':
        _goToRequestConnection(introchatContact);
        break;
      case 'connected':
        await _goToConnection(enteredConnection);
        break;
      default:
        _goToEmailInvite(introchatContact);
    }
    return null;
  }

  void createGoogleContact() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts',
        'https://www.googleapis.com/auth/userinfo.email',
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

        var person = Person.fromJson(
          {
            'names': [
              {
                'givenName': _contact['firstName'],
                'familyName': _contact['lastName'],
              },
            ],
            'emailAddresses': [
              {'value': _contact['email'].toLowerCase()}
            ]
          },
        );

        var returnPerson =
            await PeopleApi(httpClient).people.createContact(person);
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

class AddContactInput extends StatelessWidget {
  const AddContactInput({
    Key key,
    this.placeholder,
    this.contactKey,
    this.update,
  }) : super(key: key);

  final String placeholder;
  final String contactKey;
  final Function(String, String) update;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 25.0,
      ),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 20.0,
          ),
          hintText: placeholder,
          hintStyle: TextStyle(
            color: ConstantColors.CHAT_TIMESTAMP,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
        onChanged: (text) {
          update(contactKey, text);
        },
      ),
    );
  }
}
