import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/screens/home/components/intro_bar.dart';
import 'package:introchat/ui/screens/home/feed/components/feed_list.dart';

class Feed extends StatefulWidget {
  Feed({
    this.changeTab,
    Key key,
  }) : super(key: key);

  final Function(int) changeTab;

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.PRIMARY,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IntroBar(
              icon: true,
              changeTab: widget.changeTab,
            ),
            Expanded(
              child: FeedList(),
            ),
          ],
        ),
      ),
    );
  }
}
