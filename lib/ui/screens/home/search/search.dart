import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/auth/firebase_auth_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/core/utils/constants/strings.dart';
import 'package:introchat/core/utils/helpers/contact_connection_helper.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/card/tip_row.dart';
import 'package:introchat/ui/components/card/tips_card.dart';
import 'package:introchat/ui/components/contacts/contact_search_bar.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/sync/sync_loader.dart';
import 'package:introchat/ui/screens/home/search/request_connection/request_connection.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/choose_contacts/components/contact_tile.dart';
import 'package:introchat/ui/screens/home/components/profile/profile.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
  }

  _syncContacts() async {
    if (_introchatContactService == null) {
      AuthService auth = FirebaseAuthService();
      var user = await auth.currentUser();
      _introchatContactService = IntrochatContactService(uid: user.uid);
    }

    await _introchatContactService.syncGoogleContacts();
  }

  _pressedSync() async {
    Navigator.of(context).push(MaterialPageRoute<String>(
      builder: (BuildContext context) {
        return SyncLoader(key: _keyLoader);
      },
      fullscreenDialog: true,
    ));

    await _syncContacts();
    Navigator.of(
      _keyLoader.currentContext,
      rootNavigator: true,
    ).pop();
  }

  _goToConnection(Connection connection) async {
    UserService userService = UserService();
    UserProfile userProfile = await userService.getUserProfile(connection.uid);

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

  _goToRequestConnection(IntrochatContact introchatContact) async {
    UserService userService = UserService();
    UserProfile userProfile =
        await userService.getUserProfile(introchatContact.userId);

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

  _goToEmailInvite(String currentUserId, IntrochatContact introchatContact) {
    Navigator.popUntil(
      context,
      ModalRoute.withName(ConstantRoutes.Root),
    );

    if (introchatContact.userId == null) {
      Navigator.pushNamed(
        context,
        ConstantRoutes.EmailInvite,
        arguments: introchatContact,
      );
    }
  }

  _onContactSelect(IntrochatContact introchatContact) async {
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    final connections = Provider.of<List<Connection>>(context, listen: false);

    if (introchatContact.userId != null) {
      bool connected = false;
      for (var connection in connections) {
        if (connection.uid == introchatContact.userId) {
          connected = true;
          if (connection.status != ConnectionStatus.pending) {
            await _goToConnection(connection);
          }
          break;
        }
      }
      if (!connected) {
        await _goToRequestConnection(
          introchatContact,
        );
      }
    } else {
      _goToEmailInvite(
        userProfile.uid,
        introchatContact,
      );
    }
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    if (groupByValue == 'end') {
      return Container();
    }
    return Container(
      color: ConstantColors.SECONDARY,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 25.0,
        ),
        child: Text(
          groupByValue,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    UserProfile user,
    IntrochatContact introchatContact,
    bool connected,
    bool showUnderline,
  ) {
    final displayName =
        introchatContact.getCorrectDisplayName(user.uid).toLowerCase();
    if (_filter == null ||
        _filter == '' ||
        displayName.contains(_filter.toLowerCase())) {
      return ContactTile(
        contact: introchatContact,
        connected: connected,
        showUnderline: showUnderline,
        onContactSelect: (introchatContact) {
          _onContactSelect(introchatContact);
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    final connections = Provider.of<List<Connection>>(context);
    final introchatContacts = Provider.of<List<IntrochatContact>>(context);

    if (userProfile == null || introchatContacts == null) {
      return Loading();
    } else {
      return Scaffold(
        backgroundColor: ConstantColors.PRIMARY,
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                ContactSearchBar(controller: _controller),
                Expanded(
                  child: ListView.builder(
                    // Add one to itemCount for tips card
                    itemCount: introchatContacts.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == introchatContacts.length) {
                        return TipsCard(
                          title: ConstantStrings.SEARCH_TIPS_TITLE,
                          tips: ConstantStrings.SEARCH_TIPS,
                          onPressed: _pressedSync,
                        );
                      }

                      var currentGroupLetter = introchatContacts[index]
                          .getCorrectDisplayName(userProfile.uid)[0]
                          .toUpperCase();
                      var previousGroupLetter = index == 0
                          ? null
                          : introchatContacts[index - 1]
                              .getCorrectDisplayName(userProfile.uid)[0]
                              .toUpperCase();
                      var nextGroupLetter =
                          index == introchatContacts.length - 1
                              ? null
                              : introchatContacts[index + 1]
                                  .getCorrectDisplayName(userProfile.uid)[0]
                                  .toUpperCase();

                      List<Widget> widgets = [];

                      bool userSearching = _filter != null && _filter != '';

                      // If user not searching
                      if (!userSearching &&
                          (index == 0 ||
                              previousGroupLetter != currentGroupLetter)) {
                        widgets.add(_buildGroupSeparator(currentGroupLetter));
                      }

                      widgets.add(_buildItem(
                        context,
                        userProfile,
                        introchatContacts[index],
                        ContactConnectionHelper.isContactConnected(
                          introchatContacts[index],
                          connections,
                        ),
                        currentGroupLetter == nextGroupLetter ||
                            userSearching ||
                            index == introchatContacts.length - 1,
                      ));

                      return Column(
                        children: widgets,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

// class SyncCard extends StatelessWidget {
//   const SyncCard({
//     Key key,
//     this.onPressed,
//   }) : super(key: key);

//   final Function onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return StandardCard(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 25.0,
//           horizontal: 35.0,
//         ),
//         child: ButtonPrimary(
//           text: 'Sync with Google Contacts',
//           onPressed: onPressed,
//         ),
//       ),
//     );
//   }
// }

// class SearchTipsCard extends StatelessWidget {
//   const SearchTipsCard({
//     Key key,
//     this.onPressed,
//   }) : super(key: key);

//   final Function onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 60.0,
//         bottom: 0.0,
//       ),
//       child: StandardCard(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 30.0,
//             bottom: 10.0,
//             left: 20.0,
//             right: 20.0,
//           ),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 '',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 32.0,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               TipRow(
//                 text:
//                     'Your Search tab helps you find people you’ve met here or saved in Google Contacts.',
//               ),
//               TipRow(
//                 text:
//                     'Search lets you go to any saved contact, connect instantly, and start sharing intros.',
//               ),
//               TipRow(
//                 text:
//                     'To get started, you can Sync with Google Contacts below or add a new contact above.',
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 25.0,
//                   horizontal: 15.0,
//                 ),
//                 child: ButtonPrimary(
//                   text: 'Sync with Google Contacts',
//                   onPressed: onPressed,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SearchTipRow extends StatelessWidget {
//   const SearchTipRow({
//     Key key,
//     @required this.text,
//   }) : super(key: key);

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 15.0,
//         left: 20.0,
//         right: 20.0,
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 17.0,
//         ),
//       ),
//     );
//   }
// }
