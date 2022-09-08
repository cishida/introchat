import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/intro/intro.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/intro_service.dart';
import 'package:introchat/core/services/firestore/introchat_contact_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/intros/standard_intro_card.dart';
import 'package:introchat/ui/screens/home/feed/components/get_introduced.dart';
import 'package:introchat/ui/screens/home/components/profile/profile.dart';
import 'package:provider/provider.dart';

class FeedTile extends StatefulWidget {
  FeedTile({
    Key key,
    this.intro,
  }) : super(key: key);

  final Intro intro;

  @override
  _FeedTileState createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  UserProfile fromUser;
  UserProfile firstUser;
  UserProfile secondUser;
  IntroService introService = IntroService();
  IntrochatContactService introchatContactService = IntrochatContactService();

  _setUsers(List<UserProfile> userProfiles) async {
    var tempFromUser = userProfiles
        .where((userProfile) => userProfile.uid == widget.intro.fromUid)
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
        .where((userProfile) => userProfile.uid == widget.intro.toUids[0])
        .first;
    var tempSecondUser = userProfiles
        .where((userProfile) => userProfile.uid == widget.intro.toUids[1])
        .first;

    if (mounted) {
      setState(() {
        fromUser = tempFromUser;
        firstUser = tempFirstUser;
        secondUser = tempSecondUser;
      });
    }
  }

  _goToFeedUserIndex(int index) {
    final targetUser =
        index == 0 ? firstUser : (index == 1 ? secondUser : fromUser);
    final currentUser = Provider.of<UserProfile>(context, listen: false);
    final connections = Provider.of<List<Connection>>(context, listen: false);
    final acceptedConnections = connections
        .where((connection) => connection.status == ConnectionStatus.accepted);
    final connectionUids =
        acceptedConnections.map((connection) => connection.uid);

    if (targetUser.uid == currentUser.uid) {
      // Navigator.of(context).push(
      //   MaterialPageRoute<String>(
      //     builder: (BuildContext context) {
      //       return CurrentProfile();
      //     },
      //     fullscreenDialog: true,
      //   ),
      // );
    } else if (connectionUids.contains(targetUser.uid)) {
      Navigator.of(context).push(
        MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return Profile(
              userProfile: targetUser,
              connection: connections
                  .firstWhere((connection) => connection.uid == targetUser.uid),
            );
          },
          fullscreenDialog: true,
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return GetIntroduced(
              userProfile: targetUser,
            );
          },
          fullscreenDialog: true,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    introService.getIntroUserProfiles(widget.intro).then((userProfiles) {
      _setUsers(userProfiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    final connections = Provider.of<List<Connection>>(context);
    var connectedNames = [];

    if (connections != null &&
        firstUser != null &&
        secondUser != null &&
        fromUser != null) {
      connections.forEach((connection) {
        if (connection.uid == firstUser.uid) {
          connectedNames.add(firstUser.displayName);
        }
        if (connection.uid == secondUser.uid) {
          connectedNames.add(secondUser.displayName);
        }
        if (connection.uid == fromUser.uid) {
          connectedNames.add(fromUser.displayName);
        }
      });
    }

    return Column(
      children: <Widget>[
        StandardIntroCard(
          firstUser: firstUser,
          secondUser: secondUser,
          fromUser: fromUser,
          feed: true,
          timestamp: widget.intro.created,
          goToFeedUserIndex: _goToFeedUserIndex,
        ),
        StandardCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Connected to ${connectedNames.length == 0 ? 'loading...' : connectedNames.join(' and ')}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ConstantColors.CHAT_TIMESTAMP,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
