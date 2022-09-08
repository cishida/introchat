import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    Key key,
    this.text,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Color color;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: SizedBox.expand(
        child: RawMaterialButton(
          elevation: 4.0,
          fillColor: color ?? ConstantColors.BUTTON_PRIMARY,
          // splashColor: Colors.blueAccent,
          shape: const StadiumBorder(),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
