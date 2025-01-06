import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/card_design/item_card.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/views/special_offer_view.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';

class AllOffersView extends StatelessWidget {
  const AllOffersView({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: GetBuilder<ItemController>(builder: (itemController) {
        List<Item>? itemList = null;
        // List<Item>? itemList = itemController.offersList;
          return (itemList != null) ? itemList.isNotEmpty ? Column(children: [
          
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
              child: TitleWidget(
                title: 'all_available_offers'.tr,
                image: Images.mostPopularIcon,
                onTap: () => Get.toNamed(RouteHelper.getPopularItemRoute(true, false)),
                // onTap: () => Get.toNamed(RouteHelper.getPopularItemRoute(true, false,true)),
              ),
            ),
          
            SizedBox(
              height: 285, width: Get.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                    child: ItemCard(
                      isPopularItem: false,
                      isPopularItemCart: true,
                      item: itemList[index],
                      isShop: true,
                      isFood: false,
                    ),
                  );
                },
              ),
            ),
          
          ]) 
          : const SizedBox() : itemController.isLoading? const ItemShimmerView(isPopularItem: true) : const SizedBox();
          // ]) : const SizedBox() : const ItemShimmerView(isPopularItem: true, isOffer: true);
        }
      ),
    );
  }
}
