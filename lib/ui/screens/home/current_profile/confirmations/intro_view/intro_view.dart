import 'package:flutter/material.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/utils/constants/colors.dart';
// import 'package:introchat/ui/components/intro_card.dart';
import 'package:introchat/ui/components/intros/standard_intro_card.dart';
// import 'package:introchat/ui/screens/home/chats/conversation/components/intro_message_view.dart';

class IntroView extends StatefulWidget {
  const IntroView(this.intro);
  final Intro intro;

  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 28.0,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            StandardIntroCard(
              firstUser: widget.intro.toUserProfiles.first,
              secondUser: widget.intro.toUserProfiles.last,
              fromUser: widget.intro.fromUserProfile,
              text: widget.intro.text,
            ),
          ],
        ),
      ),
    );
  }
}
