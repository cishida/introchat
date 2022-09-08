import 'dart:async';

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
import 'package:introchat/core/utils/constants/strings.dart';
import 'package:introchat/core/utils/helpers/contact_connection_helper.dart';
import 'package:introchat/ui/components/card/tips_card.dart';
import 'package:introchat/ui/components/contacts/contact_nav_bar.dart';
import 'package:introchat/ui/components/contacts/contact_search_bar.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/ui/components/skeletons/contacts_skeleton.dart';
import 'package:introchat/ui/components/sync/sync_loader.dart';
import 'package:introchat/ui/components/sync_tile.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/choose_contacts/components/contact_tile.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/intro_empty/intro_empty.dart';
import 'package:provider/provider.dart';

class ChooseContacts extends StatefulWidget {
  ChooseContacts({
    Key key,
  }) : super(key: key);

  @override
  _ChooseContactsState createState() => _ChooseContactsState();
}

class _ChooseContactsState extends State<ChooseContacts> {
  List<IntrochatContact> _contacts = [];
  bool _isLoading = false;
  int _remainingContacts = 2;
  TextEditingController _controller = TextEditingController();
  String _filter;
  IntrochatContactService _introchatContactService;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _filter = _controller.text;
        });
      }
    });

    _loadContacts();
  }

  _loadContacts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    AuthService auth = FirebaseAuthService();
    var user = await auth.currentUser();
    _introchatContactService = IntrochatContactService(uid: user.uid);

    _contacts = await _introchatContactService.getIntrochatContacts();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _syncContacts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    if (_introchatContactService == null) {
      AuthService auth = FirebaseAuthService();
      var user = await auth.currentUser();
      _introchatContactService = IntrochatContactService(uid: user.uid);
    }

    await _introchatContactService.syncGoogleContacts();
    _contacts = await _introchatContactService.getIntrochatContacts();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _onContactSelect(IntrochatContact contact, int index) {
    if (!_contacts[index].isChecked &&
        _contacts.where((contact) => contact.isChecked).length > 0) {
      final List<IntrochatContact> selectedContacts = [
        _contacts.where((contact) => contact.isChecked).first,
        _contacts[index]
      ];
      Navigator.pushNamed(
        context,
        ConstantRoutes.ContactConfirmation,
        arguments: selectedContacts,
      );
    } else {
      if (mounted) {
        setState(() {
          _contacts[index].isChecked = !_contacts[index].isChecked;
          _remainingContacts =
              2 - _contacts.where((contact) => contact.isChecked).length;
        });
      }
    }
  }

  _showSyncLoadingDialog(BuildContext context, GlobalKey key) {
    Navigator.of(context).push(MaterialPageRoute<String>(
      builder: (BuildContext context) {
        return SyncLoader(key: key);
      },
      fullscreenDialog: true,
    ));
  }

  _pressedSync() async {
    _showSyncLoadingDialog(
      context,
      _keyLoader,
    );
    await _syncContacts();
    Navigator.of(
      _keyLoader.currentContext,
      rootNavigator: true,
    ).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    final connections = Provider.of<List<Connection>>(context, listen: false);

    if (userProfile == null) {
      return Loading();
      // } else if (userProfile.makeIntroOnboarding == null ||
      //     !userProfile.makeIntroOnboarding) {
      //   return IntroEmpty();
    } else {
      String title = 'Choose $_remainingContacts to Intro';

      return StreamProvider<List<IntrochatContact>>.value(
        value: IntrochatContactService(uid: userProfile.uid).introchatContacts,
        child: Scaffold(
          backgroundColor: ConstantColors.PRIMARY,
          body: SafeArea(
            child: Consumer<List<IntrochatContact>>(
              builder: (context, introchatContacts, child) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ContactNavBar(title: title),
                      ContactSearchBar(controller: _controller),
                      Expanded(
                        child: _isLoading
                            ? ContactsSkeleton()
                            : ListView.builder(
                                itemCount: _contacts.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == _contacts?.length) {
                                    return TipsCard(
                                      title:
                                          ConstantStrings.MAKE_INTRO_TIPS_TITLE,
                                      tips: ConstantStrings.MAKE_INTRO_TIPS,
                                      onPressed: _pressedSync,
                                    );

                                    // return GestureDetector(
                                    //   onTap: () async {

                                    // setState(() {
                                    //   _isLoading = true;
                                    // });
                                    // showDialog(
                                    //   context: context,
                                    //   barrierDismissible: false,
                                    //   builder: (BuildContext context) {
                                    //     return Dialog(
                                    //       child: Row(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           CircularProgressIndicator(),
                                    //           Text("Loading"),
                                    //         ],
                                    //       ),
                                    //     );
                                    //   },
                                    // );

                                    // Dialogs.showLoadingDialog(
                                    //   context,
                                    //   _keyLoader,
                                    //   height: MediaQuery.of(context)
                                    //       .size
                                    //       .height,
                                    //   width:
                                    //       MediaQuery.of(context).size.width,
                                    // );

                                    // setState(() {
                                    //   _isLoading = false;
                                    // });
                                    // },
                                    // child: SyncTile(),
                                    // );
                                  } else if (_filter == null ||
                                      _filter == '' ||
                                      _contacts[index]
                                          .getCorrectDisplayName(
                                              userProfile.uid)
                                          .toLowerCase()
                                          .contains(_filter.toLowerCase())) {
                                    return ContactTile(
                                      contact: _contacts[index],
                                      connected: ContactConnectionHelper
                                          .isContactConnected(
                                        _contacts[index],
                                        connections,
                                      ),
                                      onContactSelect: (contact) {
                                        _onContactSelect(contact, index);
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
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

  // refreshContacts() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   AuthService auth = FirebaseAuthService();
  //   var user = await auth.currentUser();
  //   IntrochatContactService introchatContactService =
  //       IntrochatContactService(uid: user.uid);

  //   try {
  //     // List responses = await Future.wait([
  //     await updateContacts(introchatContactService);
  //     _contacts = await introchatContactService.getIntrochatContacts();
  //     // ]);
  //     // _contacts = responses.last;
  //   } catch (e) {
  //     print(e);
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
