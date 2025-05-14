import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTag extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double? fontSize;
  final bool inLeft;
  final bool? freeDelivery;
  final bool? isFloating;
  const DiscountTag({super.key,
    required this.discount, required this.discountType, this.fromTop = 10, this.fontSize, this.freeDelivery = false,
    this.inLeft = true, this.isFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isRightSide = Get.find<SplashController>().configModel!.currencySymbolDirection == 'right';
    String currencySymbol = Get.find<SplashController>().configModel!.currencySymbol!;

    return (discount! > 0 || freeDelivery!) ? Positioned(
      top: fromTop, left: inLeft ? isFloating! ? Dimensions.paddingSizeSmall : 0 : null, right: inLeft ? null : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        width: isFloating!? 50: null,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withOpacity(0.9),
          shape: isFloating!? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isFloating! 
          ? null 
          : BorderRadius.horizontal(
            right: Radius.circular(inLeft ? Dimensions.radiusSmall : 0),
            left: Radius.circular(inLeft ? 0 : Dimensions.radiusSmall),
          ),
        ),
        child: Text(
          (discount! > 0 ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}${discount?.toInt()}${discountType == 'percent' ? '%'
              : isRightSide ? currencySymbol : ''} ${'off'.tr}' : 'free_delivery'.tr),
          style: robotoMedium.copyWith(
            color: Theme.of(context).cardColor,
            fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) && !isFloating! ? 8 : 12),
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    ) : const SizedBox();
  }
}
class DiscountEveryTag extends StatelessWidget {
  final String? textDiscount;
  final double? verticalPadding;
  const DiscountEveryTag({super.key,this.textDiscount, this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    if (textDiscount == null) return const SizedBox();
    return Positioned.fill(
      child: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: verticalPadding ?? Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          ),
          child: Text(
            textDiscount!,
            style: robotoMedium.copyWith(
              color: Theme.of(context).cardColor,
              fontSize: (ResponsiveHelper.isMobile(context) ? 10 : 13),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
