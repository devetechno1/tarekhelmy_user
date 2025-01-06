import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/auth/widgets/web_registration_stepper_widget.dart';
import 'package:sixam_mart/features/business/controllers/business_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class SubscriptionSuccessOrFailedScreen extends StatefulWidget {
  final bool success;
  final bool fromSubscription;
  final int? storeId;
  const SubscriptionSuccessOrFailedScreen({super.key, required this.success, required this.fromSubscription, this.storeId});

  @override
  State<SubscriptionSuccessOrFailedScreen> createState() => _SubscriptionSuccessOrFailedScreenState();
}

class _SubscriptionSuccessOrFailedScreenState extends State<SubscriptionSuccessOrFailedScreen> {
  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: Scaffold(
        appBar: isDesktop ? CustomAppBar(title: 'store_registration'.tr) : null,
        endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,

        body: SingleChildScrollView(
          child: FooterView(
            child: Column(children: [

              WebScreenTitleWidget(title: 'join_as_store'.tr),

              SizedBox(width: Dimensions.webMaxWidth, child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

                  SizedBox(height: isDesktop ? Dimensions.paddingSizeExtremeLarge : 0),

                  isDesktop ? GetBuilder<BusinessController>(
                    builder: (businessController) {
                      return const SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: RegistrationStepperWidget(status: 'complete'),
                      );
                    }
                  ) : Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeExtraOverLarge, bottom: Dimensions.paddingSizeLarge,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(
                        'store_registration'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),

                      Text(
                        widget.success ? 'registration_success'.tr : 'transaction_failed'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      LinearProgressIndicator(
                        backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                        value: widget.success ? 1 : 0.75,
                      ),

                    ]),
                  ),
                  SizedBox(height: isDesktop ? Dimensions.paddingSizeExtraOverLarge : context.height * 0.2),

                  Container(
                    width: Dimensions.webMaxWidth,
                    padding: EdgeInsets.all(isDesktop ? 40 : 0),
                    decoration: isDesktop ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                    ) : null,
                    child: Column(children: [

                      CustomAssetImageWidget(
                        widget.success ? Images.checkGif : Images.cancelGif,
                        height: isDesktop ? 100 : 100,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: widget.success ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            '${'congratulations'.tr}!',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            width: isDesktop ? 500 : context.width,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(style: robotoRegular.copyWith(color: Theme.of(context).hintColor, height: 1.7), children: [
                                TextSpan(text: widget.fromSubscription ? '${'subscription_success_message'.tr} ' : '${'commission_base_success_message'.tr} '),
                              ]),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

                          TextButton(
                            onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
                            child: Text(
                              'continue_to_home_page'.tr,
                              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                            ),
                          ),

                        ]) : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text(
                            '${'transaction_failed'.tr}!',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            width: isDesktop ? 500 : context.width,
                            child: Text(
                              'sorry_your_transaction_can_not_be_completed_please_choose_another_payment_method_or_try_again'.tr,
                              style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          TextButton(
                            onPressed: () {
                              // Get.toNamed(RouteHelper.getBusinessPlanRoute(widget.storeId));
                            },
                            child: Text(
                              'try_again'.tr,
                              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                            ),
                          ),

                        ]),
                      ),
                    ]),
                  ),

                ]),
              )),

            ]),
          ),
        ),
      ),
    );
  }
}
