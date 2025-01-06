import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class RatingProgressWidget extends StatelessWidget {
  final String ratingNumber;
  final double ratingPercent;
  final double progressValue;
  const RatingProgressWidget({super.key, required this.ratingNumber, required this.ratingPercent, required this.progressValue});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Row(children: [

      Text(ratingNumber, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(
        child: LinearProgressIndicator(
          minHeight: isDesktop ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall,
          value: progressValue,
          backgroundColor: Theme.of(context).hintColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),

      Container(
        alignment: Alignment.centerRight,
        width: 50,
        child: Text('${ratingPercent.toStringAsFixed(1)}%', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color?.withOpacity(0.5))),
      ),

    ]);
  }
}