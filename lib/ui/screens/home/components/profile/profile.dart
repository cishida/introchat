import 'package:flutter/material.dart';
import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/utils/constants/routes.dart';
import 'package:introchat/ui/components/profile_card.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/screens/home/chats/conversation/conversation_view.dart';
import 'package:introchat/ui/screens/home/current_profile/components/option_tile.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key key,
    @required this.userProfile,
    this.connection,
  }) : super(key: key);

  final UserProfile userProfile;
  final Connection connection;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _disabled = false;

  List<Widget> _buildOptionList() {
    final options = [
      'Intro',
      // 'Confirmations',
      'Block',
    ];

    if (widget.connection != null) {
      options.insert(1, 'Chat');
    }

    return options.map((option) {
      // var onTap = _launchSupportURL;
      // TODO: GestureDetector not registering outside of text/image
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          switch (option) {
            case 'Intro':
              Navigator.pushNamed(context, ConstantRoutes.ChooseContacts);
              break;
            case 'Chat':
              Navigator.of(context).push(
                MaterialPageRoute<String>(
                  builder: (BuildContext context) {
                    return ConversationView(
                      connection: widget.connection,
                    );
                  },
                  fullscreenDialog: true,
                ),
              );
              break;
            case 'Block':
              Navigator.pushNamed(
                context,
                ConstantRoutes.BlockConfirmation,
                arguments: widget.userProfile,
              );
              break;
            default:
              print('Not implemented');
          }
        },
        child: OptionTile(
          option: option,
          leftPadding: true,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      // appBar: AppBar(
      //     // backgroundColor: ConstantColors.PRIMARY,
      //     ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
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
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: ConstantMeasurements.NAV_BAR_HEIGHT),
            // NavBar(),
            ProfileCard(
              userProfile: widget.userProfile,
            ),
            // Underline(),
            Column(
              children: _buildOptionList(),
            ),
          ],
        ),
      ),
    );
  }
}
