import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/empty_image.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/loading.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key key,
    @required this.userProfile,
    this.hideLinks = false,
  }) : super(key: key);

  final UserProfile userProfile;
  final bool hideLinks;

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int chatCount;

  @override
  void initState() {
    super.initState();

    ConnectionService connectionService = ConnectionService();
    connectionService.getUserChatCount(widget.userProfile.uid).then((count) {
      setState(() {
        chatCount = count;
      });
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> _buildSocialLinks(UserProfile userProfile) {
    List<Widget> links = [];

    // links.add(GestureDetector(
    //   onTap: () => _launchURL(Uri.encodeFull("mailto:${userProfile.email}")),
    //   child: Image.asset(
    //     'assets/images/email-icon.png',
    //     height: 32,
    //     width: 32,
    //   ),
    // ));

    links.add(
      GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: userProfile.email));
          Flush.createFlush('Email copied to clipboard')..show(context);
        },
        child: Image.asset(
          'assets/images/email-icon.png',
          height: 36,
          width: 36,
        ),
      ),
    );

    if (userProfile.socialAccounts != null) {
      for (var entry in userProfile.socialAccounts.entries) {
        links.add(GestureDetector(
          onTap: () => _launchURL("http://www.${entry.key}.com/${entry.value}"),
          child: Image.asset(
            'assets/images/${entry.key}.png',
            height: 36,
            width: 36,
          ),
        ));
      }
    }

    return links;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userProfile == null) {
      return Loading();
    } else {
      return Column(
        children: <Widget>[
          StandardCard(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: widget.userProfile?.photoUrl == null ||
                              widget.userProfile?.photoUrl == ''
                          ? EmptyImage(
                              size: 125.0,
                            )
                          : UserImage(
                              radius: 62.5,
                              url: widget.userProfile.photoUrl,
                              bordered: true,
                            )
                      // : CircleAvatar(
                      //     radius: 62.5,
                      //     backgroundImage: NetworkImage(
                      //       widget.userProfile.photoUrl,
                      //     ),
                      //     backgroundColor: Colors.white,
                      //   ),
                      ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.userProfile.displayName ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.userProfile.domain() ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            ChatCount(title: 'Chats', chatCount: chatCount),
                            SizedBox(
                              width: 20.0,
                            ),
                            Container(
                              width: 1.0,
                              height: 30.0,
                              color: Colors.white,
                            ),
                            // VerticalDivider(
                            //   color: Colors.white,
                            //   width: 2.0,
                            // ),
                            SizedBox(
                              width: 20.0,
                            ),
                            ChatCount(title: 'Active', chatCount: chatCount),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.hideLinks
              ? Container()
              : StandardCard(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildSocialLinks(widget.userProfile),
                    ),
                  ),
                ),
        ],
      );
    }
  }
}

class ChatCount extends StatelessWidget {
  const ChatCount({
    Key key,
    @required this.chatCount,
    @required this.title,
  }) : super(key: key);

  final int chatCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          chatCount?.toString() ?? '...',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ConstantColors.ACCOUNT_HIGHLIGHT,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
