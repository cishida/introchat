import 'package:introchat/core/services/database.dart';
import 'package:introchat/core/utils/formatters/email_formatter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

class User {
  String uid;

  User({
    this.uid,
  });
}

@JsonSerializable()
class UserProfile {
  @JsonKey(ignore: true)
  String uid;

  String displayName;
  String email;
  bool onboarded;
  String phoneNumber;
  String photoUrl;
  Map<dynamic, dynamic> socialAccounts;
  bool preuser;
  List<String> fcmTokens;
  List<String> introchatContactIds;
  int unseenNotificationCount;
  bool makeIntroOnboarding;
  bool requestIntroOnboarding;
  bool homeOnboarding;

  UserProfile({
    this.uid,
    this.displayName = '',
    this.email = '',
    this.onboarded = false,
    this.photoUrl = '',
    this.phoneNumber = '',
    this.socialAccounts,
    this.preuser,
    this.fcmTokens,
    this.introchatContactIds,
    this.unseenNotificationCount,
    this.makeIntroOnboarding,
    this.requestIntroOnboarding,
    this.homeOnboarding,
  });

  Future update() async {
    await DatabaseService(uid: this.uid).updateUserProfile(this.toJson());
  }

  Future setHomeOnboarding() async {
    await DatabaseService(uid: this.uid)
        .updateUserProfile({'homeOnboarding': true});
  }

  Future setMakeIntroOnboarding() async {
    await DatabaseService(uid: this.uid)
        .updateUserProfile({'makeIntroOnboarding': true});
  }

  Future setRequestIntroOnboarding() async {
    await DatabaseService(uid: this.uid)
        .updateUserProfile({'requestIntroOnboarding': true});
  }

  factory UserProfile.fromJson(String uid, Map<String, dynamic> json) =>
      _$UserProfileFromJson(json)..uid = uid;

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String domain() {
    return EmailFormatter.getDomain(email);
    // String result = email.substring(email.indexOf("@"));
    // result.trim();
    // var pos = result.lastIndexOf('.');
    // result = (pos != -1) ? result.substring(0, pos) : result;
    // return result;
  }
}
