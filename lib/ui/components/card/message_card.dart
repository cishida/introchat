import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_datestamp.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_timestamp.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/message_list.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    Key key,
    this.displayName,
    this.timestamp,
    this.showDatestamp,
    this.accepted,
    @required this.child,
  }) : super(key: key);

  final String displayName;
  final Timestamp timestamp;
  final bool showDatestamp;
  final bool accepted;
  final Widget child;

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        !widget.showDatestamp
            ? Container()
            : ChatDatestamp(
                timestamp: widget.timestamp,
              ),
        widget.child,
        widget.accepted
            ? PrivateChatMessageView(displayName: widget.displayName)
            : Container(),
        !widget.accepted
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ChatTimestamp(
                    timestamp: widget.timestamp,
                  ),
                ),
              ),
      ],
    );
  }
}
