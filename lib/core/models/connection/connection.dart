import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/firestore/connection_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connection.g.dart';

enum ConnectionStatus {
  pending,
  unaccepted,
  accepted,
  blocked,
}

extension ConnectionStatusExtension on ConnectionStatus {
  static ConnectionStatus fromString(String string) {
    switch (string) {
      case 'pending':
        return ConnectionStatus.pending;
        break;
      case 'unaccepted':
        return ConnectionStatus.unaccepted;
        break;
      case 'accepted':
        return ConnectionStatus.accepted;
        break;
      case 'blocked':
        return ConnectionStatus.blocked;
        break;
      default:
        return null;
    }
  }
}

@JsonSerializable()
class Connection {
  @JsonKey(ignore: true)
  String uid;
  String conversationUid;
  String lastMessage;
  int unseenNotificationCount;

  // @JsonKey(
  //   name: 'status',
  //   fromJson: _toConnectionStatus,
  //   toJson: _connectionStatusToString,
  // )
  ConnectionStatus status;
  String temporaryDisplayName;

  @JsonKey(ignore: true)
  UserProfile userProfile;

  @JsonKey(
    name: 'mostRecentActivity',
    fromJson: _timestampFromEpochUs,
    toJson: _timestampToEpochUs,
  )
  Timestamp mostRecentActivity;

  @JsonKey(
    name: 'lastViewed',
    fromJson: _timestampFromEpochUs,
    toJson: _timestampToEpochUs,
  )
  Timestamp lastViewed;

  static Timestamp _timestampFromEpochUs(int us) =>
      us == null ? null : Timestamp.fromMicrosecondsSinceEpoch(us);
  static int _timestampToEpochUs(Timestamp timestamp) =>
      timestamp?.microsecondsSinceEpoch;

  Connection({
    this.uid,
    this.conversationUid,
    this.mostRecentActivity,
    this.lastViewed,
    this.lastMessage,
    this.status,
    // this.name,
    // this.photoUrl = '',
    this.userProfile,
    this.temporaryDisplayName = '',
    this.unseenNotificationCount = 0,
  });

  factory Connection.fromJson(String uid, Map<String, dynamic> json) =>
      _$ConnectionFromJson(json)..uid = uid;

  Map<String, dynamic> toJson() => _$ConnectionToJson(this);

  updateLastViewed(String currentUserUid) async {
    ConnectionService connectionService = ConnectionService();
    await connectionService.updateLastViewed(currentUserUid, uid);
  }

  Future accept(UserProfile currentUserProfile) async {
    ConnectionService connectionService = ConnectionService();
    return connectionService.acceptConnection(currentUserProfile, this);
  }
}
