import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/auth/firebase_auth_service.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/core/utils/helpers/contact_connection_helper.dart';
import 'package:introchat/ui/components/contacts/contact_nav_bar.dart';
import 'package:introchat/ui/components/contacts/contact_search_bar.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/skeletons/contacts_skeleton.dart';
import 'package:introchat/ui/components/sync/sync_loader.dart';
import 'package:introchat/ui/components/sync_tile.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/choose_contacts/components/contact_tile.dart';
import 'package:provider/provider.dart';

class NewChatContacts extends StatefulWidget {
  NewChatContacts({
    Key key,
  }) : super(key: key);

  @override
  _NewChatContactsState createState() => _NewChatContactsState();
}

class _NewChatContactsState extends State<NewChatContacts> {
  bool _isLoading = false;
  List<IntrochatContact> _introchatContacts = [];
  TextEditingController _controller = TextEditingController();
  ConnectionService _connectionService = ConnectionService();
  IntrochatContactService _introchatContactService;
  String _filter;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _filter = _controller.text;
      });
    });

    _loadContacts();
  }

  _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    AuthService auth = FirebaseAuthService();
    var user = await auth.currentUser();
    _introchatContactService = IntrochatContactService(uid: user.uid);

    _introchatContacts = await _introchatContactService.getIntrochatContacts();

    // if (_introchatContacts.length == 0) {
    //   Navigator.pushNamed(
    //     context,
    //     ConstantRoutes.IntroEmpty,
    //   );
    // }

    setState(() {
      _isLoading = false;
    });
  }

  _syncContacts() async {
    setState(() {
      _isLoading = true;
    });

    if (_introchatContactService == null) {
      AuthService auth = FirebaseAuthService();
      var user = await auth.currentUser();
      _introchatContactService = IntrochatContactService(uid: user.uid);
    }

    await _introchatContactService.syncGoogleContacts();
    _introchatContacts = await _introchatContactService.getIntrochatContacts();

    setState(() {
      _isLoading = false;
    });
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });

    AuthService auth = FirebaseAuthService();
    var user = await auth.currentUser();
    IntrochatContactService introchatContactService =
        IntrochatContactService(uid: user.uid);

    await introchatContactService.syncGoogleContacts();
    _introchatContacts = await introchatContactService.getIntrochatContacts();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _requestConnection(
      String currentUserId, IntrochatContact introchatContact) async {
    await _connectionService.requestConnection(
      currentUserId,
      introchatContact,
    );

    String flushText = 'Request Sent';
    Navigator.popUntil(
      context,
      ModalRoute.withName(ConstantRoutes.Root),
    );
    Flush.createFlush(flushText)..show(context);
  }

  _goToConversation(Connection connection) {
    Navigator.pushNamed(
      context,
      ConstantRoutes.Conversation,
      arguments: connection,
    );
  }

  _goToEmailInvite(String currentUserId, IntrochatContact introchatContact) {
    Navigator.popUntil(
      context,
      ModalRoute.withName(ConstantRoutes.NewChatContacts),
    );

    if (introchatContact.userId == null) {
      Navigator.pushNamed(
        context,
        ConstantRoutes.EmailInvite,
        arguments: introchatContact,
      );

      _connectionService.createConnectionWithPreUser(
        currentUserId,
        introchatContact,
      );
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

  @override
  Widget build(BuildContext context) {
    final connections = Provider.of<List<Connection>>(context);
    final userProfile = Provider.of<UserProfile>(context);
    final introchatContacts = Provider.of<List<IntrochatContact>>(context);

    String title = 'Choose Contact to Connect';
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              ContactNavBar(title: title),
              ContactSearchBar(controller: _controller),
              Expanded(
                child: _isLoading
                    ? ContactsSkeleton()
                    : ListView.builder(
                        itemCount: introchatContacts.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == introchatContacts.length) {
                            return GestureDetector(
                              onTap: () async {
                                // setState(() {
                                //   _isLoading = true;
                                // });
                                _showSyncLoadingDialog(
                                  context,
                                  _keyLoader,
                                );
                                await _syncContacts();
                                // setState(() {
                                //   _isLoading = false;
                                // });
                                Navigator.of(
                                  _keyLoader.currentContext,
                                  rootNavigator: true,
                                ).pop();
                              },
                              child: SyncTile(),
                            );
                          }
                          if (_filter == null ||
                              _filter == '' ||
                              introchatContacts[index]
                                  .getCorrectDisplayName(userProfile.uid)
                                  .toLowerCase()
                                  .contains(_filter.toLowerCase())) {
                            return ContactTile(
                              contact: introchatContacts[index],
                              connected:
                                  ContactConnectionHelper.isContactConnected(
                                introchatContacts[index],
                                connections,
                              ),
                              onContactSelect: (introchatContact) {
                                if (introchatContact.userId != null) {
                                  bool connected = false;
                                  for (var connection in connections) {
                                    if (connection.uid ==
                                        introchatContact.userId) {
                                      connected = true;
                                      if (connection.status !=
                                          ConnectionStatus.pending) {
                                        _goToConversation(connection);
                                      } else {
                                        Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              ConstantRoutes.Root),
                                        );
                                      }
                                      break;
                                    }
                                  }
                                  if (!connected) {
                                    _requestConnection(
                                      userProfile.uid,
                                      introchatContact,
                                    );
                                  }
                                } else {
                                  _goToEmailInvite(
                                    userProfile.uid,
                                    introchatContact,
                                  );
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
              ),
              // _isLoading
              //     ? Loading()
              //     : Expanded(
              //         child: ListView.builder(
              //           itemCount: _introchatContacts?.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             if (_filter == null ||
              //                 _filter == '' ||
              //                 _introchatContacts[index]
              //                     .getCorrectDisplayName(userProfile.uid)
              //                     .toLowerCase()
              //                     .contains(_filter.toLowerCase())) {
              //               return ContactTile(
              //                 contact: _introchatContacts[index],
              //                 onContactSelect: (introchatContact) {
              //                   if (introchatContact.userId != null) {
              //                     bool connected = false;
              //                     for (var connection in connections) {
              //                       if (connection.uid ==
              //                           introchatContact.userId) {
              //                         connected = true;
              //                         if (connection.status !=
              //                             ConnectionStatus.pending) {
              //                           _goToConversation(connection);
              //                         } else {
              //                           Navigator.popUntil(
              //                             context,
              //                             ModalRoute.withName(
              //                                 ConstantRoutes.Root),
              //                           );
              //                         }
              //                         break;
              //                       }
              //                     }
              //                     if (!connected) {
              //                       _requestConnection(
              //                         userProfile.uid,
              //                         introchatContact,
              //                       );
              //                     }
              //                   } else {
              //                     _goToEmailInvite(
              //                       userProfile.uid,
              //                       introchatContact,
              //                     );
              //                   }
              //                 },
              //               );
              //             } else {
              //               return Container();
              //             }
              //           },
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
