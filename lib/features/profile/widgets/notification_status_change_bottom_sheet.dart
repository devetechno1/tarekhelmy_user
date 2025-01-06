import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class NotificationStatusChangeBottomSheet extends StatelessWidget {
  const NotificationStatusChangeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(Dimensions.radiusLarge) : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: GetBuilder<AuthController>(builder: (authController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          ResponsiveHelper.isDesktop(context) ?
              Align(alignment: Alignment.topRight, child: IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.clear))) : Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: 35),

          const CustomAssetImageWidget(
            Images.warning, height: 50, width: 50,
          ),
          const SizedBox(height: 35),

          Text('are_you_sure'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              !authController.notification ? 'you_want_to_enable_notification'.tr : 'you_want_to_disable_notification'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),

          Row(children: [

            Expanded(
              child: !authController.notificationLoading ? CustomButton(
                onPressed: () async {
                  await authController.setNotificationActive(!authController.notification);
                  Get.back();
                },
                buttonText: 'yes'.tr,
                color: Theme.of(context).colorScheme.error,
              ) : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.error)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: CustomButton(
                onPressed: () {
                  Get.back();
                },
                buttonText: 'no'.tr,
                color: Theme.of(context).disabledColor.withOpacity(0.5),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),

          ]),

        ]);
      }),
    );
  }
}
