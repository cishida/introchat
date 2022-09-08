import 'package:flutter/material.dart';
import 'package:introchat/core/models/custom_contact.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/intros/standard_intro_card.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:provider/provider.dart';

class IntroCard extends StatefulWidget {
  const IntroCard({
    Key key,
    @required this.contacts,
  }) : super(key: key);

  final List<IntrochatContact> contacts;

  @override
  _IntroCardState createState() => _IntroCardState();
}

class _IntroCardState extends State<IntroCard> {
  @override
  void initState() {
    super.initState();

    UserService userService = UserService();
    for (var contact in widget.contacts) {
      if (contact.userId != null) {
        userService.getUserProfile(contact.userId).then((userProfile) {
          setState(() {
            contact.userProfile = userProfile;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Container(
      child: StandardCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 0.0,
          ),
          child: Column(
            children: <Widget>[
              IntroCardConnecting(
                firstPhotoUrl: widget.contacts[0].userProfile == null
                    ? ''
                    : widget.contacts[0].userProfile.photoUrl,
                firstDisplayName: widget.contacts[0].userProfile == null
                    ? widget.contacts[0].getCorrectDisplayName(userProfile.uid)
                    : widget.contacts[0].userProfile.displayName,
                secondPhotoUrl: widget.contacts[1].userProfile == null
                    ? ''
                    : widget.contacts[1].userProfile.photoUrl,
                secondDisplayName: widget.contacts[1].userProfile == null
                    ? widget.contacts[1].getCorrectDisplayName(userProfile.uid)
                    : widget.contacts[1].userProfile.displayName,
              ),
              SizedBox(height: 15.0),
              Underline(),
              SizedBox(height: 15.0),
              IntroCardBy(
                photoUrl: userProfile?.photoUrl ?? '',
                displayName: userProfile?.displayName ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectingGraphic extends StatelessWidget {
  const ConnectingGraphic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 45.0, bottom: 4.0),
          child: Image.asset(
            'assets/images/connector-bottom.png',
            height: 33,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/connecting-bubble.png',
            height: 35,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0),
          child: Image.asset(
            'assets/images/connector-top.png',
            height: 33,
          ),
        ),
      ],
    );
  }
}
