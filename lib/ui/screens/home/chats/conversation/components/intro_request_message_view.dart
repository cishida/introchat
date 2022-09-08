import 'package:flutter/material.dart';
import 'package:introchat/core/models/introRequest/intro_request.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/intro_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/connector_row.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:provider/provider.dart';
import 'package:introchat/ui/components/underline.dart';

class IntroRequestMessageView extends StatefulWidget {
  const IntroRequestMessageView({
    Key key,
    @required this.message,
    @required this.showDatestamp,
    @required this.showTimestamp,
  }) : super(key: key);

  final Message message;
  final bool showDatestamp;
  final bool showTimestamp;

  @override
  _IntroRequestMessageViewState createState() =>
      _IntroRequestMessageViewState();
}

class _IntroRequestMessageViewState extends State<IntroRequestMessageView> {
  IntroRequest introRequest;
  UserProfile fromUser;
  UserProfile connectorUser;
  IntrochatContact introchatContact;
  IntroService introService = IntroService();
  IntrochatContactService introchatContactService = IntrochatContactService();

  @override
  void initState() {
    super.initState();
    introService
        .getIntroRequest(widget.message.introRequestUid)
        .then((request) {
      // setState(() {
      introRequest = request;
      // });

      introService
          .getIntroRequestUserProfiles(introRequest)
          .then((userProfiles) {
        introchatContactService
            .getIntrochatContact(introRequest.introchatContactUid)
            .then((contact) {
          setState(() {
            fromUser = userProfiles
                .where((userProfile) => userProfile.uid == introRequest.fromUid)
                .first;
            connectorUser = userProfiles
                .where((userProfile) =>
                    userProfile.uid == introRequest.connectorUid)
                .first;
            introchatContact = contact;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Column(
      children: <Widget>[
        StandardCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 0.0,
            ),
            child: Column(
              children: <Widget>[
                ConnectorRow(
                  graphicUrl: 'assets/images/request-from-bubble.png',
                  photoUrl: fromUser?.photoUrl ?? '',
                  displayName: fromUser?.displayName ?? '',
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 15.0,
                  ),
                  child: Text(
                    '"${introRequest?.text}"' ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Underline(),
                ConnectorRow(
                  graphicUrl: 'assets/images/intro-to-bubble.png',
                  photoUrl: introchatContact?.photoUrl ?? '',
                  displayName: introchatContact
                          ?.getCorrectDisplayName(connectorUser.uid) ??
                      'Loading...',
                ),
              ],
            ),
          ),
        ),
        connectorUser?.uid == null || connectorUser?.uid != userProfile.uid
            ? Container()
            : StandardCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 35.0,
                  ),
                  child: ButtonPrimary(
                    text: 'Make Intro',
                    color: ConstantColors.HIGHLIGHT_BLUE,
                    onPressed: () async {
                      if (introRequest != null) {
                        var requesterContact = await introchatContactService
                            .getIntrochatContactFromUser(fromUser.uid);
                        Navigator.pushNamed(
                          context,
                          ConstantRoutes.ContactConfirmation,
                          arguments: [introchatContact, requesterContact],
                        );
                      }
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
