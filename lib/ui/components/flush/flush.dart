import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';

class Flush {
  static Flushbar createFlush(String flushText) {
    return Flushbar(
      messageText: Text(
        flushText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ConstantColors.FLUSH_TEXT,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      titleText: null,
      // icon: Image.asset(
      //   'assets/images/logo-gray.png',
      //   height: 32.0,
      //   width: 32.0,
      // ),
      // padding: EdgeInsets.only(
      //   top: 15.0,
      //   bottom: 15.0,
      //   left: 30.0,
      // ),
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 750),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: ConstantColors.FLUSH_BACKGROUND,
    );
  }
}
