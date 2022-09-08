import 'package:introchat/core/models/connection/connection.dart';
import 'package:introchat/core/models/introchat_contact/introchat_contact.dart';

class ContactConnectionHelper {
  static bool isContactConnected(
    IntrochatContact introchatContact,
    List<Connection> connections,
  ) {
    if (introchatContact == null || connections == null) {
      return false;
    }
    final connectionUids =
        connections.map((connection) => connection.uid).toList();
    return introchatContact.userId != null &&
        connectionUids.contains(introchatContact.userId);
  }
}
