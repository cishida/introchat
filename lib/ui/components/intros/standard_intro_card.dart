import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/formatters/timestampFormatter.dart';
import 'package:introchat/ui/components/card/standard_card.dart';
import 'package:introchat/ui/components/images/user_image.dart';
import 'package:introchat/ui/components/intro_card.dart';
import 'package:introchat/ui/components/underline.dart';

class StandardIntroCard extends StatelessWidget {
  const StandardIntroCard({
    Key key,
    @required this.firstUser,
    @required this.secondUser,
    @required this.fromUser,
    this.text = '',
    this.feed = false,
    this.timestamp,
    this.goToFeedUserIndex,
  }) : super(key: key);

  final UserProfile firstUser;
  final UserProfile secondUser;
  final UserProfile fromUser;
  final String text;
  final bool feed;
  final Timestamp timestamp;
  final Function(int) goToFeedUserIndex;

  @override
  Widget build(BuildContext context) {
    var timestampFormatter = TimestampFormatter();

    return StandardCard(
      child: Stack(
        children: <Widget>[
          timestamp != null
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      left: 14.0,
                    ),
                    child: Text(
                      timestampFormatter.getChatTileTime(timestamp) == 'now'
                          ? timestampFormatter.getChatTileTime(timestamp)
                          : timestampFormatter.getChatTileTime(timestamp) +
                              ' ago',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ConstantColors.CHAT_TIMESTAMP,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 0.0,
            ),
            child: Column(
              children: <Widget>[
                IntroCardConnecting(
                  firstPhotoUrl: firstUser?.photoUrl ?? '',
                  firstDisplayName: firstUser?.displayName ?? 'Loading...',
                  secondPhotoUrl: secondUser?.photoUrl ?? '',
                  secondDisplayName: secondUser?.displayName ?? 'Loading...',
                  feed: feed,
                  goToFeedUserIndex: goToFeedUserIndex,
                ),
                SizedBox(height: 15.0),
                Underline(),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    goToFeedUserIndex(2);
                  },
                  child: IntroCardBy(
                    photoUrl: fromUser?.photoUrl ?? '',
                    displayName: fromUser?.displayName ?? 'Loading...',
                  ),
                ),
                feed ? Container() : IntroMessageText(text: text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IntroCardBy extends StatelessWidget {
  const IntroCardBy({
    Key key,
    @required this.photoUrl,
    @required this.displayName,
  }) : super(key: key);

  final String photoUrl;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 16.0, right: 18.0),
            child: Image.asset(
              'assets/images/intro-by.png',
              height: 35,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageNameRow(
                photoUrl: photoUrl,
                displayName: displayName,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IntroCardConnecting extends StatelessWidget {
  const IntroCardConnecting({
    Key key,
    @required this.firstPhotoUrl,
    @required this.firstDisplayName,
    @required this.secondPhotoUrl,
    @required this.secondDisplayName,
    this.feed = false,
    this.goToFeedUserIndex,
  }) : super(key: key);

  final String firstPhotoUrl;
  final String firstDisplayName;
  final String secondPhotoUrl;
  final String secondDisplayName;
  final bool feed;
  final Function(int) goToFeedUserIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: ConnectingGraphic(),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  goToFeedUserIndex(0);
                },
                child: ImageNameRow(
                  photoUrl: firstPhotoUrl,
                  displayName: firstDisplayName,
                ),
              ),
              // SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  49.0,
                  20.0,
                  0.0,
                  20.0,
                ),
                child: Underline(),
              ),
              // SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  goToFeedUserIndex(1);
                },
                child: ImageNameRow(
                  photoUrl: secondPhotoUrl,
                  displayName: secondDisplayName,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IntroMessageText extends StatelessWidget {
  const IntroMessageText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Center(
        child: Text(
          '"' + text + '"',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }
}

class ImageNameRow extends StatelessWidget {
  const ImageNameRow({
    Key key,
    @required this.photoUrl,
    @required this.displayName,
  }) : super(key: key);

  final String photoUrl;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        UserImage(
          radius: 20.0,
          url: photoUrl,
          bordered: false,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              displayName ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
