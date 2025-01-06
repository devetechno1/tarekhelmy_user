import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/common/widgets/readmore_widget.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/review/domain/models/review_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  final String? storeName;
  const ReviewWidget({super.key, required this.review, required this.hasDivider, this.storeName});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(review.customerName ?? '', style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingBar(rating: review.rating!.toDouble(), ratingCount: null, size: 18),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            isDesktop ? Text(DateConverter.stringToLocalDateOnly(review.createdAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)) : const SizedBox(),
            SizedBox(height: isDesktop ?  Dimensions.paddingSizeExtraSmall : 0),

            isDesktop ? ReadMoreText(
              review.comment ?? '',
              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.7)),
              trimMode: TrimMode.Line,
              trimLines: 3,
              colorClickableText: Theme.of(context).primaryColor,
              lessStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
              trimCollapsedText: 'show_more'.tr,
              trimExpandedText: ' ${'show_less'.tr}',
              moreStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
            ) : Text(DateConverter.stringToLocalDateOnly(review.createdAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

          ]),
        ),
        SizedBox(width: isDesktop ? Dimensions.paddingSizeLarge : 0),

        isDesktop ? InkWell(
          onTap: () {
            Get.find<ItemController>().navigateToItemPage(review.item, context);
          },
          child: Column(children: [

            Container(
              height: 90, width: 120,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
              ),
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImage(
                  image: review.itemImageFullUrl ?? '',
                  height: 45, width: 45, fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(width: 120, alignment: Alignment.center, child: Text(review.itemName ?? '', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis, maxLines: 1)),

          ]),
        ) : InkWell(
          onTap: () {
            Get.find<ItemController>().navigateToItemPage(review.item, context);
          },
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
            ),
            child: Row(children: [

              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              SizedBox(
                width: 70,
                child: Text(review.itemName ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImage(
                  image: review.itemImageFullUrl ?? '',
                  height: 45, width: 45, fit: BoxFit.cover,
                ),
              ),

            ]),
          ),
        ),

      ]),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      isDesktop ? const SizedBox() : ReadMoreText(
        review.comment ?? '',
        style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.7)),
        trimMode: TrimMode.Line,
        trimLines: 3,
        colorClickableText: Theme.of(context).primaryColor,
        lessStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
        trimCollapsedText: 'show_more'.tr,
        trimExpandedText: ' ${'show_less'.tr}',
        moreStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
      ),
      SizedBox(height: isDesktop ? 0 : Dimensions.paddingSizeSmall),

      review.reply != null ? Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text(storeName ?? '', style: robotoMedium),

            Text(DateConverter.stringToLocalDateOnly(review.updatedAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          ReadMoreText(
            review.reply ?? '',
            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.7)),
            trimMode: TrimMode.Line,
            trimLines: 3,
            colorClickableText: Theme.of(context).primaryColor,
            lessStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
            trimCollapsedText: 'show_more'.tr,
            trimExpandedText: ' ${'show_less'.tr}',
            moreStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
          ),

        ]),
      ) : const SizedBox(),

      hasDivider ? Divider(
        height: 40, thickness: 1,
        color: Theme.of(context).disabledColor.withOpacity(0.5),
      ) : const SizedBox(),

    ]);
  }
}
