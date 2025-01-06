import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/auth/domain/models/auth_response_model.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/auth_repository_interface.dart';
import 'package:sixam_mart/features/verification/domein/models/verification_data_model.dart';
import 'package:sixam_mart/features/verification/domein/reposotories/verification_repository_interface.dart';
import 'package:sixam_mart/features/verification/domein/services/verification_service_interface.dart';

class VerificationService implements VerificationServiceInterface {
  final VerificationRepositoryInterface verificationRepoInterface;
  final AuthRepositoryInterface authRepoInterface;

  VerificationService({required this.verificationRepoInterface, required this.authRepoInterface});

  @override
  Future<ResponseModel> forgetPassword(String? phone) async {
    return await verificationRepoInterface.forgetPassword(phone);
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword) async {
    return await verificationRepoInterface.resetPassword(resetToken, number, password, confirmPassword);
  }

/*  @override
  Future<ResponseModel> verifyPhone(String? phone, String otp, String? token) async {
    ResponseModel responseModel = await verificationRepoInterface.verifyPhone(phone, otp);
    if(responseModel.isSuccess) {
      authRepoInterface.saveUserToken(token!);
      await authRepoInterface.updateToken();
      authRepoInterface.clearSharedPrefGuestId();
    }
    return responseModel;
  }*/

  @override
  Future<ResponseModel> verifyPhone(VerificationDataModel data) async {
    Response response = await verificationRepoInterface.verifyPhone(data);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      AuthResponseModel authResponse = AuthResponseModel.fromJson(response.body);
      if(authResponse.isExistUser == null && authResponse.isPersonalInfo!) {
        authRepoInterface.saveUserToken(authResponse.token ?? '');
        await authRepoInterface.updateToken();
        authRepoInterface.clearSharedPrefGuestId();
      }
      responseModel = ResponseModel(true, authResponse.token??'', authResponseModel: authResponse);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> verifyToken(String? phone, String token) async {
    return await verificationRepoInterface.verifyToken(phone, token);
  }

/*  @override
  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required bool isSignUpPage, required String? token}) async {
    ResponseModel responseModel = await verificationRepoInterface.verifyFirebaseOtp(phoneNumber: phoneNumber, session: session, otp: otp, isSignUpPage: isSignUpPage);
    if(responseModel.isSuccess && isSignUpPage) {
      authRepoInterface.saveUserToken(token!);
      await authRepoInterface.updateToken();
      authRepoInterface.clearSharedPrefGuestId();
    }
    return responseModel;
  }*/

  @override
  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required String loginType, required String? token, required bool isSignUpPage, required bool isForgetPassPage}) async {
    ResponseModel responseModel = ResponseModel(false, '');
    if(isForgetPassPage) {
      responseModel = await verificationRepoInterface.verifyForgetPassFirebaseOtp(phoneNumber: phoneNumber, session: session, otp: otp);
    } else {
      responseModel = await verificationRepoInterface.verifyFirebaseOtp(phoneNumber: phoneNumber, session: session, otp: otp, loginType: loginType);
      if(responseModel.isSuccess && responseModel.authResponseModel != null && responseModel.authResponseModel!.token != null) {
        authRepoInterface.saveUserToken(responseModel.authResponseModel!.token!);
        await authRepoInterface.updateToken();
        authRepoInterface.clearSharedPrefGuestId();
      }
    }
    return responseModel;
  }

}