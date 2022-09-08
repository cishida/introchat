import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingNavBar extends StatelessWidget {
  const OnboardingNavBar({
    Key key,
    @required this.index,
    @required this.backPressed,
    @required this.nextPressed,
  }) : super(key: key);

  final int index;
  final Function() backPressed;
  final Function() nextPressed;

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
          GestureDetector(
            onTap: backPressed,
            child: Text(
              'Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DotsIndicator(
            dotsCount: 2,
            position: index.toDouble(),
          ),
          GestureDetector(
            onTap: nextPressed,
            child: Text(
              index == 2 ? 'Done' : 'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
