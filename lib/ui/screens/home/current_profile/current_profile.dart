import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/profile_card.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/database.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/screens/home/current_profile/account/account.dart';
import 'package:introchat/ui/screens/home/current_profile/components/option_tile.dart';
import 'package:introchat/ui/screens/home/current_profile/confirmations/confirmations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentProfile extends StatefulWidget {
  @override
  _CurrentProfileState createState() => _CurrentProfileState();
}

class _CurrentProfileState extends State<CurrentProfile> {
  List<Widget> _buildOptionList() {
    final options = [
      // 'New Chat',
      'Account',
      'Confirmations',
      'Support',
      'Privacy',
    ];

    return options.map((option) {
      // var onTap = _launchSupportURL;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // TODO: Dryer way
          switch (option) {
            case 'New Chat':
              Navigator.pushNamed(context, ConstantRoutes.NewChatContacts);
              break;
            case 'Account':
              Navigator.of(context).push(
                MaterialPageRoute<String>(
                  builder: (BuildContext context) {
                    return Account();
                  },
                  fullscreenDialog: true,
                ),
              );
              // Navigator.pushNamed(context, ConstantRoutes.Account);
              break;
            case 'Confirmations':
              Navigator.of(context).push(
                MaterialPageRoute<String>(
                  builder: (BuildContext context) {
                    return Confirmations();
                  },
                  fullscreenDialog: true,
                ),
              );
              break;
            case 'Support':
              _launchSupportURL();
              break;
            case 'Privacy':
              _launchPrivacyURL();
              break;
            default:
              print('Not implemented');
          }
        },
        child: OptionTile(option: option),
      );
    }).toList();
  }

  _launchSupportURL() async {
    var url =
        Uri.encodeFull('mailto:support@introchat.com?subject=Please Help');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }

  _launchPrivacyURL() async {
    const url = 'https://www.introchat.com/home/privacy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    final userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      // appBar: AppBar(
      //   backgroundColor: ConstantColors.PRIMARY,
      // ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: DoneNavBar(),
            // ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StreamProvider<UserProfile>.value(
                  value: DatabaseService(uid: userProfile.uid).userProfile,
                  child: Column(
                    children: <Widget>[
                      ProfileCard(
                        userProfile: userProfile,
                      ),
                      // Underline(),
                      Column(
                        children: _buildOptionList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
