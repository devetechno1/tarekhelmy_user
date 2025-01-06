import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/business/controllers/business_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),
            SizedBox(height: context.height * 0.2),

            Image.asset(Images.checked, height: 90,width: 90),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text('congratulations'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              'your_registration_has_been_completed_successfully'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center, softWrap: true,
            ),

          ]),
        ),
      );
    });
  }
}