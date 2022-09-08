import 'package:flutter/material.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/profile_card.dart';
import 'package:provider/provider.dart';

class RequestConnection extends StatefulWidget {
  const RequestConnection({
    Key key,
    @required this.userProfile,
    @required this.introchatContact,
  }) : super(key: key);

  final UserProfile userProfile;
  final IntrochatContact introchatContact;

  @override
  _RequestConnectionState createState() => _RequestConnectionState();
}

class _RequestConnectionState extends State<RequestConnection> {
  ConnectionService _connectionService = ConnectionService();
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (!_disabled) {
                          setState(() {
                            _disabled = true;
                          });
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
            ),
            ProfileCard(
              userProfile: widget.userProfile,
            ),
            // Underline(),
            Column(
              children: [
                StandardCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 30.0,
                    ),
                    child: ButtonPrimary(
                      text: 'Connect',
                      color: ConstantColors.HIGHLIGHT_BLUE,
                      onPressed: () async {
                        await _connectionService.requestConnection(
                          userProfile.uid,
                          widget.introchatContact,
                        );

                        String flushText = 'Request Sent';
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName(ConstantRoutes.Root),
                        );
                        Flush.createFlush(flushText)..show(context);
                      },
                    ),
                  ),
                ),
                StandardCard(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 23.0,
                      horizontal: 0.0,
                    ),
                    child: Text(
                      'Connecting lets you chat privately\nand make intros for each other.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ConstantColors.CHAT_TIMESTAMP,
                        fontSize: 17.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
