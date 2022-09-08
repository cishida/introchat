import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:introchat/ui/screens/home/components/connection_list.dart';
import 'package:introchat/ui/screens/home/components/intro_bar.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Chats extends StatefulWidget {
  Chats({
    this.changeTab,
    Key key,
  }) : super(key: key);

  final Function(int) changeTab;

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return VisibilityDetector(
      key: Key('chats'),
      onVisibilityChanged: (visibility) async {
        if ((userProfile.homeOnboarding == null ||
                !userProfile.homeOnboarding) &&
            visibility.visibleFraction == 0) {
          await userProfile.setHomeOnboarding();
        }
      },
      child: Scaffold(
        backgroundColor: ConstantColors.PRIMARY,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              IntroBar(
                changeTab: widget.changeTab,
              ),
              // Underline(),
              Expanded(
                child: ConnectionList(),
              ),
            ],
          ),
        ),
        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute<String>(
        //         builder: (BuildContext context) {
        //           return ChooseIntroType();
        //         },
        //         fullscreenDialog: true,
        //       ),
        //     );
        //   },
        //   child: Container(
        //     height: 60.0,
        //     width: 60.0,
        //     child: FittedBox(
        //       child: Image.asset(
        //         'assets/images/intro-icon.png',
        //         height: 60.0,
        //         width: 60.0,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
