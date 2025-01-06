import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/auth/domain/enum/centralize_login_enum.dart';

class CentralizeLoginHelper {
  static ({CentralizeLoginType type, double size}) getPreferredLoginMethod(CentralizeLoginSetup data, bool isOtpViewEnable, {bool calculateWidth = false}) {
    if ((data.otpLoginStatus! && !data.manualLoginStatus! && !data.socialLoginStatus!) || isOtpViewEnable) {
      return (type: CentralizeLoginType.otp, size: 400);
    } else if(data.manualLoginStatus! && !data.socialLoginStatus! && !data.otpLoginStatus!) {
      return (type: CentralizeLoginType.manual, size: 500);
    } else if(data.socialLoginStatus! && !data.otpLoginStatus! && !data.manualLoginStatus!) {
      return (type: CentralizeLoginType.social, size: 500);
    } else if(data.manualLoginStatus! && data.socialLoginStatus! && !data.otpLoginStatus!) {
      return (type: CentralizeLoginType.manualAndSocial, size: 700);
    } else if(data.manualLoginStatus! && data.socialLoginStatus! && data.otpLoginStatus!) {
      return (type: CentralizeLoginType.manualAndSocialAndOtp, size: 700);
    } else if(!data.manualLoginStatus! && data.socialLoginStatus! && data.otpLoginStatus!) {
      return (type: CentralizeLoginType.otpAndSocial, size: 500);
    } else if(data.manualLoginStatus! && !data.socialLoginStatus! && data.otpLoginStatus!) {
      return (type: CentralizeLoginType.manualAndOtp, size: 700);
    } else {
      throw Exception('No login method available');
    }
  }
}