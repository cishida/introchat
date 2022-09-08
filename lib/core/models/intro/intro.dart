import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:introchat/core/models/user/user.dart';

part 'intro.g.dart';

@JsonSerializable()
class Intro {
  @JsonKey(ignore: true)
  String uid;
  String fromUid;
  String text;
  List<String> toUids;

  @JsonKey(ignore: true)
  UserProfile fromUserProfile;

  @JsonKey(ignore: true)
  List<UserProfile> toUserProfiles;

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

  Intro({
    this.uid,
    this.fromUid,
    this.text,
    this.toUids,
    this.created,
  });

  factory Intro.fromJson(String uid, Map<String, dynamic> json) =>
      _$IntroFromJson(json)..uid = uid;

  Map<String, dynamic> toJson() => _$IntroToJson(this);
}
