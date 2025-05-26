import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';

import '../../../common/widgets/title_widget.dart';
import '../../../util/images.dart';
import '../domain/models/item_model.dart';

class PopularItemScreen extends StatefulWidget {
  final bool isPopular;
  final bool isSpecial;
  final bool showBackButton;
  const PopularItemScreen({super.key, required this.isPopular, required this.isSpecial, this.showBackButton = true});

  @override
  State<PopularItemScreen> createState() => _PopularItemScreenState();
}

class _PopularItemScreenState extends State<PopularItemScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if(widget.isPopular) {
      Get.find<ItemController>().getPopularItemList(true, Get.find<ItemController>().popularType, false);
    }else if(widget.isSpecial){
      Get.find<ItemController>().getDiscountedItemList(true, false, Get.find<ItemController>().discountedType);
    } else {
      Get.find<ItemController>().getReviewedItemList(true, Get.find<ItemController>().reviewType, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isShop = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.ecommerce;

    final String title = widget.isPopular ? isShop ? 'most_popular_products'.tr : 'most_popular_items'.tr : widget.isSpecial ? 'special_offer'.tr : 'best_reviewed_item'.tr;
    final String? image = widget.isPopular ? Images.mostPopularIcon : widget.isSpecial ? Images.discountOfferIcon : null;

    return GetBuilder<ItemController>(
      builder: (itemController) {
        List<Item>? items;
        if(widget.isPopular) {
          items = itemController.popularItemList;
        }else if(widget.isSpecial){
          items = itemController.discountedItemList;
        }else {
          items = itemController.reviewedItemList;
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(
            key: scaffoldKey,
            title: title,
            backButton: widget.showBackButton,
            widget: image != null ? TitleWidget(
              title: title,
              image: image,
              mainAxisAlignment: MainAxisAlignment.center,
            ) : null,
            showCart: widget.showBackButton,
            type: widget.isPopular ? itemController.popularType : widget.isSpecial ? itemController.discountedType : itemController.reviewType,
            onVegFilterTap: (String type) {
              if(widget.isPopular) {
                itemController.getPopularItemList(true, type, true);
              }else if(widget.isSpecial){
                itemController.getDiscountedItemList(true, true, type);
              }else {
                itemController.getReviewedItemList(true, type, true);
              }
            },
          ),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if(scrollNotification.metrics.pixels >= 0.9 * scrollNotification.metrics.maxScrollExtent && !itemController.isLoadingMore) {
                if(widget.isPopular) {
                  itemController.getMorePopularItemList();
                }else if(widget.isSpecial){
                  itemController.getMoreDiscountedItemList();
                }else {
                  itemController.getMoreReviewedItemList();
                }
              }
              return false;
            },
            child: SingleChildScrollView(
              child: FooterView(child: Column(
                children: [
                  WebScreenTitleWidget(title: title, image: image),
              
                  SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(
                      children: [
                        ItemsView(isStore: false, stores: null, items: items),
                        if(itemController.isLoadingMore)
                          Center(child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(bottom: widget.showBackButton? null : 100),
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                          )),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ),
        );
      }
    );
  }
}
