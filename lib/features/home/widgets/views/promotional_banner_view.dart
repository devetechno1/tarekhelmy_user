import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

import '../../../../helper/route_helper.dart';
import '../../../brands/domain/models/brands_model.dart';
import '../../../category/domain/models/category_model.dart';
import '../../../item/domain/models/item_model.dart';
import '../../../item/screens/item_details_screen.dart';

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
    String? type ;
    Map<String, dynamic>? target ;
    return GetBuilder<BannerController>(builder: (bannerController) {
      if(isBestReviewedSection){
        imageURL = bannerController.promotionalBanner?.bestReviewedSectionBannerFullUrl;
        type = bannerController.promotionalBanner?.bestReviewedSectionBannerTypeBanner;
        target = bannerController.promotionalBanner?.bestReviewedSectionBannerTargetData;
      }else if(isNewArrivalSection){
        imageURL = bannerController.promotionalBanner?.newArrivalSectionBannerFullUrl;
        type = bannerController.promotionalBanner?.newArrivalSectionBannerTypeBanner;
        target = bannerController.promotionalBanner?.newArrivalSectionBannerTargetData;
      }else if(isBottomSection){
        imageURL = bannerController.promotionalBanner?.bottomSectionBannerFullUrl;
        type = bannerController.promotionalBanner?.bottomSectionBannerTypeBanner;
        target = bannerController.promotionalBanner?.bottomSectionBannerTargetData;
      }else if(newArrivalBanner){
        imageURL = bannerController.promotionalBanner?.newArrivalBannerFullUrl;
        type = bannerController.promotionalBanner?.newArrivalBannerTypeBanner;
        target = bannerController.promotionalBanner?.newArrivalBannerTargetData;
      }else if(isTrending){
        imageURL = bannerController.promotionalBanner?.trendingBannerFullUrl;
        type = bannerController.promotionalBanner?.trendingBannerTypeBanner;
        target = bannerController.promotionalBanner?.trendingBannerTargetData;
      }else if(isWeekEnd){
        imageURL = bannerController.promotionalBanner?.weekEndBannerFullUrl;
        type = bannerController.promotionalBanner?.weekEndBannerTypeBanner;
        target = bannerController.promotionalBanner?.weekEndBannerTargetData;
      }else if(isBrands){
        imageURL = bannerController.promotionalBanner?.brandsBannerFullUrl;
        type = bannerController.promotionalBanner?.brandsBannerTypeBanner;
        target = bannerController.promotionalBanner?.brandsBannerTargetData;
      }else{
        imageURL = null;
        type = null;
        target = null;
      }
      bool isHovered = false;
      return bannerController.promotionalBanner != null ? imageURL != null ? Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height /3, minHeight: 0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return AnimatedPadding(
                padding: isHovered? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                duration: const Duration(milliseconds: 300),
                child: InkWell(
                  onHover: (value) => setState(()=> isHovered = value),
                  onTap: type == null || target == null 
                  ? null
                  : (){
                    if(type == 'product'){
                      final Item item = Item.fromJson(target!);
                      Get.toNamed(RouteHelper.getItemDetailsRoute(item.id, false), arguments: ItemDetailsScreen(item: item, inStorePage: false, isCampaign: false));
                    }else if(type == 'category'){
                      final CategoryModel category = CategoryModel.fromJson(target!);
                      Get.toNamed(RouteHelper.getCategoryItemRoute(category.id, category.name!));
                    }else if(type == 'brand'){
                      final BrandModel brand = BrandModel.fromJson(target!);
                      Get.toNamed(RouteHelper.getBrandsItemScreen(brand.id!, brand.name!));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: AspectRatio(
                      aspectRatio:3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        child: CustomImage(
                          image: '$imageURL',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
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
    return Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height /3),
        alignment: Alignment.center,
        child: AspectRatio(
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
      ),
    );
  }
}