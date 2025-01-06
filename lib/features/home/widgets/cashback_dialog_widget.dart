import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/controllers/home_controller.dart';
import 'package:sixam_mart/features/home/widgets/cashback_logo_widget.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class CashBackDialogWidget extends StatelessWidget {
  const CashBackDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<HomeController>(
      builder: (homeController) {
        return homeController.cashBackOfferList != null ? Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
          alignment: Get.find<LocalizationController>().isLtr ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              isDesktop ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(CupertinoIcons.clear_circled_solid, color: Theme.of(context).hintColor, size: 30),
                ),
              ) : const SizedBox(),

              homeController.cashBackOfferList!.isNotEmpty ? Container(
                constraints: BoxConstraints(maxHeight: context.height*0.5, minHeight: 30),
                width: isDesktop ? 400 : context.width * 0.8,
                margin: EdgeInsets.only(right: isDesktop ? 20 : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxHeight: context.height*0.5, minHeight: 30),
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: ListView.builder(
                        itemCount: homeController.cashBackOfferList!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Text(homeController.cashBackOfferList![index].title??'', style: robotoBold,),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                child: Text(
                                  '${'min_spent'.tr} ${PriceConverter.convertPrice(homeController.cashBackOfferList![index].minPurchase!)} '
                                      '| ${'valid_till'.tr} ${DateConverter.stringToReadableString(homeController.cashBackOfferList![index].endDate!)}',
                                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                ),
                              ),
                              // Text('Min Spent \$500 |Valid till 22 Sept, 2023', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                            ],),
                          );
                        }),
                    ),
                  ],
                ),
              ) : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Text('no_offer_available'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                ),

              Container(
                height: 80, width: 65,
                margin: EdgeInsets.only(bottom: 20, right: ResponsiveHelper.isDesktop(context) ? 50 : 0),
                child: InkWell(onTap: () => Get.back(), child: const CashBackLogoWidget()),
              ),
            ],
          ),
        ) : const SizedBox();
      }
    );
  }
}
