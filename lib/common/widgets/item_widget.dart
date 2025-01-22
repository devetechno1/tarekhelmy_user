import 'package:sixam_mart/common/widgets/corner_banner/banner.dart';
import 'package:sixam_mart/common/widgets/corner_banner/corner_discount_tag.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_favourite_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/app_constants.dart';
import 'cart_count_view.dart';

class ItemWidget extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  final double? imageHeight;
  final double? imageWidth;
  final bool? isCornerTag;
  const ItemWidget(
      {super.key,
      required this.item,
      required this.isStore,
      required this.store,
      required this.index,
      required this.length,
      this.inStore = false,
      this.isCampaign = false,
      this.isFeatured = false,
      this.fromCartSuggestion = false,
      this.imageHeight,
      this.imageWidth,
      this.isCornerTag = false});

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<LocalizationController>().isLtr;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    String genericName = '';

    if (!isStore &&
        item!.genericName != null &&
        item!.genericName!.isNotEmpty) {
      for (String name in item!.genericName!) {
        genericName += name;
      }
    }
    if (isStore) {
      discount = store!.discount != null ? store!.discount!.discount : 0;
      discountType =
          store!.discount != null ? store!.discount!.discountType : 'percent';
      isAvailable = store!.open == 1 && store!.active!;
    } else {
      discount = (item!.storeDiscount == 0 || isCampaign)
          ? item!.discount
          : item!.storeDiscount;
      discountType = (item!.storeDiscount == 0 || isCampaign)
          ? item!.discountType
          : 'percent';
      isAvailable = DateConverter.isAvailable(
          item!.availableTimeStarts, item!.availableTimeEnds);
    }

    return Stack(
      children: [
        Container(
          margin: ResponsiveHelper.isDesktop(context)
              ? null
              : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
            ],
          ),
          child: CustomInkWell(
            onTap: () {
              if (isStore) {
                if (store != null) {
                  if (isFeatured &&
                      Get.find<SplashController>().moduleList != null) {
                    for (ModuleModel module
                        in Get.find<SplashController>().moduleList!) {
                      if (module.id == store!.moduleId) {
                        Get.find<SplashController>().setModule(module);
                        break;
                      }
                    }
                  }
                  Get.toNamed(
                    RouteHelper.getStoreRoute(
                        id: store!.id, page: isFeatured ? 'module' : 'item'),
                    arguments:
                        StoreScreen(store: store, fromModule: isFeatured),
                  );
                }
              } else {
                if (isFeatured &&
                    Get.find<SplashController>().moduleList != null) {
                  for (ModuleModel module
                      in Get.find<SplashController>().moduleList!) {
                    if (module.id == item!.moduleId) {
                      Get.find<SplashController>().setModule(module);
                      break;
                    }
                  }
                }
                Get.find<ItemController>().navigateToItemPage(item, context,
                    inStore: inStore, isCampaign: isCampaign);
              }
            },
            radius: Dimensions.radiusDefault,
            padding: (ResponsiveHelper.isDesktop(context)
                ? EdgeInsets.all(fromCartSuggestion
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall)
                : const EdgeInsetsDirectional.only(
                    top: Dimensions.paddingSizeSmall,
                    bottom: 0,
                    end: 0,
                    start: Dimensions.paddingSizeSmall)),
            child: TextHover(builder: (hovered) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        Stack(children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              isHovered: hovered,
                              image:
                                  '${isStore ? store != null ? store!.logoFullUrl : '' : item!.imageFullUrl}',
                              height: imageHeight ??
                                  (desktop
                                      ? 120
                                      : length == null
                                          ? 100
                                          : 90),
                              width: imageWidth ?? (desktop ? 120 : 90),
                              fit: BoxFit.cover,
                            ),
                          ),
                          if(isStore || isCornerTag!)
                              ...[
                                DiscountEveryTag(
                                  textDiscount: item?.toGetFree != null &&
                                          item?.getFree != null
                                      ? 'every_products_come_with_free'
                                          .tr
                                          .replaceAll(
                                              "{every}", '${item?.toGetFree}')
                                          .replaceAll(
                                              "{on}", "${item?.getFree}")
                                      : null,
                                ),
                                DiscountTag(
                                  discount: discount,
                                  discountType: discountType,
                                  freeDelivery:
                                      isStore ? store!.freeDelivery : false,
                                )
                              ],
                          !isStore
                              ? OrganicTag(item: item!, placeInImage: true)
                              : const SizedBox(),
                          isAvailable
                              ? const SizedBox()
                              : NotAvailableWidget(isStore: isStore),
                        ]),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    end: Dimensions.paddingSizeSmall),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      isStore
                                                          ? store!.name!
                                                          : item!.name!,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  (!isStore &&
                                                          Get.find<
                                                                  SplashController>()
                                                              .configModel!
                                                              .moduleConfig!
                                                              .module!
                                                              .vegNonVeg! &&
                                                          Get.find<
                                                                  SplashController>()
                                                              .configModel!
                                                              .toggleVegNonVeg!)
                                                      ? Image.asset(
                                                          item != null &&
                                                                  item!.veg == 0
                                                              ? Images
                                                                  .nonVegImage
                                                              : Images.vegImage,
                                                          height: 10,
                                                          width: 10,
                                                          fit: BoxFit.contain)
                                                      : const SizedBox(),
                                                  (Get.find<SplashController>()
                                                              .configModel!
                                                              .moduleConfig!
                                                              .module!
                                                              .unit! &&
                                                          item != null &&
                                                          item!.unitType !=
                                                              null)
                                                      ? Text(
                                                          '(${item!.unitType ?? ''})',
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                        )
                                                      : const SizedBox(),
                                                  SizedBox(
                                                      width: item!.isStoreHalalActive! &&
                                                              item!.isHalalItem!
                                                          ? Dimensions
                                                              .paddingSizeExtraSmall
                                                          : 0),
                                                  !isStore &&
                                                          item!
                                                              .isStoreHalalActive! &&
                                                          item!.isHalalItem!
                                                      ? const CustomAssetImageWidget(
                                                          Images.halalTag,
                                                          height: 13,
                                                          width: 13)
                                                      : const SizedBox(),
                                                  SizedBox(
                                                      width: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? 20
                                                          : 0),
                                                ]),
                                          ),
                                          const SizedBox(width: 5),
                                          GetBuilder<FavouriteController>(
                                              builder: (favouriteController) {
                                            bool isWished = isStore
                                                ? favouriteController
                                                    .wishStoreIdList
                                                    .contains(store!.id)
                                                : favouriteController
                                                    .wishItemIdList
                                                    .contains(item!.id);
                                            return CustomFavouriteWidget(
                                              isWished: isWished,
                                              isStore: isStore,
                                              store: store,
                                              item: item,
                                            );
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      (isStore
                                                  ? store!.address != null
                                                  : item!.storeName != null) &&
                                              !AppConstants.removeStores
                                          ? Text(
                                              isStore
                                                  ? store!.address ?? ''
                                                  : item!.storeName ?? '',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : const SizedBox(),
                                      (genericName.isNotEmpty)
                                          ? Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Text(
                                                  genericName,
                                                  style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                          height: ((desktop || isStore) &&
                                                  (isStore
                                                      ? store!.address != null
                                                      : item!.storeName !=
                                                          null))
                                              ? 3
                                              : 3),
                                      !isStore && (item!.ratingCount! > 0)
                                          ? Row(children: [
                                              Icon(Icons.star,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                item!.avgRating!
                                                    .toStringAsFixed(1),
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                '(${item!.ratingCount})',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              ),
                                            ])
                                          : const SizedBox(),
                                      SizedBox(
                                          height: (!isStore && desktop) ||
                                                  (!isStore &&
                                                      (item!.ratingCount! > 0))
                                              ? 3
                                              : 0),
                                      isStore &&
                                              (store != null &&
                                                  store!.ratingCount! > 0)
                                          ? Row(children: [
                                              Icon(Icons.star,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                store!.avgRating!
                                                    .toStringAsFixed(1),
                                                style: robotoMedium,
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                '(${store!.ratingCount})',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              ),
                                            ])
                                          : Row(children: [
                                              Text(
                                                PriceConverter.convertPrice(
                                                    item!.price,
                                                    discount: discount,
                                                    discountType: discountType),
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                                textDirection:
                                                    TextDirection.ltr,
                                              ),
                                              SizedBox(
                                                  width: discount! > 0
                                                      ? Dimensions
                                                          .paddingSizeExtraSmall
                                                      : 0),
                                              discount > 0
                                                  ? Text(
                                                      PriceConverter
                                                          .convertPrice(
                                                              item!.price),
                                                      style:
                                                          robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                      textDirection:
                                                          TextDirection.ltr,
                                                    )
                                                  : const SizedBox(),
                                            ]),
                                    ]),
                              ),
                              if (!isStore)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: CartCountView(
                                    item: item!,
                                    index: index,
                                    alignment: AlignmentDirectional.topEnd,
                                    bottomPadding: 6,
                                    child: Container(
                                      height: 35,
                                      width: 38,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            const BorderRadiusDirectional.only(
                                          topStart: Radius.circular(
                                              Dimensions.radiusLarge),
                                          bottomEnd: Radius.circular(
                                              Dimensions.radiusLarge),
                                        ),
                                      ),
                                      child: Icon(Icons.add_shopping_cart,
                                          color: Theme.of(context).cardColor,
                                          size: 20),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),

                        // Column(mainAxisAlignment: isStore ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [

                        //   const SizedBox(),

                        //   fromCartSuggestion ? Container(
                        //     decoration: BoxDecoration(
                        //       color: Theme.of(context).primaryColor,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        //     child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 12),
                        //   ) : GetBuilder<FavouriteController>(builder: (favouriteController) {
                        //     bool isWished = isStore ? favouriteController.wishStoreIdList.contains(store!.id) : favouriteController.wishItemIdList.contains(item!.id);
                        //     return CustomFavouriteWidget(
                        //       isWished: isWished,
                        //       isStore: isStore,
                        //       store: store,
                        //       item: item,
                        //     );
                        //   }),

                        // ]),
                      ]),
                    )),
                  ]);
            }),
          ),
        ),
        (!isStore && isCornerTag! == false)
            ? Positioned(
                right: ltr ? null : 0.01,
                left: ltr ? 0.01 : null,
                child: CornerDiscountTag(
                  bannerPosition: ltr
                      ? CornerBannerPosition.topLeft
                      : CornerBannerPosition.topRight,
                  elevation: 0,
                  discount: discount,
                  discountType: discountType,
                  freeDelivery: isStore ? store!.freeDelivery : false,
                ))
            : const SizedBox(),
      ],
    );
  }
}
