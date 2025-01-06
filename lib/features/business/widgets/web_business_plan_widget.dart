// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sixam_mart/common/widgets/custom_button.dart';
// import 'package:sixam_mart/features/auth/domain/models/store_body_model.dart';
// import 'package:sixam_mart/features/business/controllers/business_controller.dart';
// import 'package:sixam_mart/features/business/widgets/base_card_widget.dart';
// import 'package:sixam_mart/features/business/widgets/package_card_widget.dart';
// import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
// import 'package:sixam_mart/helper/route_helper.dart';
// import 'package:sixam_mart/util/dimensions.dart';
// import 'package:sixam_mart/util/images.dart';
// import 'package:sixam_mart/util/styles.dart';
//
// class WebBusinessPlanWidget extends StatelessWidget {
//   final int? storeId;
//   const WebBusinessPlanWidget({super.key, this.storeId});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BusinessController>(builder: (businessController) {
//       return Column(children: [
//
//         Container(
//           width: Dimensions.webMaxWidth,
//           padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
//           margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//             boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
//           ),
//           child: Column(children: [
//
//             Text('choose_your_business_plan'.tr, style: robotoBold),
//             const SizedBox(height: Dimensions.paddingSizeLarge),
//
//             Row(children: [
//
//               Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Expanded(
//                 child: BaseCardWidget(businessController: businessController, title: 'commission_base'.tr,
//                   description: "${'store_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
//                   index: 0, onTap: ()=> businessController.setBusiness(0),
//                 ),
//               ) : const SizedBox(),
//               SizedBox(width: Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Dimensions.paddingSizeLarge : 0),
//
//               Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0 ? Expanded(
//                 child: BaseCardWidget(businessController: businessController, title: 'subscription_base'.tr,
//                   description: 'run_store_by_purchasing_subscription_packages'.tr,
//                   index: 1, onTap: ()=> businessController.setBusiness(1),
//                 ),
//               ) : const SizedBox(),
//
//             ]),
//
//             businessController.businessIndex == 1 ? Column(children: [
//
//               const SizedBox(height: 50),
//               Text('choose_subscription_package'.tr, style: robotoBold),
//               const SizedBox(height: Dimensions.paddingSizeLarge),
//
//               businessController.packageModel != null ? SizedBox(
//                 height: 420, width: 700,
//                 child: businessController.packageModel!.packages!.isNotEmpty ? Swiper(
//                   itemCount: businessController.packageModel!.packages!.length,
//                   viewportFraction: 0.34,
//                   scale: 0.8,
//                   itemBuilder: (context, index) {
//                     return PackageCardWidget(
//                       canSelect: businessController.activeSubscriptionIndex == index,
//                       packages: businessController.packageModel!.packages![index],
//                     );
//                   },
//                   onIndexChanged: (index) {
//                     businessController.selectSubscriptionCard(index);
//                   },
//
//                 ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(Images.emptyBox, height: 150),
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//                       Text('no_package_available'.tr, style: robotoMedium),
//                     ]),
//                 ),
//               ) : const CircularProgressIndicator(),
//
//             ]) : const SizedBox(),
//
//           ]),
//         ),
//         const SizedBox(height: Dimensions.paddingSizeExtremeLarge),
//
//         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//           const SizedBox(width: Dimensions.paddingSizeLarge),
//
//           CustomButton(
//             textColor: Theme.of(context).cardColor,
//             radius: Dimensions.radiusSmall,
//             isLoading: businessController.isLoading,
//             width: 140,
//             onPressed: (businessController.businessIndex == 1 && businessController.packageModel == null && businessController.packageModel!.packages!.isEmpty) ? null : () {
//               if(businessController.businessIndex == 0) {
//                 businessController.submitBusinessPlan(storeId: storeId!, packageId: null);
//               } else {
//                 // Get.toNamed(RouteHelper.getSubscriptionPaymentRoute(
//                 //   storeId: storeId,
//                 //   packageId: businessController.packageModel!.packages![businessController.activeSubscriptionIndex].id,
//                 // ));
//               }
//             },
//             buttonText: businessController.businessIndex == 0 ? 'complete'.tr : 'next'.tr,
//             isBold: false,
//             fontSize: Dimensions.fontSizeSmall,
//           ),
//
//         ]),
//
//       ]);
//     });
//   }
// }
