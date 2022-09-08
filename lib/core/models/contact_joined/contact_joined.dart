import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:introchat/core/models/user/user.dart';

part 'contact_joined.g.dart';

@JsonSerializable()
class ContactJoined {
  @JsonKey(ignore: true)
  String uid;
  String userId;

  @JsonKey(ignore: true)
  UserProfile userProfile;

  @JsonKey(
    name: 'created',
    fromJson: _timestampFromEpochUs,
    toJson: _timestampToEpochUs,
  )
  Timestamp created;

  static Timestamp _timestampFromEpochUs(int us) =>
      us == null ? null : Timestamp.fromMicrosecondsSinceEpoch(us);

  static int _timestampToEpochUs(Timestamp timestamp) =>
      timestamp?.microsecondsSinceEpoch;

  ContactJoined({
    this.uid,
    this.userId,
    this.created,
  });

  factory ContactJoined.fromJson(String uid, Map<String, dynamic> json) =>
      _$ContactJoinedFromJson(json)..uid = uid;

  Map<String, dynamic> toJson() => _$ContactJoinedToJson(this);
}
