import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/card_design/store_card_with_distance.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class WebTopOffersNearMe extends StatefulWidget {
  final bool isFood;
  final bool isPharmacy;
  final bool isShop;
  const WebTopOffersNearMe({super.key, this.isFood = false, this.isPharmacy = false, this.isShop = true});

  @override
  State<WebTopOffersNearMe> createState() => _WebTopOffersNearMeState();
}

class _WebTopOffersNearMeState extends State<WebTopOffersNearMe> {

  ScrollController scrollController = ScrollController();
  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    scrollController.addListener(_checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    setState(() {
      if (scrollController.position.pixels <= 0) {
        showBackButton = false;
      } else {
        showBackButton = true;
      }

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        showForwardButton = false;
      } else {
        showForwardButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store>? storeList = storeController.topOfferStoreList;

      if(storeList != null && storeList.length > 3 && isFirstTime){
        showForwardButton = true;
        isFirstTime = false;
      }

      return ((storeList != null && storeList.isEmpty) || (storeList == null && !storeController.isLoading)) ? const SizedBox() : Stack(children: [
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          padding: widget.isShop ? const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge) : EdgeInsets.zero,
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
              child: TitleWidget(
                title: 'top_offers_near_me'.tr, image: Images.fireIcon,
                onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute('topOffer')),
              ),
            ),

            SizedBox(
              height: 160, width: Get.width,
              child: storeList != null ? ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: storeList.length,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                itemBuilder: (context, index){

                  if(widget.isShop) {
                    return Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                      child: StoreCardWithDistance(store: storeList[index], fromAllStore: false, fromTopOffers: true,),
                    );
                  }
                  return topOfferCard(storeList[index], widget.isFood, widget.isPharmacy);

                },
              ) : WebNewOnMartShimmer(storeController: storeController),
            ),
          ]),
        ),

        if(showBackButton)
          Positioned(
            top: 130, left: 0,
            child: ArrowIconButton(
              isRight: false,
              onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

        if(showForwardButton)
          Positioned(
            top: 130, right: 0,
            child: ArrowIconButton(
              onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
            ),
          ),

      ]);
    });
  }

  Widget topOfferCard(Store store, bool isFood, bool isPharmacy) {
    double distance = Get.find<StoreController>().getRestaurantDistance(
      LatLng(double.parse(store.latitude!), double.parse(store.longitude!)),
    );
    double discount = store.discount?.discount ?? 0;
    String discountType = store.discount?.discountType ?? '';
    bool isRightSide = Get.find<SplashController>().configModel!.currencySymbolDirection == 'right';
    String currencySymbol = Get.find<SplashController>().configModel!.currencySymbol!;
    bool isAvailable = store.open == 1 && store.active!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
        left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
        right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
      ),
      child: TextHover(
          builder: (hovered) {
            return InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                if(Get.find<SplashController>().moduleList != null) {
                  for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                    if(module.id == store.moduleId) {
                      Get.find<SplashController>().setModule(module);
                      break;
                    }
                  }
                }
                Get.toNamed(
                  RouteHelper.getStoreRoute(id: store.id, page: 'store'),
                  arguments: StoreScreen(store: store, fromModule: false),
                );
              },
              child: Stack(
                children: [

                  OnHover(
                    isItem: true,
                    child: Container(
                      height: 180, width: 320,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Expanded(
                          flex: 8,
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: CustomImage(
                                isHovered: hovered,
                                image: '${store.logoFullUrl}',
                                height: 90, width: 90, fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                SizedBox(
                                  width: 150,
                                  child: Text(store.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // if(store.ratingCount! > 0)

                                if(store.ratingCount! > 0)
                                isFood ? RatingBar(
                                  rating: store.avgRating,
                                  ratingCount: store.ratingCount,
                                  size: 12,
                                ) : Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 14),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text('${store.avgRating}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text('(${store.ratingCount})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor)),
                                ]),

                                if(!isPharmacy)
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                                  Image.asset(Images.clockIcon, height: 10, width: 15, color: isAvailable ? const Color(0xffECA507) : Theme.of(context).colorScheme.error),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text(isAvailable ? 'open_now'.tr : 'closed_now'.tr, style: robotoRegular.copyWith(color: isAvailable ? const Color(0xffECA507) : Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeExtraSmall)),
                                ]),

                                Row(children: [

                                  Icon(Icons.storefront, size: 10, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Expanded(
                                    child: Text(store.address ?? '',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),

                                if(isPharmacy)
                                  distanceWidget(distance),


                              ]),
                            ),

                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        isPharmacy ?  const SizedBox(height: 10) : isFood ? distanceWidget(distance) : Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                            ),
                            child: Row(children: [

                              Expanded(
                                child: Row(children: [

                                  Image.asset(Images.distanceLine, height: 15, width: 15),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text(
                                    '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Text('from_you'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor)),
                                ]),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  discount > 0 ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%'
                                      : isRightSide ? currencySymbol : ''} ${'off'.tr}' : 'free_delivery'.tr,
                                  style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                  textAlign: TextAlign.center,
                                ),
                                // child: Text('new'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ),

                  // Positioned(
                  //   top: 7, left: Get.find<LocalizationController>().isLtr ? 0 : null,
                  //   right: Get.find<LocalizationController>().isLtr ? null : 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //     child: Text('new'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                  //   ),
                  // ),

                  isFood || isPharmacy ? Positioned(
                    bottom: 0, right: Get.find<LocalizationController>().isLtr ? 0 : null,
                    left: Get.find<LocalizationController>().isLtr ? null : 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                        color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                      ),
                      child: Text(
                        discount > 0 ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%'
                            : isRightSide ? currencySymbol : ''} ${'off'.tr}' : 'free_delivery'.tr,
                        style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                        textAlign: TextAlign.center,
                      ),
                      // child: Text('new'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                    ),
                  ) : const SizedBox(),

                  AddFavouriteView(
                    left: Get.find<LocalizationController>().isLtr ? null : 15,
                    right: Get.find<LocalizationController>().isLtr ? 15 : null,
                    item: null, storeId: store.id,
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget distanceWidget(double distance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(Images.distanceLine, height: 15, width: 15),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Text(
          '${distance > 100 ? '100+' : distance.toStringAsFixed(2)} ${'km'.tr}',
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Text('from_you'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor)),

      ]),
    );
  }
}

class WebNewOnMartShimmer extends StatelessWidget {
  final StoreController storeController;
  const WebNewOnMartShimmer({super.key, required this.storeController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
            left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
            right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
          ),
          child: Container(
            height: 150, width: 300,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.find<ThemeController>().darkTheme ? 400 : 300]!, blurRadius: 3, spreadRadius: 0.1,
              )],
            ),
            child: Column(children: [

              Expanded(
                flex: 5,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      direction: const ShimmerDirection.fromLTRB(),
                      child: Container(
                        height: 90, width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),

                      Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 10, width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      direction: const ShimmerDirection.fromLTRB(),
                      child: Icon(
                        Icons.favorite_border,  size: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Expanded(
                flex: 2,
                child: Row(children: [

                  Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 10, width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
