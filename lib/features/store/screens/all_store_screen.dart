import 'package:sixam_mart/features/store/controllers/store_controller.dart';
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

class AllStoreScreen extends StatefulWidget {
  final bool isPopular;
  final bool isFeatured;
  final bool isNearbyStore;
  final bool isTopOfferStore;
  const AllStoreScreen({super.key, required this.isPopular, required this.isFeatured, required this.isNearbyStore, required this.isTopOfferStore});

  @override
  State<AllStoreScreen> createState() => _AllStoreScreenState();
}

class _AllStoreScreenState extends State<AllStoreScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if(widget.isFeatured) {
      Get.find<StoreController>().getFeaturedStoreList();
    }else if(widget.isPopular) {
      Get.find<StoreController>().getPopularStoreList(false, 'all', false);
    }else if(widget.isTopOfferStore) {
      Get.find<StoreController>().getTopOfferStoreList(false, false);
    }else {
      Get.find<StoreController>().getLatestStoreList(false, 'all', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(
      builder: (storeController) {
        return Scaffold(
          appBar: CustomAppBar(
            title: widget.isFeatured ? 'featured_stores'.tr :  widget.isPopular
              ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
              ? widget.isNearbyStore ? 'best_store_nearby'.tr : 'popular_restaurants'.tr : widget.isNearbyStore ? 'best_store_nearby'.tr : 'popular_stores'.tr
                : widget.isTopOfferStore ? 'top_offers_near_me'.tr : '${'new_on'.tr} ${AppConstants.appName}',
            type: widget.isFeatured ? null : storeController.type,
            onVegFilterTap: (String type) {
              if(widget.isPopular) {
                Get.find<StoreController>().getPopularStoreList(true, type, true);
              }else {
                Get.find<StoreController>().getLatestStoreList(true, type, true);
              }
            },
          ),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: RefreshIndicator(
            onRefresh: () async {
              if(widget.isFeatured) {
                await Get.find<StoreController>().getFeaturedStoreList();
              }else if(widget.isPopular) {
                await Get.find<StoreController>().getPopularStoreList(
                  true, Get.find<StoreController>().type, false,
                );
              }else {
                await Get.find<StoreController>().getLatestStoreList(
                  true, Get.find<StoreController>().type, false,
                );
              }
            },
            child: SingleChildScrollView(
              controller: scrollController, child: FooterView(child: Column(
                children: [
                  WebScreenTitleWidget(title: widget.isFeatured ? 'featured_stores'.tr :  widget.isPopular
                      ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                      ? 'popular_restaurants'.tr : 'popular_stores'.tr : widget.isTopOfferStore ? 'top_offers_near_me'.tr : '${'new_on'.tr} ${AppConstants.appName}',
                  ),
                  SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: GetBuilder<StoreController>(builder: (storeController) {
                    return ItemsView(
                      isStore: true, items: null, isFeatured: widget.isFeatured,
                      noDataText: widget.isFeatured ? 'no_store_available'.tr : Get.find<SplashController>().configModel!.moduleConfig!
                          .module!.showRestaurantText! ? 'no_restaurant_available'.tr : 'no_store_available'.tr,
                      stores: widget.isFeatured ? storeController.featuredStoreList : widget.isPopular ? storeController.popularStoreList
                          : widget.isTopOfferStore ? storeController.topOfferStoreList : storeController.latestStoreList,
                    );
                  }),
            ),
                ],
              ))),
          ),
        );
      }
    );
  }
}
