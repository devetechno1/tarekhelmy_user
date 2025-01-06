class UpdateProfileResponseModel {
  String? verificationOn;
  String? verificationMedium;
  String? message;

  UpdateProfileResponseModel({this.verificationOn, this.verificationMedium, this.message});

  UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    verificationOn = json['verification_on'];
    verificationMedium = json['verification_medium'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verification_on'] = verificationOn;
    data['verification_medium'] = verificationMedium;
    data['message'] = message;
    return data;
  }
}
