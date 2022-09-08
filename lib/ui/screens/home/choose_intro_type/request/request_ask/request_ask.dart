import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/contacts/contact_nav_bar.dart';
import 'package:introchat/ui/components/empty_image.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/request/request_message/request_message.dart';
import 'package:provider/provider.dart';

class RequestAsk extends StatefulWidget {
  RequestAsk({
    Key key,
    @required this.introchatContact,
  }) : super(key: key);

  final IntrochatContact introchatContact;

  @override
  _RequestAskState createState() => _RequestAskState();
}

class _RequestAskState extends State<RequestAsk> {
  bool _isLoading = false;
  // List<UserProfile> requestableConnections = [];
  List<Connection> requestableConnections = [];

  @override
  void initState() {
    super.initState();

    _setConnections();
  }

  _setConnections() async {
    setState(() {
      _isLoading = true;
    });

    // final userProfile = Provider.of<UserProfile>(context, listen: false);
    final connections = Provider.of<List<Connection>>(context, listen: false);

    List<Connection> tempRequestables = [];
    UserService userService = UserService();
    for (var connection in connections) {
      if (widget.introchatContact.userContactNames
          .containsKey(connection.uid)) {
        connection.userProfile =
            await userService.getUserProfile(connection.uid);
        tempRequestables.add(connection);
      }
    }

    setState(() {
      _isLoading = false;
      requestableConnections = tempRequestables;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      // appBar: AppBar(
      //   title: Text(),
      // ),
      body: _isLoading
          ? Loading()
          : SafeArea(
              child: Column(
                children: <Widget>[
                  ContactNavBar(title: 'Choose who you want to ask'),
                  Underline(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: requestableConnections?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ConstantRoutes.RequestMessage,
                              arguments: RequestMessageArgs(
                                widget.introchatContact,
                                requestableConnections[index],
                              ),
                            );
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 9.0,
                                  horizontal: 18.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    UserImage(
                                      radius: 30.0,
                                      url: requestableConnections[index]
                                          .userProfile
                                          .photoUrl,
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Text(
                                      requestableConnections[index].uid == null
                                          ? (requestableConnections[index]
                                                  .userProfile
                                                  .displayName ??
                                              '')
                                          : (requestableConnections[index]
                                                  .userProfile
                                                  ?.displayName ??
                                              ''),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 99.0,
                                  right: 18.0,
                                ),
                                child: Underline(),
                              ),
                            ],
                          ),
                        );
                        // return Column(
                        //   children: <Widget>[
                        //     ListTile(
                        //       contentPadding: EdgeInsets.symmetric(
                        //         vertical: 10.0,
                        //         horizontal: 10.0,
                        //       ),
                        //       leading:
                        //           UserImage(
                        //         url: requestableConnections[index]
                        //             .userProfile
                        //             .photoUrl,
                        //         radius: 30.0,
                        //       ),
                        //       title: Text(
                        //         requestableConnections[index].uid == null
                        //             ? (requestableConnections[index]
                        //                     .userProfile
                        //                     .displayName ??
                        //                 '')
                        //             : (requestableConnections[index]
                        //                     .userProfile
                        //                     ?.displayName ??
                        //                 ''),
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 18.0,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       onTap: () {
                        //         Navigator.pushNamed(
                        //           context,
                        //           ConstantRoutes.RequestMessage,
                        //           arguments: RequestMessageArgs(
                        //             widget.introchatContact,
                        //             requestableConnections[index],
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //     Padding(
                        //       padding: EdgeInsets.only(left: 85.0),
                        //       child: Underline(),
                        //     ),
                        //   ],
                        // );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
