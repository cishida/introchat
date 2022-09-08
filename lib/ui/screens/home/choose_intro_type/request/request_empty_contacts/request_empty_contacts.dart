import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/auth/firebase_auth_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/services/google/google_http_client.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/core/utils/helpers/contact_connection_helper.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/choose_contacts/components/contact_tile.dart';
import 'package:provider/provider.dart';

class RequestEmptyContacts extends StatefulWidget {
  RequestEmptyContacts({
    Key key,
  }) : super(key: key);

  @override
  _RequestEmptyContactsState createState() => _RequestEmptyContactsState();
}

class _RequestEmptyContactsState extends State<RequestEmptyContacts> {
  List<IntrochatContact> _contacts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    final connections = Provider.of<List<Connection>>(context);

    return StreamProvider<List<IntrochatContact>>.value(
      value: IntrochatContactService(uid: userProfile.uid).introchatContacts,
      child: Scaffold(
        backgroundColor: ConstantColors.PRIMARY,
        appBar: AppBar(
          title: Text('Choose contact to connect'),
        ),
        body: _isLoading
            ? Loading()
            : Consumer<List<IntrochatContact>>(
                builder: (context, introchatContacts, child) {
                  return Container(
                    child: ListView.builder(
                      itemCount: _contacts?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ContactTile(
                          contact: _contacts[index],
                          connected: ContactConnectionHelper.isContactConnected(
                            _contacts[index],
                            connections,
                          ),
                          onContactSelect: (contact) {
                            Navigator.pushNamed(
                              context,
                              ConstantRoutes.EmailInvite,
                              arguments: contact,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> updateContacts(
      IntrochatContactService introchatContactService) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts',
        "https://www.googleapis.com/auth/userinfo.email",
      ],
    );

    final GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authHeaders = await _googleSignIn.currentUser.authHeaders;

        final httpClient = GoogleHttpClient(authHeaders);

        var data = await PeopleApi(httpClient).people.connections.list(
              'people/me',
              personFields: 'names,emailAddresses',
              pageSize: 100,
            );

        await introchatContactService.updateContacts(data.connections);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      _googleSignIn.signOut();
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });

    AuthService auth = FirebaseAuthService();
    var user = await auth.currentUser();
    IntrochatContactService introchatContactService =
        IntrochatContactService(uid: user.uid);

    try {
      await updateContacts(introchatContactService);
      _contacts = await introchatContactService.getIntrochatContacts();
      // List responses = await Future.wait([
      //   updateContacts(introchatContactService),
      //   introchatContactService.getIntrochatContacts(),
      // ]);
      // _contacts = responses.last;
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
