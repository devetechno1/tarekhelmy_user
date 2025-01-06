import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class TotalRatingReviewViewWidget extends StatelessWidget {
  final bool isRating;
  final int totalNumber;
  const TotalRatingReviewViewWidget({super.key, required this.totalNumber, required this.isRating});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.only(left: isRating ? 50 : 10, right: isRating ? 10 : 50) : null,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Text('$totalNumber ${isRating ? 'ratings'.tr : 'reviews'.tr}', textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize:  ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : 8, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.6)),
        ),
      ),
    );
  }
}