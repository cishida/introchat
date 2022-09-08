// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_joined.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactJoined _$ContactJoinedFromJson(Map json) {
  return ContactJoined(
    userId: json['userId'] as String,
    created: ContactJoined._timestampFromEpochUs(json['created'] as int),
  );
}

Map<String, dynamic> _$ContactJoinedToJson(ContactJoined instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'created': ContactJoined._timestampToEpochUs(instance.created),
    };
