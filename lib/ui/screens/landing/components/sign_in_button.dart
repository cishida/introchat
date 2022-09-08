import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class SignInButton extends StatelessWidget {
  SignInButton({@required this.text, @required this.onPressed});

  final String text;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: ConstantColors.BUTTON_PRIMARY,
      splashColor: Colors.blueAccent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 54.0),
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
