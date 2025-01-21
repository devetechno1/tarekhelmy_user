import 'dart:developer';

class PromotionalBanner {
  String? bestReviewedSectionBanner;
  String? bestReviewedSectionBannerFullUrl;
  String? bestReviewedSectionBannerTypeBanner;
  int? bestReviewedSectionBannerTargetBanner;
  String? newArrivalSectionBanner;
  String? newArrivalSectionBannerFullUrl;
  String? newArrivalSectionBannerTypeBanner;
  int? newArrivalSectionBannerTargetBanner;
  String? bottomSectionBanner;
  String? bottomSectionBannerFullUrl;
  String? bottomSectionBannerTypeBanner;
  int? bottomSectionBannerTargetBanner;
  String? newArrivalBanner;
  String? newArrivalBannerFullUrl;
  String? newArrivalBannerTypeBanner;
  int? newArrivalBannerTargetBanner;
  String? trendingBanner;
  String? trendingBannerFullUrl;
  String? trendingBannerTypeBanner;
  int? trendingBannerTargetBanner;
  String? weekEndBanner;
  String? weekEndBannerFullUrl;
  String? weekEndBannerTypeBanner;
  int? weekEndBannerTargetBanner;
  String? brandsBanner;
  String? brandsBannerFullUrl;
  String? brandsBannerTypeBanner;
  int? brandsBannerTargetBanner;

  PromotionalBanner({
    this.bestReviewedSectionBanner,
    this.bestReviewedSectionBannerFullUrl,
    this.bestReviewedSectionBannerTypeBanner,
    this.bestReviewedSectionBannerTargetBanner,
    this.newArrivalSectionBanner,
    this.newArrivalSectionBannerFullUrl,
    this.newArrivalSectionBannerTypeBanner,
    this.newArrivalSectionBannerTargetBanner,
    this.bottomSectionBanner,
    this.bottomSectionBannerFullUrl,
    this.bottomSectionBannerTypeBanner,
    this.bottomSectionBannerTargetBanner,
    this.newArrivalBanner,
    this.newArrivalBannerFullUrl,
    this.newArrivalBannerTypeBanner,
    this.newArrivalBannerTargetBanner,
    this.trendingBanner,
    this.trendingBannerFullUrl,
    this.trendingBannerTypeBanner,
    this.trendingBannerTargetBanner,
    this.weekEndBanner,
    this.weekEndBannerFullUrl,
    this.weekEndBannerTypeBanner,
    this.weekEndBannerTargetBanner,
    this.brandsBanner,
    this.brandsBannerFullUrl,
    this.brandsBannerTypeBanner,
    this.brandsBannerTargetBanner,
  });

  bool get isNullClass =>
      bestReviewedSectionBanner == null &&
      newArrivalSectionBanner == null &&
      bottomSectionBanner == null &&
      newArrivalBanner == null &&
      trendingBanner == null &&
      weekEndBanner == null &&
      brandsBanner == null;

  PromotionalBanner.fromJson(Map<String, dynamic> json) {
    log("banner_type --- $json");
    bestReviewedSectionBanner = json['best_reviewed_section_banner'];
    bestReviewedSectionBannerFullUrl = json['best_reviewed_section_banner_full_url'];
    bestReviewedSectionBannerTypeBanner = json['best_reviewed_section_banner_type_banner'];
    bestReviewedSectionBannerTargetBanner = json['best_reviewed_section_banner_target_banner'];
    newArrivalSectionBanner = json['new_arrival_section_banner'];
    newArrivalSectionBannerFullUrl = json['new_arrival_section_banner_full_url'];
    newArrivalSectionBannerTypeBanner = json['new_arrival_section_banner_type_banner'];
    newArrivalSectionBannerTargetBanner = json['new_arrival_section_banner_target_banner'];
    bottomSectionBanner = json['bottom_section_banner'];
    bottomSectionBannerFullUrl = json['bottom_section_banner_full_url'];
    bottomSectionBannerTypeBanner = json['bottom_section_banner_type_banner'];
    bottomSectionBannerTargetBanner = json['bottom_section_banner_target_banner'];
    newArrivalBanner = json['new_arrival_banner'];
    newArrivalBannerFullUrl = json['new_arrival_banner_full_url'];
    newArrivalBannerTypeBanner = json['new_arrival_banner_type_banner'];
    newArrivalBannerTargetBanner = json['new_arrival_banner_target_banner'];
    trendingBanner = json['trending_banner'];
    trendingBannerFullUrl = json['trending_banner_full_url'];
    trendingBannerTypeBanner = json['trending_banner_type_banner'];
    trendingBannerTargetBanner = json['trending_banner_target_banner'];
    weekEndBanner = json['week_end_banner'];
    weekEndBannerFullUrl = json['week_end_banner_full_url'];
    weekEndBannerTypeBanner = json['week_end_banner_type_banner'];
    weekEndBannerTargetBanner = json['week_end_banner_target_banner'];
    brandsBanner = json['brands_banner'];
    brandsBannerFullUrl = json['brands_banner_full_url'];
    brandsBannerTypeBanner = json['brands_banner_type_banner'];
    brandsBannerTargetBanner = json['brands_banner_target_banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['best_reviewed_section_banner'] = bestReviewedSectionBanner;
    data['best_reviewed_section_banner_full_url'] = bestReviewedSectionBannerFullUrl;
    data['best_reviewed_section_banner_type_banner'] = bestReviewedSectionBannerTypeBanner;
    data['best_reviewed_section_banner_target_banner'] = bestReviewedSectionBannerTargetBanner;
    data['new_arrival_section_banner'] = newArrivalSectionBanner;
    data['new_arrival_section_banner_full_url'] = newArrivalSectionBannerFullUrl;
    data['new_arrival_section_banner_type_banner'] = newArrivalSectionBannerTypeBanner;
    data['new_arrival_section_banner_target_banner'] = newArrivalSectionBannerTargetBanner;
    data['bottom_section_banner'] = bottomSectionBanner;
    data['bottom_section_banner_full_url'] = bottomSectionBannerFullUrl;
    data['bottom_section_banner_type_banner'] = bottomSectionBannerTypeBanner;
    data['bottom_section_banner_target_banner'] = bottomSectionBannerTargetBanner;
    data['new_arrival_banner'] = newArrivalBanner;
    data['new_arrival_banner_full_url'] = newArrivalBannerFullUrl;
    data['new_arrival_banner_type_banner'] = newArrivalBannerTypeBanner;
    data['new_arrival_banner_target_banner'] = newArrivalBannerTargetBanner;
    data['trending_banner'] = trendingBanner;
    data['trending_banner_full_url'] = trendingBannerFullUrl;
    data['trending_banner_type_banner'] = trendingBannerTypeBanner;
    data['trending_banner_target_banner'] = trendingBannerTargetBanner;
    data['week_end_banner'] = weekEndBanner;
    data['week_end_banner_full_url'] = weekEndBannerFullUrl;
    data['week_end_banner_type_banner'] = weekEndBannerTypeBanner;
    data['week_end_banner_target_banner'] = weekEndBannerTargetBanner;
    data['brands_banner'] = brandsBanner;
    data['brands_banner_full_url'] = brandsBannerFullUrl;
    data['brands_banner_type_banner'] = brandsBannerTypeBanner;
    data['brands_banner_target_banner'] = brandsBannerTargetBanner;
    return data;
  }
}
