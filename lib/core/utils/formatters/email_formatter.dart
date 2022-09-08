import 'package:introchat/core/utils/extensions/string_extension.dart';

class EmailFormatter {
  static String getDomain(String email) {
    if (email != null && email != '') {
      String result = email.substring(email.indexOf("@"));
      result.trim();
      var pos = result.lastIndexOf('.');
      result = (pos != -1) ? result.substring(0, pos) : result;
      return result.capitalizeDomain();
    }

    return '';
  }
}
