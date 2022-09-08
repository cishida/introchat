import 'package:flutter/material.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/message/message.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/intro_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/ui/components/intros/standard_intro_card.dart';

class IntroMessageView extends StatefulWidget {
  const IntroMessageView({
    Key key,
    @required this.message,
    @required this.showDatestamp,
    @required this.showTimestamp,
  }) : super(key: key);

  final Message message;
  final bool showDatestamp;
  final bool showTimestamp;

  @override
  _IntroMessageViewState createState() => _IntroMessageViewState();
}

class _IntroMessageViewState extends State<IntroMessageView> {
  Intro intro;
  UserProfile fromUser;
  UserProfile firstUser;
  UserProfile secondUser;
  IntroService introService = IntroService();
  IntrochatContactService introchatContactService = IntrochatContactService();

  _setUsers(List<UserProfile> userProfiles) async {
    var tempFromUser = userProfiles
        .where((userProfile) => userProfile.uid == intro.fromUid)
        .first;

    for (var userProfile in userProfiles) {
      if (userProfile.preuser) {
        var contact = await introchatContactService
            .getIntrochatContactFromEmail(userProfile.email);
        userProfile.displayName =
            contact.getCorrectDisplayName(tempFromUser.uid);
      }
    }

    var tempFirstUser = userProfiles
        .where((userProfile) => userProfile.uid == intro.toUids[0])
        .first;
    var tempSecondUser = userProfiles
        .where((userProfile) => userProfile.uid == intro.toUids[1])
        .first;

    if (mounted) {
      setState(() {
        fromUser = tempFromUser;
        firstUser = tempFirstUser;
        secondUser = tempSecondUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    introService.getIntro(widget.message.introUid).then((result) {
      if (mounted) {
        setState(() {
          intro = result;
        });
      }

      if (intro != null) {
        introService.getIntroUserProfiles(intro).then((userProfiles) {
          // List<Future> futures;
          // for (var userProfile in userProfiles) {
          //   IntrochatContactService introchatContactService =
          //       IntrochatContactService();
          //   introchatContactService
          //       .getIntrochatContactFromEmail(userProfile.email)
          //       .then((introchatContact) {
          //     userProfile.displayName = introchatContact.getCorrectDisplayName(
          //         userProfiles
          //             .where((userProfile) => userProfile.uid == intro.fromUid)
          //             .first
          //             .uid);
          //   });
          // }

          _setUsers(userProfiles);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StandardIntroCard(
      firstUser: firstUser,
      secondUser: secondUser,
      fromUser: fromUser,
      text: widget.message.content,
    );

    // Row(
    //   children: <Widget>[
    //     Text(fromUser?.displayName ?? ''),
    //     Text(firstUser?.displayName ?? ''),
    //     Text(secondUser?.displayName ?? ''),
    //   ],
    // );
  }
}
