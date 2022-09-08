import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';
import 'package:introchat/core/utils/formatters/email_formatter.dart';
import 'package:introchat/ui/components/buttons/button_primary.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/empty_image.dart';
import 'package:introchat/ui/components/flush/flush.dart';
import 'package:introchat/ui/components/profile_card.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailInvite extends StatefulWidget {
  const EmailInvite({
    Key key,
    @required this.contact,
  }) : super(key: key);

  final IntrochatContact contact;

  @override
  _EmailInviteState createState() => _EmailInviteState();
}

class _EmailInviteState extends State<EmailInvite> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendEmailInvite() async {
    await _launchURL(Uri.encodeFull(
        "mailto:${widget.contact.email}?subject=A warm introduction to Introchat&body=Hey check out this app Introchat, it’ll let us share contacts and ask for intros from each other when we need it: https://introchat.com/"));
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 5.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Image.asset(
                      'assets/images/done-button.png',
                      height: 36.0,
                    ),
                  ),
                ),
              ],
            ),
            StandardCard(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: EmptyImage(
                        size: 125.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.contact
                                      .getCorrectDisplayName(userProfile.uid) ??
                                  '',
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
                              EmailFormatter.getDomain(
                                  widget.contact.email ?? ''),
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
                              ChatCount(title: 'Chats', chatCount: 0),
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
                              ChatCount(title: 'Active', chatCount: 0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StandardCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.contact.email));
                    Flush.createFlush('Email copied to clipboard')
                      ..show(context);
                  },
                  child: Image.asset(
                    'assets/images/email-icon.png',
                    height: 36,
                    width: 36,
                  ),
                ),
              ),
            ),
            StandardCard(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 23.0,
                      horizontal: 30.0,
                    ),
                    child: Text(
                      'This contact doesn’t have Introchat yet, send them an invite to connect with them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ConstantColors.SECONDARY_TEXT,
                        fontSize: 17.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      left: 30.0,
                      right: 30.0,
                    ),
                    child: ButtonPrimary(
                      text: 'Email Invite',
                      onPressed: _sendEmailInvite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
