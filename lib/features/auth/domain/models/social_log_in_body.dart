class SocialLogInBody {
  String? email;
  String? token;
  String? uniqueId;
  String? medium;
  String? phone;
  String? deviceToken;
  int? accessToken;
  String? loginType;
  String? verified;
  String? guestId;
  String? platform;

  SocialLogInBody({
    this.email,
    this.token,
    this.uniqueId,
    this.medium,
    this.phone,
    this.deviceToken,
    this.accessToken,
    this.loginType,
    this.verified,
    this.guestId,
    this.platform,
  });

  SocialLogInBody.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    token = json['token'];
    uniqueId = json['unique_id'];
    medium = json['medium'];
    phone = json['phone'];
    deviceToken = json['cm_firebase_token'];
    accessToken = json['access_token'];
    loginType = json['login_type'];
    verified = json['verified'];
    guestId = json['guest_id'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['token'] = token;
    data['unique_id'] = uniqueId;
    data['medium'] = medium;
    data['phone'] = phone;
    data['cm_firebase_token'] = deviceToken;
    if (accessToken != null) {
      data['access_token'] = accessToken;
    }
    data['login_type'] = loginType;
    if (verified != null) {
      data['verified'] = verified;
    }
    if (guestId != null) {
      data['guest_id'] = guestId;
    }
    if (platform != null) {
      data['platform'] = platform;
    }
    return data;
  }
}
