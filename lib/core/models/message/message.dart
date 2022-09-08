import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:io';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String content;
  String senderUid;
  String introUid;
  String introRequestUid;
  bool directConnection;
  List<String> recipientUids;
  String notificationContent;
  String imageDownloadUrl;

  @JsonKey(ignore: true)
  String displayName;

  @JsonKey(ignore: true)
  File imageFile;

  // @JsonKey(
  //   name: 'uid'
  //   fromJson:
  // )

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

  Message({
    this.content,
    this.created,
    this.senderUid,
    this.introUid,
    this.introRequestUid,
    this.directConnection = false,
    this.displayName,
    this.recipientUids,
    this.notificationContent,
    this.imageFile,
    this.imageDownloadUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
