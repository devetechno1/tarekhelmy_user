class AuthResponseModel {
  String? token;
  bool? isPhoneVerified;
  bool? isEmailVerified;
  bool? isPersonalInfo;
  IsExistUser? isExistUser;
  String? loginType;
  String? email;

  AuthResponseModel({
    this.token,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.isPersonalInfo,
    this.isExistUser,
    this.loginType,
    this.email,
  });

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    isPhoneVerified = json['is_phone_verified'] == 1;
    isEmailVerified = json['is_email_verified'] == 1;
    isPersonalInfo = json['is_personal_info'] == 1;
    isExistUser = json['is_exist_user'] != null ? IsExistUser.fromJson(json['is_exist_user']) : null;
    loginType = json['login_type'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['is_phone_verified'] = isPhoneVerified;
    data['is_email_verified'] = isEmailVerified;
    data['is_personal_info'] = isPersonalInfo;
    if (isExistUser != null) {
      data['is_exist_user'] = isExistUser!.toJson();
    }
    data['login_type'] = loginType;
    data['email'] = email;
    return data;
  }
}

class IsExistUser {
  int? id;
  String? name;
  String? image;

  IsExistUser({this.id, this.name, this.image});

  IsExistUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
