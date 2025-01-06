class PromotionalBanner {
  String? basicSectionNearbyFullUrl;
  String? bottomSectionBannerFullUrl;

  PromotionalBanner({
    this.basicSectionNearbyFullUrl,
    this.bottomSectionBannerFullUrl,
  });

  bool get isNullClass => basicSectionNearbyFullUrl == null && bottomSectionBannerFullUrl == null;

  PromotionalBanner.fromJson(Map<String, dynamic> json) {
    basicSectionNearbyFullUrl = json['basic_section_nearby_full_url'];
    bottomSectionBannerFullUrl = json['bottom_section_banner_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['basic_section_nearby_full_url'] = basicSectionNearbyFullUrl;
    data['bottom_section_banner_full_url'] = bottomSectionBannerFullUrl;
    return data;
  }
}