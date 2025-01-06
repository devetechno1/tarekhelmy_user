class CashBackModel {
  int? id;
  String? title;
  String? customerId;
  String? cashbackType;
  int? sameUserLimit;
  int? totalUsed;
  double? cashbackAmount;
  double? minPurchase;
  double? maxDiscount;
  String? startDate;
  String? endDate;
  bool? status;
  String? createdAt;
  String? updatedAt;
  List<Translations>? translations;

  CashBackModel(
      {this.id,
        this.title,
        this.customerId,
        this.cashbackType,
        this.sameUserLimit,
        this.totalUsed,
        this.cashbackAmount,
        this.minPurchase,
        this.maxDiscount,
        this.startDate,
        this.endDate,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.translations});

  CashBackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    customerId = json['customer_id'];
    cashbackType = json['cashback_type'];
    sameUserLimit = json['same_user_limit'];
    totalUsed = json['total_used'];
    cashbackAmount = json['cashback_amount']?.toDouble();
    minPurchase = json['min_purchase']?.toDouble();
    maxDiscount = json['max_discount']?.toDouble();
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['customer_id'] = customerId;
    data['cashback_type'] = cashbackType;
    data['same_user_limit'] = sameUserLimit;
    data['total_used'] = totalUsed;
    data['cashback_amount'] = cashbackAmount;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Translations(
      {this.id,
        this.translationableType,
        this.translationableId,
        this.locale,
        this.key,
        this.value,
        this.createdAt,
        this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}