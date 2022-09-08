import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimestampFormatter {
  static String getDateFromTimestamp(Timestamp timestamp,
      {DateFormat dateFormat}) {
    if (dateFormat == null) {
      dateFormat = DateFormat('EEEE, MMM d');
      // h:mm a
    }
    var format = dateFormat;
    var date = DateTime.fromMillisecondsSinceEpoch(
      timestamp.millisecondsSinceEpoch,
    );
    return format.format(date);
  }

  static String getTimeFromTimestamp(Timestamp timestamp,
      {DateFormat dateFormat}) {
    if (dateFormat == null) {
      dateFormat = DateFormat('h:mm a');
      // h:mm a
    }
    var format = dateFormat;
    var date = DateTime.fromMillisecondsSinceEpoch(
      timestamp.millisecondsSinceEpoch,
    );
    return format.format(date);
  }

  String getChatTileTime(Timestamp timestamp) {
    int difference = DateTime.now().millisecondsSinceEpoch -
        timestamp.millisecondsSinceEpoch;
    String result;

    if (difference < 60000) {
      result = 'now';
    } else if (difference < 3600000) {
      result = countMinutes(difference);
    } else if (difference < 86400000) {
      result = countHours(difference);
    } else if (difference / 1000 < 31536000) {
      result = countDays(difference);
    } else {
      result = countYears(difference);
    }

    return result;
  }

  String countMinutes(int difference) {
    int count = (difference / 60000).truncate();
    return count.toString() + 'm';
  }

  String countHours(int difference) {
    int count = (difference / 3600000).truncate();
    return count.toString() + 'h';
  }

  String countDays(int difference) {
    int count = (difference / 86400000).truncate();
    return count.toString() + 'd';
  }

  String countYears(int difference) {
    int count = (difference / 31536000000).truncate();
    return count.toString() + 'y';
  }
}
