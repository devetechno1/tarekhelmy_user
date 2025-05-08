import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/cart_count_view.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool isPopularItem;
  final bool isFood;
  final bool isShop;
  final bool isPopularItemCart;
  final int? index;
  const ItemCard(
      {super.key,
      required this.item,
      this.isPopularItem = false,
      required this.isFood,
      required this.isShop,
      this.isPopularItemCart = false,
      this.index});

  @override
  Widget build(BuildContext context) {
    double? discount =
        item.storeDiscount == 0 ? item.discount : item.storeDiscount;
    String? discountType =
        item.storeDiscount == 0 ? item.discountType : 'percent';

    return OnHover(
      isItem: true,
      child: Stack(children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).cardColor,
          ),
          child: CustomInkWell(
            onTap: () =>
                Get.find<ItemController>().navigateToItemPage(item, context),
            radius: Dimensions.radiusLarge,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: isPopularItem
                            ? Dimensions.paddingSizeExtraSmall
                            : 0,
                        left: isPopularItem
                            ? Dimensions.paddingSizeExtraSmall
                            : 0,
                        right: isPopularItem
                            ? Dimensions.paddingSizeExtraSmall
                            : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Dimensions.radiusLarge),
                        topRight: const Radius.circular(Dimensions.radiusLarge),
                        bottomLeft: Radius.circular(
                            isPopularItem ? Dimensions.radiusLarge : 0),
                        bottomRight: Radius.circular(
                            isPopularItem ? Dimensions.radiusLarge : 0),
                      ),
                      child: CustomImage(
                        placeholder: Images.placeholder,
                        image: '${item.imageFullUrl}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  
                  DiscountEveryTag(
                    textDiscount: item.toGetFree != null && item.getFree != null
                        ? 'every_products_come_with_free'
                            .tr
                            .replaceAll("{every}", '${item.toGetFree}')
                            .replaceAll("{on}", "${item.getFree}")
                        : null,
                  ),
                  AddFavouriteView(
                    item: item,
                  ),
                  item.isStoreHalalActive! && item.isHalalItem!
                      ? const Positioned(
                          top: 40,
                          right: 15,
                          child: CustomAssetImageWidget(
                            Images.halalTag,
                            height: 20,
                            width: 20,
                          ),
                        )
                      : const SizedBox(),
                  DiscountTag(
                    discount: discount,
                    discountType: discountType,
                    freeDelivery: false,
                  ),
                  OrganicTag(item: item, placeInImage: false),
                  (Get.find<SplashController>().configModel!.moduleConfig!.module!.stock! && (item.stock ?? 0) <= 0)
                      ? Positioned(
                          bottom: 10,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                topRight:
                                    Radius.circular(Dimensions.radiusLarge),
                                bottomRight:
                                    Radius.circular(Dimensions.radiusLarge),
                              ),
                            ),
                            child: Text('out_of_stock'.tr,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeSmall)),
                          ),
                        )
                      : const SizedBox(),
                  isShop
                      ? const SizedBox()
                      : Positioned(
                          bottom: 10,
                          right: 20,
                          child: CartCountView(
                            item: item,
                            index: index,
                          ),
                        ),
                  Get.find<ItemController>().isAvailable(item)
                      ? const SizedBox()
                      : NotAvailableWidget(
                          radius: Dimensions.radiusLarge,
                          isAllSideRound: isPopularItem),
                ]),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: isShop ? 0 : Dimensions.paddingSizeSmall,
                      top: Dimensions.paddingSizeSmall,
                      bottom: isShop ? 0 : Dimensions.paddingSizeSmall),
                  child: Stack(clipBehavior: Clip.none, children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.paddingSizeSmall,
                          right: isShop ? Dimensions.paddingSizeSmall : 0,
                          bottom: isShop ? Dimensions.paddingSizeSmall : 0),
                      child: Align(
                        alignment: isPopularItem
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: isPopularItem
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: double.maxFinite),

                              (isFood || isShop)
                                  ? AppConstants.removeStores
                                      ? const SizedBox()
                                      : Text(item.storeName ?? '',
                                          style: robotoRegular.copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor))
                                  : Text(item.name ?? '',
                                      style: robotoBold,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),

                              (isFood || isShop)
                                  ? Flexible(
                                      child: Text(
                                        item.name ?? '',
                                        style: robotoBold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : item.ratingCount! > 0
                                      ? Row(
                                          mainAxisAlignment: isPopularItem
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.start,
                                          children: [
                                              Icon(Icons.star,
                                                  size: 14,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                  item.avgRating!
                                                      .toStringAsFixed(1),
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall)),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text("(${item.ratingCount})",
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .disabledColor)),
                                            ])
                                      : const SizedBox(),

                              // showUnitOrRattings(context);
                              (isFood || isShop)
                                  ? item.ratingCount! > 0
                                      ? Row(
                                          mainAxisAlignment: isPopularItem
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.start,
                                          children: [
                                              Icon(Icons.star,
                                                  size: 14,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text(
                                                  item.avgRating!
                                                      .toStringAsFixed(1),
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall)),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Text("(${item.ratingCount})",
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .disabledColor)),
                                            ])
                                      : const SizedBox()
                                  : (Get.find<SplashController>()
                                              .configModel!
                                              .moduleConfig!
                                              .module!
                                              .unit! &&
                                          item.unitType != null)
                                      ? Text(
                                          '(${item.unitType ?? ''})',
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              color:
                                                  Theme.of(context).hintColor),
                                        )
                                      : const SizedBox(),

                              discount != null && discount > 0
                                  ? Text(
                                      PriceConverter.convertPrice(
                                          Get.find<ItemController>()
                                              .getStartingPrice(item)),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).disabledColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      textDirection: TextDirection.ltr,
                                      maxLines: 1,
                                    )
                                  : const SizedBox(),
                              // SizedBox(height: item.discount != null && item.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                              Text(
                                PriceConverter.convertPrice(
                                  Get.find<ItemController>()
                                      .getStartingPrice(item),
                                  discount: discount,
                                  discountType: discountType,
                                ),
                                textDirection: TextDirection.ltr,
                                style: robotoMedium,
                              ),

                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                            ]),
                      ),
                    ),
                    isShop
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: CartCountView(
                              item: item,
                              index: index,
                              child: Container(
                                height: 35,
                                width: 38,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius:
                                      const BorderRadiusDirectional.only(
                                    topEnd:
                                        Radius.circular(Dimensions.radiusLarge),
                                    bottomStart:
                                        Radius.circular(Dimensions.radiusLarge),
                                  ),
                                ),
                                child: Icon(
                                    isPopularItemCart
                                        ? Icons.add_shopping_cart
                                        : Icons.add,
                                    color: Theme.of(context).cardColor,
                                    size: 20),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  // Widget? showUnitOrRattings(BuildContext context) {
  //   if(isFood || isShop) {
  //     if(item.ratingCount! > 0) {
  //       return Row(mainAxisAlignment: isPopularItem ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
  //         Icon(Icons.star, size: 14, color: Theme.of(context).primaryColor),
  //         const SizedBox(width: Dimensions.paddingSizeExtraSmall),
  //
  //         Text(item.avgRating!.toStringAsFixed(1), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
  //         const SizedBox(width: Dimensions.paddingSizeExtraSmall),
  //
  //         Text("(${item.ratingCount})", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
  //
  //       ]);
  //     }
  //   } else if(Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item.unitType != null) {
  //     return Text(
  //       '(${ item.unitType ?? ''})',
  //       style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
  //     );
  //   }
  // }
}

class ItemGridShimmer extends StatelessWidget {
  const ItemGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          height: 285,
          width: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          child: Column(children: [
            Container(
              height: 150,
              width: double.infinity,
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
                  height: 15,
                  width: 100,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  height: 20,
                  width: 200,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Container(
                  height: 15,
                  width: 100,
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
  }
}
