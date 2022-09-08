import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:provider/provider.dart';

class RequestEmpty extends StatefulWidget {
  @override
  _RequestEmptyState createState() => _RequestEmptyState();
}

class _RequestEmptyState extends State<RequestEmpty> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                await userProfile.setRequestIntroOnboarding();
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: Image.asset(
                'assets/images/done-button.png',
                height: 36.0,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40.0),
      StandardCard(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text(
                'Request Intro',
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
                    TextSpan(text: '✨  You can use '),
                    TextSpan(
                      text: 'Request Intro ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'to get introductions to people and organizations in your extended network.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              RichText(
                text: TextSpan(
                  style: textStyle,
                  children: <TextSpan>[
                    TextSpan(text: '🗂  Once you successfully make an '),
                    TextSpan(
                      text: 'Intro ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'or ',
                    ),
                    TextSpan(
                      text: 'Chat ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', you’ll see a list of people here organized by email domain.',
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
                            '↔️ Everyone you’ll see in this list is connected to someone in your Introchat network.'),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              RichText(
                text: TextSpan(
                  style: textStyle,
                  children: <TextSpan>[
                    TextSpan(text: '📬  To get started with '),
                    TextSpan(
                      text: 'Request Intro ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', try connecting with teammates in-app. Then as you add more people, your list will grow.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              ButtonPrimary(
                text: 'Add Teammate',
                onPressed: () {
                  Navigator.pushNamed(context, ConstantRoutes.NewChatContacts);
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.pushNamed(
              //           context, ConstantRoutes.NewChatContacts);
              //     },
              //     child: Image.asset(
              //       'assets/images/add-teammate-button.png',
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    ];
    // var textStyle = TextStyle(
    //   color: Colors.white,
    //   fontSize: 18.0,
    //   fontWeight: FontWeight.w400,
    // );
    // List<String> texts = [
    //   '🗂  Once you make an Intro or open a chat in-app, you’ll see a list of people here organized by email domain.',
    //   '↔️  Everyone you’ll see in your list is just a quick Intro away through someone you’re connected to.',
    //   '📝  When you want to get in touch, just select a name and send a quick text about why you want to connect.',
    //   '⚡  Your mutual connection will be able to tap a button and connect you in seconds if they see a fit.',
    // ];

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

    // widgets.add(
    //   Padding(
    //     padding: const EdgeInsets.only(
    //       bottom: 30.0,
    //     ),
    //     child: RichText(
    //       text: TextSpan(
    //         style: textStyle,
    //         children: <TextSpan>[
    //           TextSpan(text: '📬  To get started with '),
    //           TextSpan(
    //             text: 'Request Intro ',
    //             style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           TextSpan(
    //             text:
    //                 ' try connecting with teammates in-app. Then as you make Intros and open chats, your list will grow.',
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    // widgets.add(
    //   Container(
    //     height: 60.0,
    //     width: double.infinity,
    //     child: MaterialButton(
    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //       color: ConstantColors.HIGHLIGHT_BLUE,
    //       child: Text(
    //         "Add Teammate",
    //         style: TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       onPressed: () {
    //         Navigator.pushNamed(context, ConstantRoutes.NewChatContacts);
    //       },
    //       shape: const StadiumBorder(),
    //     ),
    //   ),
    // );

    // final userProfile = Provider.of<UserProfile>(context);

    // widgets.add(
    //   GestureDetector(
    //     onTap: () async {
    //       if (mounted) {
    //         setState(() {
    //           _isLoading = true;
    //         });
    //       }
    //       await userProfile.setRequestIntroOnboarding();
    //       if (mounted) {
    //         setState(() {
    //           _isLoading = false;
    //         });
    //       }
    //       // Navigator.popUntil(
    //       //   context,
    //       //   ModalRoute.withName(ConstantRoutes.Root),
    //       // );
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

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/logo-white.png',
          height: 60,
          width: 60,
        ),
        Text(
          'Introchat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

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
