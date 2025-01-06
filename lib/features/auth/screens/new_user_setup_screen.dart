import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/auth/domain/enum/centralize_login_enum.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/validate_check.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class NewUserSetupScreen extends StatefulWidget {
  final String name;
  final String loginType;
  final String? phone;
  final String? email;
  const NewUserSetupScreen({super.key, required this.name, required this.loginType, required this.phone, required this.email});

  @override
  State<NewUserSetupScreen> createState() => _NewUserSetupScreenState();
}

class _NewUserSetupScreenState extends State<NewUserSetupScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String? _countryDialCode;
  GlobalKey<FormState>? _formKeyInfo;

  bool _isSocial = false;

  @override
  void initState() {
    super.initState();
    _isSocial = widget.loginType == CentralizeLoginType.social.name;
    _formKeyInfo = GlobalKey<FormState>();
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _isSocial ? _nameController.text = widget.name : _nameController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? null : AppBar(leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).textTheme.bodyLarge!.color),
      ), elevation: 0, backgroundColor: Theme.of(context).cardColor),
      body: SafeArea(child: Align(
        alignment: Alignment.center,
        child: Container(
          width: context.width > 700 ? 500 : context.width,
          padding: context.width > 700 ? const EdgeInsets.all(50) : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
          margin: context.width > 700 ? const EdgeInsets.all(50) : EdgeInsets.zero,
          decoration: context.width > 700 ? BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            boxShadow: ResponsiveHelper.isDesktop(context) ? null : [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
          ) : null,
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyInfo,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                ResponsiveHelper.isDesktop(context) ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ) : const SizedBox(),

                Image.asset(Images.logo, width: 125),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('just_one_step_away'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center),
                const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                CustomTextField(
                  titleText: 'ex_jhon'.tr,
                  labelText: 'user_name'.tr,
                  showLabelText: true,
                  required: true,
                  controller: _nameController,
                  focusNode: _nameFocus,
                  nextFocus: _isSocial ? _phoneFocus : _emailFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                  prefixIcon: CupertinoIcons.person_alt_circle_fill,
                  labelTextSize: Dimensions.fontSizeDefault,
                  validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_your_name".tr),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                _isSocial ? CustomTextField(
                  titleText: 'xxx-xxx-xxxxx'.tr,
                  labelText: 'phone'.tr,
                  showLabelText: true,
                  required: true,
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  nextFocus: _referCodeFocus,
                  inputType: TextInputType.phone,
                  isPhone: true,
                  onCountryChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                      : Get.find<LocalizationController>().locale.countryCode,
                  validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_phone_number".tr),
                ) : CustomTextField(
                  titleText: 'enter_email'.tr,
                  labelText: 'email'.tr,
                  showLabelText: true,
                  required: true,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  nextFocus: _referCodeFocus,
                  inputType: TextInputType.emailAddress,
                  prefixIcon: CupertinoIcons.mail_solid,
                  validator: (value) => ValidateCheck.validateEmail(value),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                (Get.find<SplashController>().configModel!.refEarningStatus == 1 ) ? CustomTextField(
                  titleText: 'refer_code'.tr,
                  labelText: 'refer_code'.tr,
                  showLabelText: true,
                  controller: _referCodeController,
                  focusNode: _referCodeFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.text,
                  capitalization: TextCapitalization.words,
                  prefixImage : Images.referCode,
                  divider: false,
                  prefixSize: 14,
                ) : const SizedBox(),
                SizedBox(height: (Get.find<SplashController>().configModel!.refEarningStatus == 1 ) ? Dimensions.paddingSizeExtraOverLarge : 0),

                GetBuilder<AuthController>(builder: (authController) {
                  return CustomButton(
                    height: ResponsiveHelper.isDesktop(context) ? 50 : null,
                    width:  ResponsiveHelper.isDesktop(context) ? 250 : null,
                    radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
                    isBold: !ResponsiveHelper.isDesktop(context),
                    fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : null,
                    buttonText: 'done'.tr,
                    isLoading: authController.isLoading,
                    onPressed: () async {
                      if(_formKeyInfo!.currentState!.validate()) {

                        if(widget.phone == null || widget.phone!.isEmpty) {
                          String numberWithCountryCode =  _countryDialCode! + _phoneController.text.trim();
                          PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
                          numberWithCountryCode = phoneValid.phone;
                          if(!phoneValid.isValid) {
                            showCustomSnackBar('invalid_phone_number'.tr);
                          } else {
                            _updatePersonalInfo(authController, numberWithCountryCode);
                          }
                        } else {
                          _updatePersonalInfo(authController, '');
                        }

                      }
                    },
                  );
                }),

              ]),
            ),
          ),

        ),
      )),
    );
  }

  void _updatePersonalInfo(AuthController authController, String numberWithCountryCode) {
    String name = _nameController.text.trim();
    authController.updatePersonalInfo(
      name: name.isNotEmpty ? name : widget.name, phone: (widget.phone != null && widget.phone!.isNotEmpty) ?  widget.phone : numberWithCountryCode,
      loginType: widget.loginType, email: widget.email ?? _emailController.text.trim(),
      referCode: _referCodeController.text.trim(),
    ).then((response) {
      if(response.isSuccess) {
        // Get.offAllNamed(RouteHelper.getInitialRoute());
        Get.find<LocationController>().navigateToLocationScreen('sign-in', offNamed: true);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }
}
