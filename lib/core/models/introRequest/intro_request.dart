import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intro_request.g.dart';

@JsonSerializable()
class IntroRequest {
  @JsonKey(ignore: true)
  String uid;
  String fromUid;
  String text;
  String connectorUid;
  String introchatContactUid;

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

  IntroRequest({
    this.uid,
    this.fromUid,
    this.text,
    this.created,
    this.connectorUid,
    this.introchatContactUid,
  });

  factory IntroRequest.fromJson(String uid, Map<String, dynamic> json) =>
      _$IntroRequestFromJson(json)..uid = uid;

  Map<String, dynamic> toJson() => _$IntroRequestToJson(this);
}
