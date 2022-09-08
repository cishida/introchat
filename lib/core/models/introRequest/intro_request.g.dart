// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntroRequest _$IntroRequestFromJson(Map json) {
  return IntroRequest(
    fromUid: json['fromUid'] as String,
    text: json['text'] as String,
    created: IntroRequest._timestampFromEpochUs(json['created'] as int),
    connectorUid: json['connectorUid'] as String,
    introchatContactUid: json['introchatContactUid'] as String,
  );
}

Map<String, dynamic> _$IntroRequestToJson(IntroRequest instance) =>
    <String, dynamic>{
      'fromUid': instance.fromUid,
      'text': instance.text,
      'connectorUid': instance.connectorUid,
      'introchatContactUid': instance.introchatContactUid,
      'created': IntroRequest._timestampToEpochUs(instance.created),
    };
