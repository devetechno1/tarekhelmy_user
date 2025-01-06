import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/features/auth/widgets/business/base_card_widget.dart';
import 'package:sixam_mart/features/business/widgets/package_card_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class WebBusinessPlanWidget extends StatelessWidget {
  const WebBusinessPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreRegistrationController>(builder: (storeRegController) {
      return Column(children: [

        Container(
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
          margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
          ),
          child: Column(children: [

            Text('choose_your_business_plan'.tr, style: robotoBold),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [

              Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Expanded(
                child: BaseCardWidget(storeRegistrationController: storeRegController, title: 'commission_base'.tr,
                  description: "${'store_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                  index: 0, onTap: ()=> storeRegController.setBusiness(0),
                ),
              ) : const SizedBox(),
              SizedBox(width: Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Dimensions.paddingSizeLarge : 0),

              Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0 ? Expanded(
                child: BaseCardWidget(storeRegistrationController: storeRegController, title: 'subscription_base'.tr,
                  description: 'run_store_by_purchasing_subscription_packages'.tr,
                  index: 1, onTap: ()=> storeRegController.setBusiness(1),
                ),
              ) : const SizedBox(),

            ]),

            storeRegController.businessIndex == 1 ? Column(children: [

              const SizedBox(height: 50),
              Text('choose_subscription_package'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              storeRegController.packageModel != null ? SizedBox(
                height: 420, width: 700,
                child: storeRegController.packageModel!.packages!.isNotEmpty ? Swiper(
                  itemCount: storeRegController.packageModel!.packages!.length,
                  viewportFraction: 0.34,
                  scale: 0.8,
                  itemBuilder: (context, index) {
                    return PackageCardWidget(
                      canSelect: storeRegController.activeSubscriptionIndex == index,
                      packages: storeRegController.packageModel!.packages![index],
                    );
                  },
                  onIndexChanged: (index) {
                    storeRegController.selectSubscriptionCard(index);
                  },

                ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.emptyBox, height: 150),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Text('no_package_available'.tr, style: robotoMedium),
                    ]),
                ),
              ) : const CircularProgressIndicator(),

            ]) : const SizedBox(),

          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

      ]);
    });
  }
}
