import 'package:flutter/material.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/ui/components/card/connector_row.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:provider/provider.dart';

class DirectConnectionMessageView extends StatefulWidget {
  const DirectConnectionMessageView({
    Key key,
    @required this.message,
    @required this.showDatestamp,
    @required this.showTimestamp,
  }) : super(key: key);

  final Message message;
  final bool showDatestamp;
  final bool showTimestamp;

  @override
  _DirectConnectionMessageViewState createState() =>
      _DirectConnectionMessageViewState();
}

class _DirectConnectionMessageViewState
    extends State<DirectConnectionMessageView> {
  UserProfile fromUser;

  _getDirectConnectionUser() {
    ConnectionService connectionService = ConnectionService();

    connectionService
        .getConnectionUserProfile(widget.message.senderUid)
        .then((profile) {
      if (mounted) {
        setState(() {
          fromUser = profile;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDirectConnectionUser();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return StandardCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 0.0,
        ),
        child: Column(
          children: <Widget>[
            ConnectorRow(
              graphicUrl: 'assets/images/request-by.png',
              photoUrl: fromUser?.photoUrl ?? '',
              displayName: fromUser?.displayName ?? '',
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 30.0,
            //     right: 30.0,
            //     bottom: 15.0,
            //   ),
            //   child: Text(
            //     widget.message?.content ?? '',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 18.0,
            //       fontWeight: FontWeight.normal,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
