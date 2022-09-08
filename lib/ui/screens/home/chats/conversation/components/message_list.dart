import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/conversation_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/message_card.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/direct_connection_message_view.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/intro_message_view.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/intro_request_message_view.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/message_view.dart';
import 'package:provider/provider.dart';
import 'package:introchat/core/models/message/message.dart';

class MessageList extends StatefulWidget {
  final ScrollController scrollController;
  final String displayName;
  final bool accepted;
  final Function onAccepted;

  MessageList(this.scrollController, this.displayName, this.accepted,
      {this.onAccepted});

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  Timestamp initialView = Timestamp.now();
  // int _currentChatMessageIndex = 0;
  // int _indexAddition = 0;
  // int _initialMessagesLength = 0;

  // _scrollToBottom() {
  //   if (widget.scrollController.hasClients) {
  //     widget.scrollController.animateTo(
  //       widget.scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 1),
  //       curve: Curves.ease,
  //     );
  //   }
  // }

  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    ConversationService conversationService = ConversationService();
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<Message>>(context);
    final user = Provider.of<User>(context);

    if (messages == null) {
      return Loading();
    } else {
      // if (_currentChatMessageIndex == 0) {
      //   // _currentChatMessageIndex = messages.length;
      //   _initialMessagesLength = messages.length;
      // }

      if (widget.accepted) {
        messages.removeWhere((message) => message.displayName != null);
        // Message privateChatMessage = Message(
        //   content: 'Currently in a private chat with —',
        //   displayName: widget.displayName,
        //   created: initialView,
        // );
        // messages.add(privateChatMessage);
      }

      messages.sort((a, b) => b.created.compareTo(a.created));
      // widget.scrollController.animateTo(
      //   widget.scrollController.position.maxScrollExtent + 30,
      //   duration: Duration(milliseconds: 100),
      //   curve: Curves.easeIn,
      // );
      return NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            if (scrollInfo.scrollDelta >= 15.0) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          }

          return null;
        },
        child: ListView.builder(
          padding: EdgeInsets.only(
            top: 60.0,
          ),
          shrinkWrap: true,
          reverse: true,
          controller: widget.scrollController,
          itemCount: messages.length + (widget.accepted ? 0 : 1),
          itemBuilder: (context, index) {
            // if (messages[index].displayName != null) {
            //   return PrivateChatMessageView(displayName: widget.displayName);
            // }
            bool showDatestamp = false;
            bool showTimestamp = false;

            int calculatedIndex = max(index - (widget.accepted ? 0 : 1), 0);

            // messages[index].created.millisecondsSinceEpoch <
            //         messages[max(index - 1, 0)].created.millisecondsSinceEpoch -
            //             (60 * 60 * 1000)

            var currentDatetime = DateTime.fromMillisecondsSinceEpoch(
                messages[calculatedIndex].created.millisecondsSinceEpoch);
            var nextDateTime = DateTime.fromMillisecondsSinceEpoch(
                messages[min(calculatedIndex + 1, messages.length - 1)]
                    .created
                    .millisecondsSinceEpoch);

            var difference = currentDatetime.difference(nextDateTime).inDays;

            if (difference != 0 || calculatedIndex == messages.length - 1) {
              showDatestamp = true;
            }

            if (index == 0 && !widget.accepted) {
              return Column(
                children: <Widget>[
                  StandardCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25.0,
                        horizontal: 35.0,
                      ),
                      child: ButtonPrimary(
                        text: 'Accept',
                        color: ConstantColors.HIGHLIGHT_BLUE,
                        onPressed: () async {
                          widget.onAccepted();
                        },
                      ),
                    ),
                  ),
                  StandardCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 0.0,
                      ),
                      child: Text(
                        'Accepting lets you chat privately\nand make intros for each other.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ConstantColors.CHAT_TIMESTAMP,
                          height: 1.5,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (calculatedIndex == 0 ||
                messages[calculatedIndex].created.millisecondsSinceEpoch <
                    messages[max(calculatedIndex - 1, 0)]
                            .created
                            .millisecondsSinceEpoch -
                        (60 * 60 * 1000) ||
                messages[calculatedIndex].senderUid !=
                    messages[max(calculatedIndex - 1, 0)].senderUid) {
              showTimestamp = true;
            }

            Widget child;

            // Determine if message is incoming/outgoing/intro/request
            if (messages[calculatedIndex]?.introUid != null) {
              child = IntroMessageView(
                message: messages[calculatedIndex],
                showDatestamp: showDatestamp,
                showTimestamp: widget.accepted,
              );
            } else if (messages[calculatedIndex]?.introRequestUid != null) {
              child = IntroRequestMessageView(
                message: messages[calculatedIndex],
                showDatestamp: showDatestamp,
                showTimestamp: widget.accepted,
              );
            } else if (messages[calculatedIndex]?.directConnection != null &&
                messages[calculatedIndex].directConnection) {
              child = DirectConnectionMessageView(
                message: messages[calculatedIndex],
                showDatestamp: showDatestamp,
                showTimestamp: widget.accepted,
              );
            }

            if (child != null) {
              return MessageCard(
                child: child,
                displayName: widget.displayName,
                timestamp: messages[calculatedIndex].created,
                showDatestamp: showDatestamp,
                accepted: widget.accepted,
              );
            }

            if (messages[calculatedIndex]?.senderUid == user.uid) {
              return OutgoingMessageView(
                message: messages[calculatedIndex],
                showDatestamp: showDatestamp,
                showTimestamp: showTimestamp,
              );
            } else {
              return IncomingMessageView(
                message: messages[calculatedIndex],
                showDatestamp: showDatestamp,
                showTimestamp: showTimestamp,
              );
            }
          },
        ),
      );

      // _scrollToBottom();

      // widget.scrollController.animateTo(
      //   widget.scrollController.position.maxScrollExtent,
      //   duration: Duration(milliseconds: 100),
      //   curve: Curves.easeIn,
      // );
      // if () {

      // }

      // return LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     if (widget.scrollController.hasClients) {
      //       print(widget.scrollController.position.maxScrollExtent);
      //       if (widget.scrollController.position.maxScrollExtent >
      //           constraints.maxHeight) {
      //         return Text('BIG');
      //       } else {
      //         return Text('SMALL');
      //       }
      //     }
      //     return Text('SMALL');
      //   },
      // );

      // return listView;

      // return Column(
      //   children: <Widget>[
      //     listView,
      //     // Spacer(),
      //   ],
      // );
    }
  }
}

class PrivateChatMessageView extends StatelessWidget {
  const PrivateChatMessageView({
    Key key,
    @required this.displayName,
  }) : super(key: key);

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return StandardCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 50.0,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Currently in a private chat with —',
              style: TextStyle(
                color: ConstantColors.CHAT_TIMESTAMP,
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              displayName,
              style: TextStyle(
                color: ConstantColors.CHAT_TIMESTAMP,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
