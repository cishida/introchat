import 'package:flutter/material.dart';
import 'package:introchat/core/services/firestore/user_service.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/ui/screens/home/components/connection_tile.dart';
import 'package:provider/provider.dart';

class ConnectionList extends StatefulWidget {
  @override
  _ConnectionListState createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final connections = Provider.of<List<Connection>>(context);
    final userProfile = Provider.of<UserProfile>(context);

    if (connections == null && userProfile != null) {
      return Loading();
    } else {
      connections
          .sort((a, b) => b.mostRecentActivity.compareTo(a.mostRecentActivity));
      List<Connection> unblockedConnections = connections
          .where((connection) => connection.status != ConnectionStatus.blocked)
          .toList();
      _userService.syncUnseenNotificationCount(
        unblockedConnections,
        userProfile.uid,
      );

      bool showNavigationTips =
          userProfile.homeOnboarding == null || !userProfile.homeOnboarding;

      return ListView.builder(
        itemCount: unblockedConnections.length,
        itemBuilder: (context, index) {
          // if (index == unblockedConnections.length) {
          //   return NavigationTipsCard();
          // } else {
          return ConnectionTile(
            connection: unblockedConnections[index],
            currentUserUid: userProfile.uid,
          );
          // }
        },
      );
    }
  }
}

class NavigationTipsCard extends StatelessWidget {
  const NavigationTipsCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60.0,
        bottom: 80.0,
      ),
      child: StandardCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Navigation Tips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              NavigationTipRow(
                  image: 'assets/images/down-diagonal-arrow.png',
                  text:
                      'The Intro button in the top right corner lets you introduce people and ask for intros when you need them.'),
              NavigationTipRow(
                  image: 'assets/images/up-diagonal-arrow.png',
                  text:
                      'The menu below takes you to Home, Chats, Search, or Profile and signals when you have unread notifications.'),
              NavigationTipRow(
                  image: 'assets/images/message-bubble-icon.png',
                  text:
                      'Tap the chat with Team Introchat to learn how intros and chats work.'),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationTipRow extends StatelessWidget {
  const NavigationTipRow({
    Key key,
    @required this.image,
    @required this.text,
  }) : super(key: key);

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.asset(
              image,
              height: 25.0,
              width: 25.0,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
