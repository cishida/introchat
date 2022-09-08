import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/record-button.png',
      height: 80.0,
      width: 80.0,
    );
  }
}
