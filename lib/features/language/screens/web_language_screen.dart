import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/features/language/widgets/language_card_widget.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class WebLanguageScreen extends StatelessWidget {
  const WebLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizationController) {
      return Column(children: [
        WebScreenTitleWidget(title: 'language'.tr),

        Expanded(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FooterView(
            child: Center(child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

               Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                   color: Theme.of(context).cardColor,
                   boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                 ),
                 padding: const EdgeInsets.all(Dimensions.paddingSizeExtraOverLarge),
                 margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge, top: Dimensions.paddingSizeExtraLarge),
                 child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                   Expanded(
                     child: Container(
                       height: 400,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                         color: Theme.of(context).disabledColor.withOpacity(0.1),
                       ),
                       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                       child: const CustomAssetImageWidget(
                         Images.languageBackground, fit: BoxFit.contain,
                       ),
                     ),
                   ),
                   const SizedBox(width: 70),

                   Expanded(child: Padding(
                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                     child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                       Text('choose_your_language'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                       Text('choose_your_language_to_proceed'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                       const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                       SingleChildScrollView(
                         child: ListView.builder(
                           itemCount: localizationController.languages.length,
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                               child: LanguageCardWidget(
                                 languageModel: localizationController.languages[index],
                                 localizationController: localizationController,
                                 index: index,
                                 fromWeb: true,
                               ),
                             );
                           },
                         ),
                       ),
                       const SizedBox(height: Dimensions.paddingSizeLarge),

                       CustomButton(
                         buttonText: 'update'.tr,
                         width: 200,
                         onPressed: () {

                           int index = localizationController.selectedLanguageIndex;

                           localizationController.setLanguage(Locale(
                             AppConstants.languages[index].languageCode!,
                             AppConstants.languages[index].countryCode,
                           ));

                           if(localizationController.languages.isNotEmpty && localizationController.selectedLanguageIndex != -1) {
                             localizationController.saveCacheLanguage(Locale(
                               AppConstants.languages[localizationController.selectedLanguageIndex].languageCode!,
                               AppConstants.languages[localizationController.selectedLanguageIndex].countryCode,
                             ));
                           }
                           showCustomSnackBar('language_updated_successfully'.tr, isError: false);
                         },
                       ),

                     ]),
                   )),

                 ]),
               ),


              ]),
            )),
          ),
        )),
      ]);
    });
  }
}
