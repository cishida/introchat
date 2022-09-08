import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/social/social_list.dart';
import 'package:introchat/ui/components/underline.dart';

class OnboardingSocial extends StatefulWidget {
  @override
  _OnboardingSocialState createState() => _OnboardingSocialState();
}

class _OnboardingSocialState extends State<OnboardingSocial> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        StandardCard(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25.0,
                  horizontal: 36.0,
                ),
                child: Text(
                  'You can make your intros even stronger by adding your social accounts. Choose the ones where you want your contacts and new connections to follow you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantColors.ONBOARDING_TEXT,
                    height: 1.5,
                    fontSize: 17.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  bottom: 5.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Social Accounts',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ConstantColors.ACCOUNT_HIGHLIGHT,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
              Underline(),
              SocialList(),
            ],
          ),
        ),
        // SizedBox(
        //   height: 10.0,
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 36.0),
        //   child: Text(
        //     'You can make your intros even stronger by adding your social accounts. Choose the ones where you have friends you might want to introduce or get introductions from.',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: ConstantColors.ONBOARDING_TEXT,
        //       height: 1.5,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 47.0,
        // ),
        // Text(
        //   'Social Accounts',
        //   textAlign: TextAlign.left,
        //   style: TextStyle(
        //     color: ConstantColors.ONBOARDING_TEXT,
        //   ),
        // ),
        // Divider(
        //   height: 1.0,
        //   color: Colors.white,
        // ),
        // SocialList(),
      ],
    );
  }
}
