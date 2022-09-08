// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introchat_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntrochatContact _$IntrochatContactFromJson(Map json) {
  return IntrochatContact(
    displayName: json['displayName'] as String,
    email: json['email'] as String,
    userId: json['userId'] as String,
    created: IntrochatContact._timestampFromEpochUs(json['created'] as int),
    photoUrl: json['photoUrl'] as String,
    userContactNames: (json['userContactNames'] as Map)?.map(
      (k, e) => MapEntry(k as String, e as String),
    ),
  );
}

Map<String, dynamic> _$IntrochatContactToJson(IntrochatContact instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'userId': instance.userId,
      'photoUrl': instance.photoUrl,
      'userContactNames': instance.userContactNames,
      'created': IntrochatContact._timestampToEpochUs(instance.created),
    };
