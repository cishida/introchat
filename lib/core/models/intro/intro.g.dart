// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Intro _$IntroFromJson(Map json) {
  return Intro(
    fromUid: json['fromUid'] as String,
    text: json['text'] as String,
    toUids: (json['toUids'] as List)?.map((e) => e as String)?.toList(),
    created: Intro._timestampFromEpochUs(json['created'] as int),
  );
}

Map<String, dynamic> _$IntroToJson(Intro instance) => <String, dynamic>{
      'fromUid': instance.fromUid,
      'text': instance.text,
      'toUids': instance.toUids,
      'created': Intro._timestampToEpochUs(instance.created),
    };
