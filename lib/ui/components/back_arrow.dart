import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40.0,
        // width: 40.0,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            right: 8.0,
          ),
          child: Image.asset(
            'assets/images/back-arrow.png',
            height: 24,
          ),
        ),
      ),
    );
  }
}
