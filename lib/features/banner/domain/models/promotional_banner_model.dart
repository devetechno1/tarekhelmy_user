import 'dart:developer';

import 'package:flutter/foundation.dart';

class PromotionalBanner {
  String? bestReviewedSectionBanner;
  String? bestReviewedSectionBannerFullUrl;
  String? bestReviewedSectionBannerTypeBanner;
  int? bestReviewedSectionBannerTargetBanner;
  Map<String,dynamic>? bestReviewedSectionBannerTargetData;
  String? newArrivalSectionBanner;
  String? newArrivalSectionBannerFullUrl;
  String? newArrivalSectionBannerTypeBanner;
  int? newArrivalSectionBannerTargetBanner;
  Map<String,dynamic>? newArrivalSectionBannerTargetData;
  String? bottomSectionBanner;
  String? bottomSectionBannerFullUrl;
  String? bottomSectionBannerTypeBanner;
  int? bottomSectionBannerTargetBanner;
  Map<String,dynamic>? bottomSectionBannerTargetData;
  String? newArrivalBanner;
  String? newArrivalBannerFullUrl;
  String? newArrivalBannerTypeBanner;
  int? newArrivalBannerTargetBanner;
  Map<String,dynamic>? newArrivalBannerTargetData;
  String? trendingBanner;
  String? trendingBannerFullUrl;
  String? trendingBannerTypeBanner;
  int? trendingBannerTargetBanner;
  Map<String,dynamic>? trendingBannerTargetData;
  String? weekEndBanner;
  String? weekEndBannerFullUrl;
  String? weekEndBannerTypeBanner;
  int? weekEndBannerTargetBanner;
  Map<String,dynamic>? weekEndBannerTargetData;
  String? brandsBanner;
  String? brandsBannerFullUrl;
  String? brandsBannerTypeBanner;
  int? brandsBannerTargetBanner;
  Map<String,dynamic>? brandsBannerTargetData;
  String? popupBanner;
  String? popupBannerFullUrl;
  String? popupBannerTypeBanner;
  int? popupBannerTargetBanner;
  Map<String,dynamic>? popupBannerTargetData;

  PromotionalBanner({
    this.bestReviewedSectionBanner,
    this.bestReviewedSectionBannerFullUrl,
    this.bestReviewedSectionBannerTypeBanner,
    this.bestReviewedSectionBannerTargetBanner,
    this.bestReviewedSectionBannerTargetData,
    this.newArrivalSectionBanner,
    this.newArrivalSectionBannerFullUrl,
    this.newArrivalSectionBannerTypeBanner,
    this.newArrivalSectionBannerTargetBanner,
    this.newArrivalSectionBannerTargetData,
    this.bottomSectionBanner,
    this.bottomSectionBannerFullUrl,
    this.bottomSectionBannerTypeBanner,
    this.bottomSectionBannerTargetBanner,
    this.bottomSectionBannerTargetData,
    this.newArrivalBanner,
    this.newArrivalBannerFullUrl,
    this.newArrivalBannerTypeBanner,
    this.newArrivalBannerTargetBanner,
    this.newArrivalBannerTargetData,
    this.trendingBanner,
    this.trendingBannerFullUrl,
    this.trendingBannerTypeBanner,
    this.trendingBannerTargetBanner,
    this.trendingBannerTargetData,
    this.weekEndBanner,
    this.weekEndBannerFullUrl,
    this.weekEndBannerTypeBanner,
    this.weekEndBannerTargetBanner,
    this.weekEndBannerTargetData,
    this.brandsBanner,
    this.brandsBannerFullUrl,
    this.brandsBannerTypeBanner,
    this.brandsBannerTargetBanner,
    this.brandsBannerTargetData,
    this.popupBanner,
    this.popupBannerFullUrl,
    this.popupBannerTypeBanner,
    this.popupBannerTargetBanner,
    this.popupBannerTargetData,
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
    if(kDebugMode) log("banner_type --- $json");
    bestReviewedSectionBanner = json['best_reviewed_section_banner'];
    bestReviewedSectionBannerFullUrl = json['best_reviewed_section_banner_full_url'];
    bestReviewedSectionBannerTypeBanner = json['best_reviewed_section_banner_type_banner'];
    bestReviewedSectionBannerTargetBanner = json['best_reviewed_section_banner_target_banner'];
    bestReviewedSectionBannerTargetData = json['best_reviewed_section_banner_target_data'];
    newArrivalSectionBanner = json['new_arrival_section_banner'];
    newArrivalSectionBannerFullUrl = json['new_arrival_section_banner_full_url'];
    newArrivalSectionBannerTypeBanner = json['new_arrival_section_banner_type_banner'];
    newArrivalSectionBannerTargetBanner = json['new_arrival_section_banner_target_banner'];
    newArrivalSectionBannerTargetData = json['new_arrival_section_banner_target_data'];
    bottomSectionBanner = json['bottom_section_banner'];
    bottomSectionBannerFullUrl = json['bottom_section_banner_full_url'];
    bottomSectionBannerTypeBanner = json['bottom_section_banner_type_banner'];
    bottomSectionBannerTargetBanner = json['bottom_section_banner_target_banner'];
    bottomSectionBannerTargetData = json['bottom_section_banner_target_data'];
    newArrivalBanner = json['new_arrival_banner'];
    newArrivalBannerFullUrl = json['new_arrival_banner_full_url'];
    newArrivalBannerTypeBanner = json['new_arrival_banner_type_banner'];
    newArrivalBannerTargetBanner = json['new_arrival_banner_target_banner'];
    newArrivalBannerTargetData = json['new_arrival_banner_target_data'];
    trendingBanner = json['trending_banner'];
    trendingBannerFullUrl = json['trending_banner_full_url'];
    trendingBannerTypeBanner = json['trending_banner_type_banner'];
    trendingBannerTargetBanner = json['trending_banner_target_banner'];
    trendingBannerTargetData = json['trending_banner_target_data'];
    weekEndBanner = json['week_end_banner'];
    weekEndBannerFullUrl = json['week_end_banner_full_url'];
    weekEndBannerTypeBanner = json['week_end_banner_type_banner'];
    weekEndBannerTargetBanner = json['week_end_banner_target_banner'];
    weekEndBannerTargetData = json['week_end_banner_target_data'];
    brandsBanner = json['brands_banner'];
    brandsBannerFullUrl = json['brands_banner_full_url'];
    brandsBannerTypeBanner = json['brands_banner_type_banner'];
    brandsBannerTargetBanner = json['brands_banner_target_banner'];
    brandsBannerTargetData = json['brands_banner_target_data'];
    popupBanner = json['popup_banner'];
    popupBannerFullUrl = json['popup_banner_full_url'];
    popupBannerTypeBanner = json['popup_banner_type_banner'];
    popupBannerTargetBanner = json['popup_banner_target_banner'];
    popupBannerTargetData = json['popup_banner_target_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['best_reviewed_section_banner'] = bestReviewedSectionBanner;
    data['best_reviewed_section_banner_full_url'] = bestReviewedSectionBannerFullUrl;
    data['best_reviewed_section_banner_type_banner'] = bestReviewedSectionBannerTypeBanner;
    data['best_reviewed_section_banner_target_banner'] = bestReviewedSectionBannerTargetBanner;
    data['best_reviewed_section_banner_target_data'] = bestReviewedSectionBannerTargetData;
    data['new_arrival_section_banner'] = newArrivalSectionBanner;
    data['new_arrival_section_banner_full_url'] = newArrivalSectionBannerFullUrl;
    data['new_arrival_section_banner_type_banner'] = newArrivalSectionBannerTypeBanner;
    data['new_arrival_section_banner_target_banner'] = newArrivalSectionBannerTargetBanner;
    data['new_arrival_section_banner_target_data'] = newArrivalSectionBannerTargetData;
    data['bottom_section_banner'] = bottomSectionBanner;
    data['bottom_section_banner_full_url'] = bottomSectionBannerFullUrl;
    data['bottom_section_banner_type_banner'] = bottomSectionBannerTypeBanner;
    data['bottom_section_banner_target_banner'] = bottomSectionBannerTargetBanner;
    data['bottom_section_banner_target_data'] = bottomSectionBannerTargetData;
    data['new_arrival_banner'] = newArrivalBanner;
    data['new_arrival_banner_full_url'] = newArrivalBannerFullUrl;
    data['new_arrival_banner_type_banner'] = newArrivalBannerTypeBanner;
    data['new_arrival_banner_target_banner'] = newArrivalBannerTargetBanner;
    data['new_arrival_banner_target_data'] = newArrivalBannerTargetData;
    data['trending_banner'] = trendingBanner;
    data['trending_banner_full_url'] = trendingBannerFullUrl;
    data['trending_banner_type_banner'] = trendingBannerTypeBanner;
    data['trending_banner_target_banner'] = trendingBannerTargetBanner;
    data['trending_banner_target_data'] = trendingBannerTargetData;
    data['week_end_banner'] = weekEndBanner;
    data['week_end_banner_full_url'] = weekEndBannerFullUrl;
    data['week_end_banner_type_banner'] = weekEndBannerTypeBanner;
    data['week_end_banner_target_banner'] = weekEndBannerTargetBanner;
    data['week_end_banner_target_data'] = weekEndBannerTargetData;
    data['brands_banner'] = brandsBanner;
    data['brands_banner_full_url'] = brandsBannerFullUrl;
    data['brands_banner_type_banner'] = brandsBannerTypeBanner;
    data['brands_banner_target_banner'] = brandsBannerTargetBanner;
    data['brands_banner_target_data'] = brandsBannerTargetData;
    data['popup_banner'] = popupBanner;
    data['popup_banner_full_url'] = popupBannerFullUrl;
    data['popup_banner_type_banner'] = popupBannerTypeBanner;
    data['popup_banner_target_banner'] = popupBannerTargetBanner;
    data['popup_banner_target_data'] = popupBannerTargetData;
    return data;
  }
}
