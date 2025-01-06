import 'package:sixam_mart/common/widgets/rating_bar.dart';
import 'package:sixam_mart/features/review/widgets/rating_progress_widget.dart';
import 'package:sixam_mart/features/review/widgets/total_rating_review_view_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class RatingWidget extends StatelessWidget {
  final double? averageRating;
  final int? ratingCount;
  final int? reviewCommentCount;
  final List<int>? ratings;
  const RatingWidget({super.key, this.averageRating, this.ratingCount, this.reviewCommentCount, this.ratings});

  @override
  Widget build(BuildContext context) {

    List<double>? percentages = ratings?.map((rating) {
      return (rating / ratings!.reduce((value, element) => value + element)) * 100;
    }).toList();

    List<double> progressForEach = calculateProgressForEach(percentages);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
      ),
      child: ResponsiveHelper.isDesktop(context) ? Column(children: [

        Row(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [

          Text(averageRating!.toStringAsFixed(1), style: robotoBold.copyWith(fontSize: 30)),

          Text('/5', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),

        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        RatingBar(rating: averageRating, ratingCount: null, size: 20),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          TotalRatingReviewViewWidget(totalNumber: ratingCount ?? 0, isRating: true),

          TotalRatingReviewViewWidget(totalNumber: reviewCommentCount ?? 0, isRating: false),

        ]),
        const SizedBox(height: 35),

        RatingProgressWidget(ratingNumber: '5', ratingPercent: percentages![0], progressValue: progressForEach[0]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RatingProgressWidget(ratingNumber: '4', ratingPercent: percentages[1], progressValue: progressForEach[1]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RatingProgressWidget(ratingNumber: '3', ratingPercent: percentages[2], progressValue: progressForEach[2]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RatingProgressWidget(ratingNumber: '2', ratingPercent: percentages[3], progressValue: progressForEach[3]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RatingProgressWidget(ratingNumber: '1', ratingPercent: percentages[4], progressValue: progressForEach[4]),

      ]) : Row(children: [

        Expanded(
          flex: 2,
          child: Column(children: [

            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [

              Text(averageRating!.toStringAsFixed(1), style: robotoBold.copyWith(fontSize: 30)),

              Text('/5', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),

            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingBar(rating: averageRating, ratingCount: null, size: 20),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(children: [

              TotalRatingReviewViewWidget(totalNumber: ratingCount ?? 0, isRating: true),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              TotalRatingReviewViewWidget(totalNumber: reviewCommentCount ?? 0, isRating: false),

            ]),

          ]),

        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          width: 1, height: 100,
          color: Theme.of(context).hintColor.withOpacity(0.5),
        ),

        Expanded(
          flex: 3,
          child: Column(children: [

            RatingProgressWidget(ratingNumber: '5', ratingPercent: percentages![0], progressValue: progressForEach[0]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: '4', ratingPercent: percentages[1], progressValue: progressForEach[1]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: '3', ratingPercent: percentages[2], progressValue: progressForEach[2]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: '2', ratingPercent: percentages[3], progressValue: progressForEach[3]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: '1', ratingPercent: percentages[4], progressValue: progressForEach[4]),

          ]),

        ),

      ]),
    );
  }

  List<double> calculateProgressForEach(List<double>? percentages) {
    if (percentages == null) return [];

    List<double> progressList = [];
    for (double percent in percentages) {
      double progress = percent / 100;
      progressList.add(progress);
    }
    return progressList;
  }

}

