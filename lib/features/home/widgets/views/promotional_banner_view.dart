import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

class PromotionalBannerView extends StatelessWidget {
  const PromotionalBannerView({super.key, this.isBestReviewedSection = false, this.isNewArrivalSection = false, this.isBottomSection = false, this.newArrivalBanner = false, this.isTrending = false, this.isWeekEnd = false, this.isBrands = false});
  final bool isBestReviewedSection;
  final bool isNewArrivalSection;
  final bool isBottomSection;
  final bool newArrivalBanner;
  final bool isTrending;
  final bool isWeekEnd;
  final bool isBrands;

  @override
  Widget build(BuildContext context) {
    String? imageURL;
    return GetBuilder<BannerController>(builder: (bannerController) {
      if(isBestReviewedSection){
        imageURL = bannerController.promotionalBanner?.bestReviewedSectionBannerFullUrl;
      }else if(isNewArrivalSection){
        imageURL = bannerController.promotionalBanner?.newArrivalSectionBannerFullUrl;
      }else if(isBottomSection){
        imageURL = bannerController.promotionalBanner?.bottomSectionBannerFullUrl;
      }else if(newArrivalBanner){
        imageURL = bannerController.promotionalBanner?.newArrivalBannerFullUrl;
      }else if(isTrending){
        imageURL = bannerController.promotionalBanner?.trendingBannerFullUrl;
      }else if(isWeekEnd){
        imageURL = bannerController.promotionalBanner?.weekEndBannerFullUrl;
      }else if(isBrands){
        imageURL = bannerController.promotionalBanner?.brandsBannerFullUrl;
      }else{
        imageURL = null;
      }
      return bannerController.promotionalBanner != null ? imageURL != null ? AspectRatio(
        aspectRatio: 3,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            child: CustomImage(
              image: '$imageURL',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ) : const SizedBox() : const PromotionalBannerShimmerView();
    });
  }
}

class PromotionalBannerShimmerView extends StatelessWidget {
  const PromotionalBannerShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
        ),
      ),
    );
  }
}