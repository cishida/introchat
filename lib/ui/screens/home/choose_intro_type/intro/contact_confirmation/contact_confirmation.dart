import 'dart:io';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/intro_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/custom_nav_bar.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/intro_card.dart';
import 'package:introchat/ui/screens/home/chats/conversation/components/chat_input.dart';
import 'package:provider/provider.dart';

class ContactConfirmation extends StatelessWidget {
  final List<IntrochatContact> contacts;

  ContactConfirmation({this.contacts});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomNavBar(),
            IntroCard(
              contacts: contacts,
            ),
            StandardCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Tell them why you want them to connect',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantColors.SECONDARY_TEXT,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Spacer(),
            // Underline(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10.0,
            //     horizontal: 0.0,
            //   ),
            //   child: Text(
            //     'Tell them why you want them to connect',
            //     style: TextStyle(
            //       color: ConstantColors.SECONDARY_TEXT,
            //       fontSize: 16.0,
            //     ),
            //   ),
            // ),
            // Underline(),
            ChatInput(onSubmitted: (String text, File image) async {
              IntroService introService = IntroService();
              await introService.createIntro(
                fromUid: user.uid,
                text: text,
                contacts: contacts,
              );

              Navigator.popUntil(
                context,
                ModalRoute.withName(ConstantRoutes.Root),
              );

              if (contacts.first.userId == null) {
                Navigator.pushNamed(
                  context,
                  ConstantRoutes.EmailInvite,
                  arguments: contacts.first,
                );
              }

              if (contacts.last.userId == null) {
                Navigator.pushNamed(
                  context,
                  ConstantRoutes.EmailInvite,
                  arguments: contacts.last,
                );
              }
              String flushText = 'Intro Sent';
              Flush.createFlush(flushText)..show(context);
            }),
          ],
        ),
      ),
    );
  }
}
