import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_datestamp.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_timestamp.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/full_screen_photo_view.dart';

class IncomingMessageView extends StatelessWidget {
  const IncomingMessageView({
    Key key,
    @required this.message,
    @required this.showDatestamp,
    @required this.showTimestamp,
  }) : super(key: key);

  final Message message;
  final bool showDatestamp;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        !showDatestamp
            ? Container()
            : ChatDatestamp(
                timestamp: message?.created,
              ),
        Align(
          alignment: Alignment.centerLeft,
          child: MessageView(
            message: message,
            alignment: WrapAlignment.start,
            color: ConstantColors.INCOMING_BUBBLE,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(5.0),
            ),
          ),
        ),
        !showTimestamp
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ChatTimestamp(
                    timestamp: message?.created,
                  ),
                ),
              ),
      ],
    );
  }
}

class OutgoingMessageView extends StatelessWidget {
  const OutgoingMessageView({
    Key key,
    @required this.message,
    @required this.showDatestamp,
    @required this.showTimestamp,
  }) : super(key: key);

  final Message message;
  final bool showDatestamp;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        !showDatestamp
            ? Container()
            : ChatDatestamp(
                timestamp: message?.created,
              ),
        Align(
          alignment: Alignment.centerRight,
          child: MessageView(
            message: message,
            alignment: WrapAlignment.end,
            color: ConstantColors.OUTGOING_BUBBLE,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        ),
        !showTimestamp
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ChatTimestamp(
                    timestamp: message?.created,
                  ),
                ),
              ),
      ],
    );
  }
}

class MessageView extends StatefulWidget {
  const MessageView({
    Key key,
    @required this.message,
    @required this.alignment,
    @required this.color,
    @required this.borderRadius,
  }) : super(key: key);

  final Message message;
  final WrapAlignment alignment;
  final Color color;
  final BorderRadius borderRadius;

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  bool showImage = false;

  @override
  Widget build(BuildContext context) {
    var view;

    if (widget.message.imageDownloadUrl == null &&
        widget.message.imageFile == null) {
      view = Container(
        constraints: BoxConstraints(
          minWidth: 0.0,
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          elevation: 0.0,
          margin: EdgeInsets.only(
            bottom: 3.0,
            left: 20.0,
            right: 20.0,
          ),
          color: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 12.0,
            ),
            child: Text(
              widget.message.content,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'SF Pro Text',
                fontSize: 17.0,
                height: 1.39,
              ),
            ),
          ),
        ),
      );
    } else {
      view = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<String>(
              builder: (BuildContext context) {
                return FullScreenPhotoView(
                  widget.message.imageDownloadUrl,
                );
              },
              fullscreenDialog: true,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 21.0,
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: Container(
              constraints: BoxConstraints(
                minWidth: 0.0,
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              child: widget.message.imageDownloadUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.message.imageDownloadUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                    )
                  : Image.file(
                      widget.message.imageFile,
                    ),
            ),
          ),
        ),
      );
    }
    // else {
    //   Size size = MediaQuery.of(context).size;
    //   view = Center(
    //     child: CachedNetworkImage(
    //       width: size.width,
    //       height: size.height,
    //       imageUrl: widget.message.imageDownloadUrl,
    //       placeholder: (context, url) => CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Wrap(
      alignment: widget.alignment,
      children: <Widget>[
        view,
      ],
    );
  }
}
