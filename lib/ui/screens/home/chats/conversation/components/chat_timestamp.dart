import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/core/utils/formatters/timestampFormatter.dart';

class ChatTimestamp extends StatelessWidget {
  ChatTimestamp({
    @required this.timestamp,
  });

  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    if (timestamp == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 0.0,
        bottom: 5.0,
      ),
      child: Text(
        TimestampFormatter.getTimeFromTimestamp(timestamp),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ConstantColors.CHAT_TIMESTAMP,
          fontSize: 13.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
