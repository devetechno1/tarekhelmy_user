import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';

import '../../../brands/domain/models/brands_model.dart';
import '../../../category/domain/models/category_model.dart';

class BannerModel {
  List<BasicCampaignModel>? campaigns;
  List<Banner>? banners;

  BannerModel({this.campaigns, this.banners});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['campaigns'] != null) {
      campaigns = [];
      json['campaigns'].forEach((v) {
        campaigns!.add(BasicCampaignModel.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners!.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (campaigns != null) {
      data['campaigns'] = campaigns!.map((v) => v.toJson()).toList();
    }
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  int? id;
  String? title;
  String? type;
  String? imageFullUrl;
  String? link;
  Store? store;
  Item? item;
  BrandModel? brand;
  CategoryModel? category;

  Banner({
    this.id,
    this.title,
    this.type,
    this.imageFullUrl,
    this.link,
    this.store,
    this.item,
  });

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    imageFullUrl = json['image_full_url'];
    link = json['link'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
    brand = json['brand'] != null ? BrandModel.fromJson(json['brand']) : null;
    category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['image_full_url'] = imageFullUrl;
    data['link'] = link;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (item != null) {
      data['item'] = item!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}
