import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/confirmation_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/auth/widgets/web_registration_stepper_widget.dart';
import 'package:sixam_mart/features/business/controllers/business_controller.dart';
import 'package:sixam_mart/features/business/widgets/payment_cart_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final int storeId;
  final int packageId;
  const SubscriptionPaymentScreen({super.key, required this.storeId, required this.packageId});

  @override
  State<SubscriptionPaymentScreen> createState() => _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final bool _canBack = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    // Get.find<BusinessController>().getPackageList(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<BusinessController>(builder: (businessController) {
      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, result) async{
          if(_canBack) {
          }else {
            _showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
          }
        },
        child: Scaffold(
          appBar: isDesktop ? CustomAppBar(title: 'store_registration'.tr) : null,
          endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,

          body: Column(children: [

            WebScreenTitleWidget(title: 'join_as_store'.tr),

            const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

            isDesktop ? SizedBox(
              width: Dimensions.webMaxWidth,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: RegistrationStepperWidget(status: Get.find<BusinessController>().businessPlanStatus),
              ),
            ) : Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  'store_registration'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                Text(
                  'you_are_one_step_away_choose_your_business_plan'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                  value: 0.75,
                ),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: FooterView(
                  minHeight: 0.45,
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(children: [

                      Container(
                        margin: EdgeInsets.only(top: isDesktop ? Dimensions.paddingSizeSmall : 0),
                        decoration: isDesktop ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                        ) : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 50 : 0,
                          vertical:  isDesktop ? Dimensions.paddingSizeDefault : 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(children: [

                            Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus ?? false ? PaymentCartWidget(
                              title: '${'continue_with'.tr} ${Get.find<SplashController>().configModel!.subscriptionFreeTrialDays} '
                                  '${Get.find<SplashController>().configModel!.subscriptionFreeTrialType} ${'days_free_trial'.tr}',
                              index: 0,
                              onTap: () {
                                businessController.setPaymentIndex(0);
                              },
                            ) : const SizedBox(),
                            SizedBox(height: Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus??false ? Dimensions.paddingSizeExtremeLarge : 0),

                            Get.find<SplashController>().configModel!.digitalPayment! ? Column(children: [
                              Row(children: [
                                Text('${'pay_via_online'.tr} ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                Text(
                                  'faster_and_secure_way_to_pay_bill'.tr,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                ),
                              ]),

                              SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),

                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                                  mainAxisSpacing: Dimensions.paddingSizeLarge,
                                  mainAxisExtent: 55,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Get.find<SplashController>().configModel!.activePaymentMethodList!.length,
                                itemBuilder: (context, index) {
                                  bool isSelected = businessController.paymentIndex == 1 && Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay! == businessController.digitalPaymentName;

                                  return InkWell(
                                    onTap: (){
                                      businessController.setPaymentIndex(1);
                                      businessController.changeDigitalPaymentName(Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWay!);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: isSelected ? Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 0.3) : null,
                                        boxShadow: isSelected ? null : [const BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                                      child: Row(children: [
                                        Container(
                                          height: 20, width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                            border: Border.all(color: Theme.of(context).disabledColor),
                                          ),
                                          child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        Text(
                                          Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayTitle!,
                                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                        ),
                                        const Spacer(),

                                        CustomImage(
                                          height: 20, fit: BoxFit.contain,
                                          image: '${Get.find<SplashController>().configModel!.activePaymentMethodList![index].getWayImageFullUrl}',
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                      ]),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: !isDesktop ? Dimensions.paddingSizeLarge : 0),
                            ]) : const SizedBox(),

                          ]),
                        ),
                      ),

                      SizedBox(height: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),

                      isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3)),
                          ),
                          width: 120,
                          child: CustomButton(
                            transparent: true,
                            textColor: Theme.of(context).disabledColor,
                            radius: Dimensions.radiusSmall,
                            onPressed: () {
                              Get.back();
                            },
                            buttonText: 'back'.tr,
                            isBold: false,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomButton(
                          textColor: Theme.of(context).cardColor,
                          radius: Dimensions.radiusSmall,
                          width: 140,
                          buttonText: 'confirm'.tr,
                          onPressed: () {
                            businessController.submitBusinessPlan(storeId: widget.storeId, packageId: widget.packageId);
                          },
                          isBold: false,
                          fontSize: Dimensions.fontSizeSmall,
                        ),

                      ]) : const SizedBox(),

                    ]),
                  ),
                ),
              ),
            ),

            !isDesktop ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
              child: CustomButton(
                buttonText: 'confirm'.tr,
                isLoading: businessController.isLoading,
                onPressed: () {
                  businessController.submitBusinessPlan(storeId: widget.storeId, packageId: widget.packageId);
                },
              ),
            ) : const SizedBox(),

          ]),
        ),
      );
    });
  }

  void _showBackPressedDialogue(String title){
    Get.dialog(ConfirmationDialog(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () {
        if(Get.isDialogOpen!){
          Get.back();
        }
        Get.back();
      },
    ), useSafeArea: false);
  }
}
