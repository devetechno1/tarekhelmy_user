import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreRegistrationSuccessBottomSheet extends StatelessWidget {
  const StoreRegistrationSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.isDesktop(context) ? 500 : context.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius : ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(Dimensions.radiusExtraLarge) : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
          topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        ResponsiveHelper.isDesktop(context) ? const SizedBox() : Center(
          child: Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
            height: 5, width: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
          ),
        ),

        ResponsiveHelper.isDesktop(context) ? Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ) : const SizedBox(),

        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const CustomAssetImageWidget(Images.storeRegistrationSuccess),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('${'welcome_to'.tr} ${AppConstants.appName}!', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(
                'thanks_for_joining_us_your_registration_is_under_review_hang_tight_we_ll_notify_you_once_approved'.tr,
                textAlign: TextAlign.center,
                style: robotoRegular,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

              SafeArea(
                child: CustomButton(
                  width: 100,
                  buttonText: 'okay'.tr,
                  isBold: false,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]),
          ),
        ),
      ]),
    );
  }
}
