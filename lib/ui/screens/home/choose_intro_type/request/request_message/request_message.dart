import 'dart:io';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/intro_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/card/connector_row.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/contacts/contact_nav_bar.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_input.dart';
import 'package:provider/provider.dart';

class RequestMessageArgs {
  IntrochatContact introchatContact;
  Connection connectorConnection;

  RequestMessageArgs(this.introchatContact, this.connectorConnection);
}

class RequestMessage extends StatefulWidget {
  RequestMessage({
    Key key,
    @required this.requestMessageArgs,
  }) : super(key: key);

  final RequestMessageArgs requestMessageArgs;

  @override
  _RequestMessageState createState() => _RequestMessageState();
}

class _RequestMessageState extends State<RequestMessage> {
  @override
  Widget build(BuildContext context) {
    IntrochatContact introchatContact =
        widget.requestMessageArgs.introchatContact;
    Connection connectorConnection =
        widget.requestMessageArgs.connectorConnection;
    UserProfile userProfile = Provider.of<UserProfile>(context);
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      // appBar: AppBar(
      //     // title: Text('Choose who you want to ask'),
      //     ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ContactNavBar(title: ''),
            StandardCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ConnectorRow(
                    graphicUrl: 'assets/images/intro-to-bubble.png',
                    photoUrl: introchatContact.photoUrl,
                    displayName: introchatContact.displayName,
                  ),
                  Underline(),
                  ConnectorRow(
                    graphicUrl: 'assets/images/connector-bubble.png',
                    photoUrl: connectorConnection.userProfile?.photoUrl,
                    displayName: connectorConnection.userProfile?.displayName,
                  ),
                ],
              ),
            ),
            StandardCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Tell your connector why you want the Intro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantColors.SECONDARY_TEXT,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Text(""),
              ),
            ),
            // Container(
            //     color: Colors.white,
            //     padding: EdgeInsets.all(10.0),
            //     child: TextField(
            //         decoration: InputDecoration(
            //             hintText: 'Chat message',
            //         ),
            //     ),
            // ),

            // Underline(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10.0,
            //     horizontal: 0.0,
            //   ),
            //   child: Text(
            //     'Tell your connector why you want the Intro',
            //     style: TextStyle(
            //       color: ConstantColors.SECONDARY_TEXT,
            //       fontSize: 16.0,
            //     ),
            //   ),
            // ),
            // Underline(),
            ChatInput(
              onSubmitted: (String text, File image) async {
                IntroService introService = IntroService();
                await introService.requestIntro(
                  fromUser: userProfile,
                  connectorConnection: connectorConnection,
                  introchatContactUid: introchatContact.uid,
                  text: text,
                );
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(ConstantRoutes.Root),
                );

                String flushText = 'Request Sent';
                Flush.createFlush(flushText)..show(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
