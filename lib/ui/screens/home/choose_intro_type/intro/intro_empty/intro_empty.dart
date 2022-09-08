import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:provider/provider.dart';

class IntroEmpty extends StatefulWidget {
  @override
  _IntroEmptyState createState() => _IntroEmptyState();
}

class _IntroEmptyState extends State<IntroEmpty> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: ConstantColors.PRIMARY,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: _buildWidgets(context),
                  ),
                ),
              ),
            ),
          );
  }

  List<Widget> _buildWidgets(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    var textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      height: 1.4,
    );

    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/images/logo-white.png',
              height: 42.0,
              width: 42.0,
            ),
            GestureDetector(
              onTap: () async {
                if (mounted) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                await userProfile.setMakeIntroOnboarding();
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
                // Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/done-button.png',
                height: 36.0,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 60.0),
      StandardCard(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text(
                'Make Intro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 15.0),
              RichText(
                text: TextSpan(
                  style: textStyle,
                  children: <TextSpan>[
                    TextSpan(text: '💫  You can use '),
                    TextSpan(
                      text: 'Make Intro ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'to introduce people and keep a record of all the intros you make.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              RichText(
                text: TextSpan(
                  style: textStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '⚡️  When both people you’re introducing have the app, '),
                    TextSpan(
                      text: 'Make Intro ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'is much faster than emailing and saves your inbox from follow-ups.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              RichText(
                text: TextSpan(
                  style: textStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '📓  Your contact list is tied to Google Contacts, so you can use '),
                    TextSpan(
                      text: 'Make Intro ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'with anyone you’ve already saved there.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    List<String> texts = [
      // '💫  You can use Make Intro to introduce  people and keep a record of all the intros you make.',
      // '⚡️  When both people you’re introducing have the app, Make Intro is much faster than emailing and saves your inbox from follow-ups.',
      // '📓  Your contact list is tied to Google Contacts, so you can use Make Intro with anyone you’ve already saved there.',
      // '📓  Your contact list is tied to Google Contacts, so you’ll be able to Intro anyone you’ve already saved there.',
      // '🔘  If someone you want to Intro isn’t in your contact list, you can use the ‘Add’ button to save their information.',
      // '📲  Saving a contact in Introchat or accepting an Intro automatically saves them in Google Contacts as well.',
    ];

    // widgets.add(
    //   PaddingBottom15(
    //     child: RichText(
    //       text: TextSpan(
    //         style: textStyle,
    //         children: <TextSpan>[
    //           TextSpan(text: '✨  '),
    //           TextSpan(
    //             text: 'Request Intro ',
    //             style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           TextSpan(
    //             text:
    //                 'helps you connect with people and organizations in your extended network.',
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    // for (var text in texts) {
    //   widgets.add(
    //     PaddingBottom15(
    //       child: Text(
    //         text,
    //         style: textStyle,
    //       ),
    //     ),
    //   );
    // }

    // widgets.add();

    // widgets.add(

    // );

    // widgets.add(

    // );

    // widgets.add(
    //   Container(
    //     height: 60.0,
    //     width: double.infinity,
    //     child: MaterialButton(
    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //       color: ConstantColors.HIGHLIGHT_BLUE,
    //       child: Text(
    //         "Get Started",
    //         style: TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       onPressed: () async {
    //         if (mounted) {
    //           setState(() {
    //             _isLoading = true;
    //           });
    //         }
    //         await userProfile.setMakeIntroOnboarding();
    //         if (mounted) {
    //           setState(() {
    //             _isLoading = false;
    //           });
    //         }
    //         // Navigator.pop(context);
    //       },
    //       shape: const StadiumBorder(),
    //     ),
    //   ),
    // );

    // widgets.add(SizedBox(
    //   height: 50.0,
    // ));

    // widgets.add(
    //   GestureDetector(
    //     onTap: () {
    //       Navigator.popUntil(
    //         context,
    //         ModalRoute.withName(ConstantRoutes.Root),
    //       );
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(
    //         vertical: 40.0,
    //         horizontal: 0.0,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Image.asset(
    //             'assets/images/checkmark-circle.png',
    //             height: 24.0,
    //             width: 24.0,
    //           ),
    //           SizedBox(
    //             width: 5.0,
    //           ),
    //           Text(
    //             "I'm done",
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 17.0,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return widgets;
  }
}

// class LogoBar extends StatelessWidget {
//   const LogoBar({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class PaddingBottom15 extends StatelessWidget {
  const PaddingBottom15({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: child,
    );
  }
}
