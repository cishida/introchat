import 'package:flutter/material.dart';

class DoneNavBar extends StatefulWidget {
  const DoneNavBar({
    Key key,
  }) : super(key: key);

  @override
  _DoneNavBarState createState() => _DoneNavBarState();
}

class _DoneNavBarState extends State<DoneNavBar> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      padding: EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 28.0,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
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
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
