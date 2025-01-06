
class ParcelOtherBannerModel {
  String? promotionalBannerUrl;
  String? promotionalBanners3Url;
  List<Banners>? banners;

  ParcelOtherBannerModel({
    this.promotionalBannerUrl,
    this.promotionalBanners3Url,
    this.banners,
  });

  ParcelOtherBannerModel.fromJson(Map<String, dynamic> json) {
    promotionalBannerUrl = json['promotional_banner_url'];
    promotionalBanners3Url = json['promotional_banner_s3_url'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotional_banner_url'] = promotionalBannerUrl;
    data['promotional_banner_s3_url'] = promotionalBanners3Url;
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  int? id;
  int? moduleId;
  String? key;
  String? imageFullUrl;
  String? type;
  int? status;
  String? createdAt;
  String? updatedAt;

  Banners({
    this.id,
    this.moduleId,
    this.key,
    this.imageFullUrl,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];
    key = json['key'];
    imageFullUrl = json['value_full_url'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_id'] = moduleId;
    data['key'] = key;
    data['value_full_url'] = imageFullUrl;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
