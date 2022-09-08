// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map json) {
  return Message(
    content: json['content'] as String,
    created: Message._timestampFromEpochUs(json['created'] as int),
    senderUid: json['senderUid'] as String,
    introUid: json['introUid'] as String,
    introRequestUid: json['introRequestUid'] as String,
    directConnection: json['directConnection'] as bool,
    recipientUids:
        (json['recipientUids'] as List)?.map((e) => e as String)?.toList(),
    notificationContent: json['notificationContent'] as String,
    imageDownloadUrl: json['imageDownloadUrl'] as String,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'content': instance.content,
      'senderUid': instance.senderUid,
      'introUid': instance.introUid,
      'introRequestUid': instance.introRequestUid,
      'directConnection': instance.directConnection,
      'recipientUids': instance.recipientUids,
      'notificationContent': instance.notificationContent,
      'imageDownloadUrl': instance.imageDownloadUrl,
      'created': Message._timestampToEpochUs(instance.created),
    };
