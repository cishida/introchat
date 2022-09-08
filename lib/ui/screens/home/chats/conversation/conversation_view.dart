import 'dart:io';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/services/firestore/conversation_service.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_input.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/message_list.dart';
import 'package:introchat/ui/screens/home/components/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationView extends StatefulWidget {
  final Connection connection;

  ConversationView({
    this.connection,
  });

  @override
  _ConversationViewState createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    UserService userService = UserService();
    userService.getUserProfile(widget.connection.uid).then((profile) {
      if (mounted) {
        setState(() {
          widget.connection.userProfile = profile;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currenUserProfile = Provider.of<UserProfile>(context);
    ConversationService conversationService = ConversationService();
    ConnectionService connectionService = ConnectionService();

    widget.connection.updateLastViewed(currenUserProfile.uid);

    return MultiProvider(
      providers: [
        StreamProvider<List<Message>>.value(
          value:
              conversationService.messages(widget.connection.conversationUid),
        ),
        StreamProvider<Connection>.value(
          value: connectionService.connection(
              currenUserProfile.uid, widget.connection.uid),
        )
      ],
      child: Scaffold(
        backgroundColor: ConstantColors.PRIMARY,
        body: Consumer<Connection>(
          builder: (context, connection, child) {
            return SafeArea(
              child: connection == null
                  ? Loading()
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: MessageList(
                                  scrollController,
                                  widget.connection.userProfile?.displayName ??
                                      '',
                                  connection?.status ==
                                          ConnectionStatus.accepted ??
                                      false,
                                  onAccepted: () async {
                                    connection.userProfile =
                                        widget.connection.userProfile;
                                    await connection.accept(currenUserProfile);
                                  },
                                ),
                              ),
                              Positioned(
                                child: ConversationNavBar(
                                  widget: widget,
                                  currenUserProfile: currenUserProfile,
                                ),
                              ),
                              // Expanded(

                              // ),
                            ],
                          ),
                        ),
                        connection.status == ConnectionStatus.unaccepted
                            ? Container()
                            // Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //       vertical: 10.0,
                            //       horizontal: 30.0,
                            //     ),
                            //     child: Container(
                            //       height: 60.0,
                            //       width: double.infinity,
                            //       child: MaterialButton(
                            //         materialTapTargetSize:
                            //             MaterialTapTargetSize.shrinkWrap,
                            //         color: ConstantColors.BUTTON_PRIMARY,
                            //         child: Text(
                            //           "Accept",
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //         onPressed: () async {
                            //           connection.userProfile =
                            //               widget.connection.userProfile;
                            //           await connection
                            //               .accept(currenUserProfile);
                            //         },
                            //         shape: const StadiumBorder(),
                            //       ),
                            //     ),
                            //   )
                            : ChatInput(
                                onSubmitted: (String text, File image) async {
                                  var message;
                                  var content = text == null || text == ''
                                      ? 'Sent Image'
                                      : text;
                                  if (image != null) {
                                    message = Message(
                                      content: content,
                                      created: Timestamp.now(),
                                      senderUid: currenUserProfile.uid,
                                      recipientUids: [connection.uid],
                                      notificationContent: content,
                                      imageFile: image,
                                    );
                                  } else {
                                    message = Message(
                                      content: text,
                                      created: Timestamp.now(),
                                      senderUid: currenUserProfile.uid,
                                      recipientUids: [connection.uid],
                                      notificationContent: text,
                                    );
                                  }

                                  await connectionService
                                      .updateMostRecentActivity(
                                    senderProfile: currenUserProfile,
                                    senderMessage: content,
                                    connection: connection,
                                    receiverMessage: content,
                                  );

                                  await conversationService.sendMessage(
                                    connection.conversationUid,
                                    message,
                                  );
                                },
                              ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class ConversationNavBar extends StatefulWidget {
  const ConversationNavBar({
    Key key,
    @required this.widget,
    @required this.currenUserProfile,
  }) : super(key: key);

  final ConversationView widget;
  final UserProfile currenUserProfile;

  @override
  _ConversationNavBarState createState() => _ConversationNavBarState();
}

class _ConversationNavBarState extends State<ConversationNavBar> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstantColors.PRIMARY.withOpacity(0.90),
      height: 58,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 28.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (BuildContext context) {
                          return Profile(
                            userProfile: widget.widget.connection.userProfile,
                          );
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      UserImage(
                        radius: 21.0,
                        url: widget.widget.connection.userProfile?.photoUrl,
                        bordered: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.widget.connection.userProfile?.displayName ??
                              '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (!_disabled) {
                      setState(() {
                        _disabled = true;
                      });
                      await widget.widget.connection
                          .updateLastViewed(widget.currenUserProfile.uid);
                      Navigator.pop(context);
                      setState(() {
                        _disabled = false;
                      });
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Underline(),
        ],
      ),
    );
  }
}
