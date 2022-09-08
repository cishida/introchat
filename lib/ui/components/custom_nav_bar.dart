import 'package:flutter/material.dart';
import 'package:introchat/ui/components/back_arrow.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 28.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BackArrow(),
        ],
      ),
    );
  }
}
