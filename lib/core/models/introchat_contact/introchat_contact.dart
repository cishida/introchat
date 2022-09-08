import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'introchat_contact.g.dart';

@JsonSerializable()
class IntrochatContact {
  @JsonKey(ignore: true)
  String uid;
  @JsonKey(ignore: true)
  bool isChecked;

  @JsonKey(ignore: true)
  String domain;

  String displayName;
  String email;
  String userId;
  // List<String> connectedUserIds;
  String photoUrl;
  Map<String, String> userContactNames;

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

  IntrochatContact({
    this.uid,
    this.displayName,
    this.email,
    this.userId,
    this.created,
    this.isChecked = false,
    this.userProfile,
    // this.connectedUserIds,
    this.photoUrl,
    this.userContactNames,
    this.domain = '',
  });

  factory IntrochatContact.fromJson(String uid, Map<String, dynamic> json) =>
      _$IntrochatContactFromJson(json)..uid = uid;

  Map<String, dynamic> toJson() => _$IntrochatContactToJson(this);

  String getCorrectDisplayName(String uid) {
    return displayName != null
        ? displayName
        : (userContactNames[uid] != null ? userContactNames[uid] : '');
  }
}
