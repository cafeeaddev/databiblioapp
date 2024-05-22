import 'package:granth_flutter/utils/model_keys.dart';

class MoodleLoginResponse {
  String? error;
  String? token;

  MoodleLoginResponse({this.error, this.token});

  factory MoodleLoginResponse.fromJson(Map<String, dynamic> json) {
    return MoodleLoginResponse(
      error: json[CommonKeys.error],
      token: json[CommonKeys.token] != null ? json[CommonKeys.token] : "",
    );
  }
}

class MoodleBasicUserData {
  int? userid;
  String? username;
  String? fullname;

  MoodleBasicUserData({this.userid, this.username, this.fullname});

  factory MoodleBasicUserData.fromJson(Map<String, dynamic> json) {
    return MoodleBasicUserData(
      userid: json[UserKeys.userId],
      username: json[UserKeys.userName],
      fullname: json[UserKeys.fullname]
    );
  }
}

class MoodleUserData {
  String? email;
  String? profilePicture;
  String? contactNumber;

  MoodleUserData({this.email, this.profilePicture, this.contactNumber});

  factory MoodleUserData.fromJson(Map<String, dynamic> json) {
    return MoodleUserData(
        email: json[UserKeys.email],
        profilePicture: json[UserKeys.profilePicture],
        contactNumber: ""
    );
  }
}

