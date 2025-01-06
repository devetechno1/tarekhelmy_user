import 'package:sixam_mart/features/item/domain/models/item_model.dart';

class ReviewModel {
  int? id;
  String? comment;
  int? rating;
  String? itemName;
  String? itemImageFullUrl;
  String? customerName;
  String? createdAt;
  String? updatedAt;
  String? reply;
  Item? item;

  ReviewModel({
    this.id,
    this.comment,
    this.rating,
    this.itemName,
    this.itemImageFullUrl,
    this.customerName,
    this.createdAt,
    this.updatedAt,
    this.reply,
    this.item,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    itemName = json['item_name'];
    itemImageFullUrl = json['item_image_full_url'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reply = json['reply'];
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['rating'] = rating;
    data['item_name'] = itemName;
    data['item_image_full_url'] = itemImageFullUrl;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['reply'] = reply;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    return data;
  }
}
