import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/profile/domain/models/update_user_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/profile/widgets/profile_bg_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/validate_check.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  JustTheController toolController = JustTheController();
  final ScrollController scrollController = ScrollController();
  bool isPhoneVerified = false;
  bool isEmailVerified = false;
  String? _countryDialCode;
  bool _isPhoneLoading = true;

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  void _initCall(){
    AuthController authController  = Get.find<AuthController>();
    _countryDialCode = authController.getUserCountryCode().isNotEmpty ? authController.getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

    if(Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    Get.find<ProfileController>().getUserInfo();
    Get.find<ProfileController>().initData();
  }

  @override
  void dispose() {
    toolController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _splitPhoneNumber(String number) async {
    _isPhoneLoading = true;
    try{
      PhoneValid phoneNumber = await CustomValidator.isPhoneValid(number);
      _phoneController.text = phoneNumber.phone.replaceFirst('+${phoneNumber.countryCode}', '');
      _countryDialCode = '+${phoneNumber.countryCode}';
    }catch(_) {}
    setState(() {
      _isPhoneLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GetBuilder<ProfileController>(builder: (profileController) {

        if(profileController.userInfoModel != null && _phoneController.text.isEmpty && _isPhoneLoading) {
          if(profileController.userInfoModel?.phone != null && profileController.userInfoModel!.phone!.isNotEmpty){
            _splitPhoneNumber(profileController.userInfoModel!.phone!);
          }
        }

        if(profileController.userInfoModel != null && _nameController.text.isEmpty ) {
          _nameController.text = '${profileController.userInfoModel?.fName ?? ''} ${profileController.userInfoModel?.lName ?? ''}';
        }

        if(profileController.userInfoModel != null && _emailController.text.isEmpty) {
          _emailController.text = profileController.userInfoModel?.email ?? '';
        }

        return isLoggedIn ? profileController.userInfoModel != null ? ResponsiveHelper.isDesktop(context) ? webView(profileController, isLoggedIn) : ProfileBgWidget(
          backButton: true,
          circularImage: Center(child: Stack(children: [

            ClipOval(child: profileController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
              profileController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover) : Image.file(
              File(profileController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover) : FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image: '${profileController.userInfoModel!.imageFullUrl}',
                height: 100, width: 100, fit: BoxFit.cover,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
            )),

            Positioned(
              bottom: 0, right: 0, top: 0, left: 0,
              child: InkWell(
                onTap: () => profileController.pickImage(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ),
            ),

          ])),
          mainWidget: Column(children: [

            Expanded(child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                SizedBox(height: 20, width: context.width),

                CustomTextField(
                  titleText: 'enter_name'.tr,
                  controller: _nameController,
                  capitalization: TextCapitalization.words,
                  inputType: TextInputType.name,
                  focusNode: _nameFocus,
                  nextFocus: _emailFocus,
                  prefixIcon: CupertinoIcons.person_alt_circle_fill,
                  labelText: 'name'.tr,
                  required: true,
                  validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_first_name".tr),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                CustomTextField(
                  titleText: 'enter_email'.tr,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  inputType: TextInputType.emailAddress,
                  prefixIcon: CupertinoIcons.mail_solid,
                  labelText: 'email'.tr,
                  required: true,
                  validator: (value) => ValidateCheck.validateEmail(value),
                  suffixImage: profileController.userInfoModel!.isEmailVerified! && profileController.userInfoModel!.email == _emailController.text
                   ? Images.verifiedIcon : Get.find<SplashController>().configModel!.centralizeLoginSetup!.emailVerificationStatus! ? Images.unverifiedIcon : null,
                  suffixOnPressed: () async {
                    if(!profileController.userInfoModel!.isEmailVerified! || profileController.userInfoModel!.email != _emailController.text) {
                      Get.dialog(const CustomLoaderWidget());
                      await _updateProfile(profileController: profileController, fromButton: false, fromPhone: false);
                    }
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                Stack(children: [

                  CustomTextField(
                    titleText: 'write_phone_number'.tr,
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    inputType: TextInputType.phone,
                    prefixIcon: CupertinoIcons.lock_fill,
                    isEnabled: !profileController.userInfoModel!.isPhoneVerified! || profileController.userInfoModel!.phone == null,
                    fromUpdateProfile: true,
                    labelText: 'phone'.tr,
                    required: true,
                    isPhone: true,
                    onCountryChanged: (CountryCode countryCode) => _countryDialCode = countryCode.dialCode,
                    countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
                    suffixImage: profileController.userInfoModel!.isPhoneVerified! ? Images.verifiedIcon : null,
                  ),

                  Positioned(
                    right: 15, top: 15,
                    child: !profileController.userInfoModel!.isPhoneVerified! && Get.find<SplashController>().configModel!.centralizeLoginSetup!.phoneVerificationStatus! ? InkWell(
                      onTap: () async {
                        if(!profileController.userInfoModel!.isPhoneVerified! && Get.find<SplashController>().configModel!.centralizeLoginSetup!.phoneVerificationStatus!) {
                          Get.dialog(const CustomLoaderWidget());
                          await _updateProfile(profileController: profileController, fromButton: false, fromPhone: true);
                        }
                      },
                      child: Image.asset(Images.unverifiedIcon, height: 20, width: 20, fit: BoxFit.cover),
                    ) : const SizedBox(),
                  ),

                ]),

              ]))),
            )),

            CustomButton(
              isLoading: profileController.isLoading,
              onPressed: () => _updateProfile(profileController: profileController, fromButton: true, fromPhone: false),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              buttonText: 'update'.tr,
            ),

          ]),
        ) : const Center(child: CircularProgressIndicator()) : NotLoggedInScreen(callBack: (value){
          _initCall();
          setState(() {});
        });
      }),
    );
  }

  Widget webView(ProfileController profileController, bool isLoggedIn) {
    return SingleChildScrollView(
      controller: scrollController,
      child: FooterView(
        child: Stack(children: [

          SizedBox(height: 520, width: context.width),

          Center(
            child: Container(
              height: 300, width: Dimensions.webMaxWidth,
              decoration: BoxDecoration(
               color: Theme.of(context).primaryColor,
                image: const DecorationImage(image: AssetImage(Images.profileBg), fit: BoxFit.fill),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  child: Text('profile'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor)),
                ),
              ),
            ),
          ),

          Positioned(
            top: 120, left: 0, right: 0,
            child: Center(
              child: Stack(clipBehavior : Clip.none, children: [

                Container(
                  alignment: Alignment.topCenter,
                  height: 400, width: Dimensions.webMaxWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge), bottom: Radius.circular(Dimensions.radiusDefault)),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                  ),
                ),

                Positioned(
                  top: -50, left: 0, right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(children: [

                      ClipOval(child: profileController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                          profileController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover) : Image.file(
                          File(profileController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover) : CustomImage(
                        image: '${profileController.userInfoModel!.imageFullUrl}',
                        height: 100, width: 100, fit: BoxFit.cover,
                      )),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => profileController.pickImage(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                    ]),
                  ),
                ),

                Positioned(
                  top: 80, left: 0, right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Center(
                      child: SizedBox(
                        width: 500,
                        child: Column(children: [

                          CustomTextField(
                            titleText: 'enter_name'.tr,
                            controller: _nameController,
                            capitalization: TextCapitalization.words,
                            inputType: TextInputType.name,
                            focusNode: _nameFocus,
                            nextFocus: _emailFocus,
                            prefixIcon: CupertinoIcons.person_alt_circle_fill,
                            labelText: 'name'.tr,
                            required: true,
                            validator: (value) => ValidateCheck.validateEmptyText(value, "first_name_field_is_required".tr),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                          CustomTextField(
                            titleText: 'enter_email'.tr,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: CupertinoIcons.mail_solid,
                            labelText: 'email'.tr,
                            required: true,
                            validator: (value) => ValidateCheck.validateEmail(value),
                            onChanged: (value) {
                              profileController.update();
                            },
                            suffixImage: profileController.userInfoModel!.isEmailVerified! && profileController.userInfoModel!.email == _emailController.text
                              ? Images.verifiedIcon : Get.find<SplashController>().configModel!.centralizeLoginSetup!.emailVerificationStatus! ? Images.unverifiedIcon : null,
                            suffixOnPressed: () {
                              if(!profileController.userInfoModel!.isEmailVerified! || profileController.userInfoModel!.email != _emailController.text) {
                                _updateProfile(profileController: profileController, fromButton: false, fromPhone: false);
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                          Stack(children: [
                            CustomTextField(
                              titleText: 'phone'.tr,
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              inputType: TextInputType.phone,
                              isEnabled: !profileController.userInfoModel!.isPhoneVerified! || profileController.userInfoModel!.phone == null,
                              fromUpdateProfile: true,
                              labelText: 'phone'.tr,
                              required: true,
                              isPhone: true,
                              onCountryChanged: (CountryCode countryCode) => _countryDialCode = countryCode.dialCode,
                              countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
                              suffixImage: profileController.userInfoModel!.isPhoneVerified! ? Images.verifiedIcon : null,
                            ),

                            Positioned(
                              right: 10, top: 10,
                              child: !profileController.userInfoModel!.isPhoneVerified! && Get.find<SplashController>().configModel!.centralizeLoginSetup!.phoneVerificationStatus! ? InkWell(
                                onTap: () {
                                  if(!profileController.userInfoModel!.isPhoneVerified! && Get.find<SplashController>().configModel!.centralizeLoginSetup!.phoneVerificationStatus!) {
                                    _updateProfile(profileController: profileController, fromButton: false, fromPhone: true);
                                  }
                                },
                                child: Image.asset(Images.unverifiedIcon, height: 25, width: 25, fit: BoxFit.cover),
                              ) : const SizedBox(),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                          CustomButton(
                            width: 500,
                            buttonText: 'update_profile'.tr,
                            fontSize: Dimensions.fontSizeDefault,
                            isBold: false,
                            radius: Dimensions.radiusSmall,
                            isLoading: profileController.isLoading,
                            onPressed: () => _updateProfile(profileController: profileController, fromButton: true, fromPhone: false),
                          ),

                        ]),
                      ),
                    ),
                  ),
                ),

              ]),
            ),
          ),

        ]),
      ),
    );
  }

  Future<void> _updateProfile({required ProfileController profileController, required bool fromButton, required bool fromPhone}) async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String numberWithCountryCode = _countryDialCode! + phoneNumber;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (name.isEmpty) {
      showCustomSnackBar('enter_your_name'.tr);
    }else if(!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UpdateUserModel updatedUser = UpdateUserModel(name: name, email: email, phone: numberWithCountryCode, buttonType: fromButton ? '' : fromPhone ? 'phone' : 'email');
      await profileController.updateUserInfo(updatedUser, Get.find<AuthController>().getUserToken(), fromButton: fromButton);
    }
  }
}
