import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/common/widgets/card_design/item_card.dart';

import '../../../../util/images.dart';

class WeekendOfferView extends StatelessWidget {
  const WeekendOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? weekendOfferItemList = itemController.weekendOfferItemList;
      
      // print()

      return weekendOfferItemList != null ? weekendOfferItemList.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Container(
          color: Theme.of(context).disabledColor.withOpacity(0.1),
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
              child: TitleWidget(
                title: 'just_for_you'.tr,
                image: Images.starFill,

                onTap: () => Get.toNamed(RouteHelper.getWeekendOfferItemRoute()),
              ),
            ),

            SizedBox(
              height: 285, width: Get.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                itemCount: weekendOfferItemList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                    child: ItemCard(item: weekendOfferItemList[index], isPopularItem: false, isFood: false, isShop: true, index: index),
                  );
                  },
              ),
            ),
          ]),
        ),
      ) : const SizedBox() : const ItemShimmerView();
    });
  }
}

class ItemShimmerView extends StatelessWidget {
  const ItemShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Container(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
            child: TitleWidget(
              title: 'just_for_you'.tr,
            ),
          ),

          SizedBox(
            height: 285, width: Get.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      height: 285, width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      child: Column(children: [

                        Container(
                          height: 150, width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(children: [

                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              height: 15, width: 100,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              height: 20, width: 200,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              height: 15, width: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
