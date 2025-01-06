import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/verification/domein/models/verification_data_model.dart';

abstract class VerificationServiceInterface{
  Future<ResponseModel> forgetPassword(String? phone);
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword);
  //Future<ResponseModel> verifyPhone(String? phone, String otp, String? token);
  Future<ResponseModel> verifyPhone(VerificationDataModel data);
  Future<ResponseModel> verifyToken(String? phone, String token);
  //Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required bool isSignUpPage, required String? token});
  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required String loginType, required String? token, required bool isSignUpPage, required bool isForgetPassPage});
}