import 'package:flutter/material.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/choose_intro_type/choose_intro_type.dart';

class IntroBar extends StatelessWidget {
  const IntroBar({
    this.icon = false,
    this.changeTab,
    Key key,
  }) : super(key: key);

  final bool icon;
  final Function(int) changeTab;

  @override
  Widget build(BuildContext context) {
    // final userProfile = Provider.of<UserProfile>(context);

    return Container(
      height: 55.0,
      child: Column(
        children: <Widget>[
          icon
              ? SizedBox(
                  height: 0.0,
                )
              : Container(),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                icon
                    ? Image.asset(
                        'assets/images/logo-white.png',
                        height: 43,
                        width: 43,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          'Chats',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (BuildContext context) {
                          return ChooseIntroType(
                            changeTab: changeTab,
                          );
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/intro-icon-no-drop.png',
                    height: 32.0,
                    width: 32.0,
                  ),
                ),
              ],
            ),
          ),
          // icon
          //     ? SizedBox(
          //         height: 9.0,
          //       )
          //     : Container(),
          // icon ? Underline() : Container(),
          Spacer(),
          Underline(),
        ],
      ),
    );
  }
}
