// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map json) {
  return UserProfile(
    displayName: json['displayName'] as String,
    email: json['email'] as String,
    onboarded: json['onboarded'] as bool,
    photoUrl: json['photoUrl'] as String,
    phoneNumber: json['phoneNumber'] as String,
    socialAccounts: json['socialAccounts'] as Map,
    preuser: json['preuser'] as bool,
    fcmTokens: (json['fcmTokens'] as List)?.map((e) => e as String)?.toList(),
    introchatContactIds: (json['introchatContactIds'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    unseenNotificationCount: json['unseenNotificationCount'] as int,
    makeIntroOnboarding: json['makeIntroOnboarding'] as bool,
    requestIntroOnboarding: json['requestIntroOnboarding'] as bool,
    homeOnboarding: json['homeOnboarding'] as bool,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'onboarded': instance.onboarded,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'socialAccounts': instance.socialAccounts,
      'preuser': instance.preuser,
      'fcmTokens': instance.fcmTokens,
      'introchatContactIds': instance.introchatContactIds,
      'unseenNotificationCount': instance.unseenNotificationCount,
      'makeIntroOnboarding': instance.makeIntroOnboarding,
      'requestIntroOnboarding': instance.requestIntroOnboarding,
      'homeOnboarding': instance.homeOnboarding,
    };
