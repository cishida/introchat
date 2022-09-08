import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/core/utils/constants/strings.dart';
import 'package:introchat/core/utils/formatters/email_formatter.dart';
import 'package:introchat/core/utils/helpers/contact_connection_helper.dart';
import 'package:introchat/ui/components/card/tips_card.dart';
import 'package:introchat/ui/components/contacts/contact_nav_bar.dart';
import 'package:introchat/ui/components/contacts/contact_search_bar.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/skeletons/contacts_skeleton.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/intro/choose_contacts/components/contact_tile.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_empty/request_empty.dart';
import 'package:provider/provider.dart';

class RequestContacts extends StatefulWidget {
  RequestContacts({
    Key key,
    @required this.connections,
    @required this.changeTab,
  }) : super(key: key);

  final List<Connection> connections;
  final Function(int) changeTab;

  @override
  _RequestContactsState createState() => _RequestContactsState();
}

class _RequestContactsState extends State<RequestContacts> {
  bool _isLoading = false;
  List<IntrochatContact> introchatContacts = [];
  TextEditingController _controller = TextEditingController();
  String _filter;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _filter = _controller.text;
      });
    });

    _getExtendedContacts();
  }

  _getExtendedContacts() async {
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    IntrochatContactService introchatContactService = IntrochatContactService();

    setState(() {
      _isLoading = true;
    });
    List<Connection> acceptedConnections = widget.connections
        .where((connection) => connection.status == ConnectionStatus.accepted)
        .toList();

    List<String> connectionIds = acceptedConnections.map((connection) {
      return connection.uid;
    }).toList();

    // final connections = Provider.of<List<Connection>>(context);
    List<IntrochatContact> tempAllContacts = [];
    for (var connection in acceptedConnections) {
      var tempContacts = await introchatContactService.getIntrochatContacts(
        userId: connection.uid,
      );
      for (var introchatContact in tempContacts) {
        introchatContact.displayName =
            introchatContact.userContactNames[connection.uid];
        introchatContact.domain =
            EmailFormatter.getDomain(introchatContact.email);
      }
      tempAllContacts.addAll(tempContacts
          .where((contact) =>
              !connectionIds.contains(contact.userId) &&
              contact.userId != userProfile.uid)
          .toList());
    }

    // if (tempAllContacts.length == 0) {
    //   Navigator.pushNamed(context, ConstantRoutes.RequestEmpty);
    // }

    setState(() {
      _isLoading = false;
      introchatContacts = tempAllContacts;
    });
  }

  _onContactSelect(IntrochatContact introchatContact) {
    Navigator.pushNamed(
      context,
      ConstantRoutes.RequestAsk,
      arguments: introchatContact,
    );
  }

  // Widget _buildGroupSeparator(dynamic groupByValue) {
  //   return Container(
  //     color: ConstantColors.SECONDARY,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(
  //         vertical: 8.0,
  //         horizontal: 15.0,
  //       ),
  //       child: Text(
  //         groupByValue,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 18.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildItem(BuildContext context, IntrochatContact element) {
  //   final connections = Provider.of<List<Connection>>(context, listen: false);

  //   if (_filter == null ||
  //       _filter == '' ||
  //       element.displayName.toLowerCase().contains(_filter.toLowerCase())) {
  //     return ContactTile(
  //       contact: element,
  //       connected: ContactConnectionHelper.isContactConnected(
  //         element,
  //         connections,
  //       ),
  //       onContactSelect: (introchatContact) {
  //         _onContactSelect(introchatContact);
  //       },
  //       showEmail: false,
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

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
    bool showUnderline,
  ) {
    final displayName =
        introchatContact.getCorrectDisplayName(user.uid).toLowerCase();
    if (_filter == null ||
        _filter == '' ||
        displayName.contains(_filter.toLowerCase())) {
      return ContactTile(
        contact: introchatContact,
        connected: false,
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
    String title = 'Choose who you want to meet';
    final userProfile = Provider.of<UserProfile>(context);

    introchatContacts.sort((a, b) {
      return a
          .getCorrectDisplayName(userProfile.uid)
          .toLowerCase()
          .compareTo(b.getCorrectDisplayName(userProfile.uid).toLowerCase());
    });

    if (userProfile == null) {
      return Loading();
      // } else if (userProfile.requestIntroOnboarding == null ||
      //     !userProfile.requestIntroOnboarding) {
      //   return RequestEmpty();
    } else {
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
                      :
                      // GroupedListView(
                      //     elements: introchatContacts,
                      //     groupBy: (element) => element.domain,
                      //     groupSeparatorBuilder: _buildGroupSeparator,
                      //     itemBuilder: (context, element) =>
                      //         _buildItem(context, element),
                      //     // Text(element.displayName),
                      //     order: GroupedListOrder.ASC,
                      //   ),
                      ListView.builder(
                          // Add one to itemCount for tips card
                          itemCount: introchatContacts.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == introchatContacts.length) {
                              return TipsCard(
                                title: ConstantStrings.REQUEST_INTRO_TIPS_TITLE,
                                tips: ConstantStrings.REQUEST_INTRO_TIPS,
                                changeTab: widget.changeTab,
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
                            var nextGroupLetter = index ==
                                    introchatContacts.length - 1
                                ? null
                                : introchatContacts[index + 1]
                                    .getCorrectDisplayName(userProfile.uid)[0]
                                    .toUpperCase();

                            List<Widget> widgets = [];

                            bool userSearching =
                                _filter != null && _filter != '';

                            // If user not searching
                            if (!userSearching &&
                                (index == 0 ||
                                    previousGroupLetter !=
                                        currentGroupLetter)) {
                              widgets.add(
                                  _buildGroupSeparator(currentGroupLetter));
                            }

                            widgets.add(_buildItem(
                              context,
                              userProfile,
                              introchatContacts[index],
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
