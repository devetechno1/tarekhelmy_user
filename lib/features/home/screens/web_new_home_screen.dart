import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/home/widgets/all_store_filter_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_brands_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_top_offers_near_me.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/home/widgets/web/middle_section_multiple_banner_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/module_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_basic_medicine_nearby_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_best_review_item_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_best_store_nearby_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_category_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_common_condition_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_coupon_banner_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_featured_categories_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_flash_sale_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_item_that_you_love_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_just_for_you_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_most_popular_item_banner_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_most_popular_item_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_new_banner_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_new_on_mart_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_new_on_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_populer_store_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_promotional_banner_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_recomanded_store_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_special_offer_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/web_visit_again_view_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/paginated_list_view.dart';
import 'package:sixam_mart/features/dashboard/widgets/address_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';

class WebNewHomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const WebNewHomeScreen({super.key, required this.scrollController});

  @override
  State<WebNewHomeScreen> createState() => _WebNewHomeScreenState();
}

class _WebNewHomeScreenState extends State<WebNewHomeScreen> {

  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();
    _isLogin = AuthHelper.isLoggedIn();
    Get.find<SplashController>().getWebSuggestedLocationStatus();

    if(_isLogin){
      suggestAddressBottomSheet();
    }
  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<LocationController>().checkLocationActive();
    if(!Get.find<SplashController>().webSuggestedLocation && active){
      Future.delayed(const Duration(seconds: 1), () {
        Get.dialog(Center(child: SizedBox(height: 470, width: 550, child: AddressBottomSheetWidget(fromDialog: true,text: '${'hey_welcome_back'.tr}\n${'which_location_do_you_want_to_select'.tr}'))));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.pharmacy;
    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;
    bool isShop = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.ecommerce;
    Get.find<BannerController>().setCurrentIndex(0, false);
    bool isLoggedIn = AuthHelper.isLoggedIn();

    return Stack(clipBehavior: Clip.none, children: [

      SizedBox(height: context.height),

      CustomScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(crossAxisAlignment : CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                    flex: 3,
                    child: GetBuilder<BannerController>(builder: (bannerController) {
                      return bannerController.bannerImageList == null ?  const WebNewBannerViewWidget(isFeatured: false)
                          : bannerController.bannerImageList!.isEmpty ? const SizedBox() : const WebNewBannerViewWidget(isFeatured: false);
                    }),
                  ),

                  GetBuilder<StoreController>(builder: (storeController) {
                    return GetBuilder<FlashSaleController>(builder: (flashController) {
                      bool isFlashSaleActive = (flashController.flashSaleModel?.activeProducts != null && flashController.flashSaleModel!.activeProducts!.isNotEmpty);
                      if(!isFlashSaleActive && AppConstants.removeStores) return const SizedBox();
                      return Expanded(
                        child: Row(
                          children: [
                            const SizedBox(width: Dimensions.paddingSizeDefault),
                            Expanded(
                              flex: 1,
                              child: isFlashSaleActive ? const WebFlashSaleViewWidget() :  const WebRecommendedStoreView(),
                            ),
                          ],
                        ),
                      );
                    });
                  }),
                ]),

                const BadWeatherWidget(),

                GetBuilder<CategoryController>(builder: (categoryController) {
                  return categoryController.categoryList == null ? WebCategoryViewWidget(categoryController: categoryController)
                      : categoryController.categoryList!.isEmpty ? const SizedBox() : WebCategoryViewWidget(categoryController: categoryController);
                }),

                _isLogin && !AppConstants.removeStores ?  WebVisitAgainView(fromFood: isFood) : const SizedBox(),

                isPharmacy ? const WebBasicMedicineNearbyViewWidget()
                    : isShop ? const WebMostPopularItemViewWidget(isShop: true, isFood: false)
                    : const WebSpecialOfferView(isFood: false, isShop: false),

                const WebHighlightWidget(),

                (isPharmacy || isShop) ? const MiddleSectionMultipleBannerViewWidget()
                    : isFood ? const WebBestReviewItemViewWidget()
                    :  AppConstants.removeStores? const SizedBox() : const WebBestStoreNearbyViewWidget(),

                isPharmacy ? AppConstants.removeStores? const SizedBox() : const WebBestStoreNearbyViewWidget()
                    : isFood ? AppConstants.removeStores? const SizedBox() : const WebNewOnViewWidget(isFood: true)
                    : isShop ? AppConstants.removeStores? const SizedBox() : const WebPopularStoresView()
                    : const WebMostPopularItemViewWidget(isFood: false, isShop: false),

                isShop ? const WebBrandsViewWidget() : (isPharmacy || isFood) ? const SizedBox() : const SizedBox(),

                isPharmacy ? const WebJustForYouViewWidget()
                    : isFood ? const WebItemThatYouLoveViewWidget()
                    : isShop ? const WebSpecialOfferView(isFood: false, isShop: true)
                    : GetBuilder<CampaignController>(builder: (campaignController) {
                      return campaignController.basicCampaignList == null ?  WebMostPopularItemBannerViewWidget(campaignController: campaignController)
                      : campaignController.basicCampaignList!.isEmpty ? const SizedBox()
                      : WebMostPopularItemBannerViewWidget(campaignController: campaignController);
                }),

                isPharmacy ? AppConstants.removeStores? const SizedBox() : const WebNewOnViewWidget()
                    : isFood ? const WebMostPopularItemViewWidget(isFood: true, isShop: false)
                    : isShop ? const WebBestReviewItemViewWidget()
                    : const WebBestReviewItemViewWidget(),

                isPharmacy ? const WebCommonConditionViewWidget()
                    : isFood ? const WebJustForYouViewWidget()
                    : isShop ? const WebJustForYouViewWidget()
                    : const SizedBox(),

                WebTopOffersNearMe(isFood: isFood, isPharmacy: isPharmacy, isShop: isShop),

                isPharmacy ? const SizedBox()
                    : isFood ?  AppConstants.removeStores? const SizedBox(): const WebNewOnMartViewWidget()
                    : isShop ? const  WebFeaturedCategoriesViewWidget()
                    : const WebJustForYouViewWidget(),

                (isPharmacy || isFood) ? const SizedBox() : isShop ? const SizedBox() : const WebItemThatYouLoveViewWidget(),

                (isPharmacy || isFood) ? const SizedBox() : isShop ? const WebItemThatYouLoveForShop() : isLoggedIn ? const WebCouponBannerViewWidget() : const SizedBox(),

                (isPharmacy || isFood) || AppConstants.removeStores ? const SizedBox() : isShop ? const WebNewOnViewWidget() : const WebNewOnMartViewWidget(),

                isFood ? const SizedBox() : const WebPromotionalBannerView(),

              ])),
            ),
          ),

          if(!AppConstants.removeStores)...[
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                height: 85,
                child: const AllStoreFilterWidget(),
              ),
            ),

            SliverToBoxAdapter(
              child: GetBuilder<StoreController>(builder: (storeController) {
                return FooterView(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: PaginatedListView(
                      scrollController: widget.scrollController,
                      totalSize: storeController.storeModel?.totalSize,
                      offset: storeController.storeModel?.offset,
                      onPaginate: (int? offset) async => await storeController.getStoreList(offset!, false),
                      itemView: ItemsView(
                        isStore: true, items: null,
                        stores: storeController.storeModel?.stores,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                          vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ]else
          const SliverToBoxAdapter(child: SizedBox(height: 100)),

        ],
      ),

      const PositionedDirectional(end: 0, top: 0, bottom: 0, child: Center(child: ModuleWidget())),

    ]);
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 50});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}
