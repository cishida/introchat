import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:provider/provider.dart';

class ChooseIntroType extends StatefulWidget {
  const ChooseIntroType({
    this.changeTab,
    Key key,
  }) : super(key: key);

  final Function(int) changeTab;

  @override
  _ChooseIntroTypeState createState() => _ChooseIntroTypeState();
}

class _ChooseIntroTypeState extends State<ChooseIntroType> {
  @override
  Widget build(BuildContext context) {
    final connections = Provider.of<List<Connection>>(context);

    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 13.0,
                  right: 28.0,
                  bottom: 17.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Spacer(),
            IntroTypeCard(
              icon: 'assets/images/make-intro-icon.png',
              title: 'Make Intro',
              subheader: 'Connect two people you know in a private chat.',
              route: ConstantRoutes.ChooseContacts,
            ),
            IntroTypeCard(
              icon: 'assets/images/request-intro-icon.png',
              title: 'Request Intro',
              subheader:
                  'See who your connections know and ask for introductions.',
              route: ConstantRoutes.RequestContacts,
              arguments: {
                'connections': connections,
                'changeTab': widget.changeTab,
              },
            ),
            // IntroTypeCard(
            //   icon: 'assets/images/connect-directly-icon.png',
            //   title: 'Connect Directly',
            //   subheader:
            //       'Start a new chat and trade contacts without an intro.',
            //   route: ConstantRoutes.NewChatContacts,
            // ),
            // Spacer(),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}

class IntroTypeCard extends StatelessWidget {
  const IntroTypeCard({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subheader,
    @required this.route,
    this.arguments,
  }) : super(key: key);

  final String icon;
  final String title;
  final String subheader;
  final String route;
  final arguments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: arguments);
        },
        child: StandardCard(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  icon,
                  height: 32.0,
                  width: 32.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 21.0,
                      right: 21.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          subheader,
                          style: TextStyle(
                            color: ConstantColors.SECONDARY_TEXT,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/chevron-right.png',
                  height: 16.0,
                  // width: 32.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
