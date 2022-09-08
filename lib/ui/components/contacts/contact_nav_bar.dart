import 'package:flutter/material.dart';
import 'package:introchat/ui/components/back_arrow.dart';
import 'package:introchat/ui/components/underline.dart';

class ContactNavBar extends StatelessWidget {
  const ContactNavBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 28.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BackArrow(),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        // Underline(),
      ],
    );
  }
}
