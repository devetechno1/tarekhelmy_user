import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/common_condition_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/item/domain/repositories/item_repository_interface.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';

class ItemRepository implements ItemRepositoryInterface {
  final ApiClient apiClient;
  ItemRepository({required this.apiClient});

  @override
  Future<BasicMedicineModel?> getBasicMedicine(DataSourceEnum source) async {
    BasicMedicineModel? basicMedicineModel;
    String cacheId = '${AppConstants.basicMedicineUri}?offset=1&limit=50-${Get.find<SplashController>().module!.id!}';

    switch(source) {

      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.basicMedicineUri}?offset=1&limit=50');
        if (response.statusCode == 200) {
          basicMedicineModel = BasicMedicineModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          basicMedicineModel = BasicMedicineModel.fromJson(jsonDecode(cacheResponseData));
        }
    }
    return basicMedicineModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id, {bool isConditionWiseItem = false}) async {
    if(isConditionWiseItem) {
      return await _getConditionsWiseItems(int.parse(id!));
    } else {
      return await _getItemDetails(int.parse(id!));
    }
  }

  Future<Item?> _getItemDetails(int? itemID) async {
    Item? item;
    Response response = await apiClient.getData('${AppConstants.itemDetailsUri}$itemID');
    if (response.statusCode == 200) {
      item = Item.fromJson(response.body);
    }
    return item;
  }

  Future<List<Item>?> _getConditionsWiseItems(int id) async {
    List<Item>? conditionWiseProduct;
    Response response = await apiClient.getData('${AppConstants.conditionWiseItemUri}$id?limit=15&offset=1');
    if (response.statusCode == 200) {
      conditionWiseProduct = [];
      conditionWiseProduct.addAll(ItemModel.fromJson(response.body).items!);
    }
    return conditionWiseProduct;
  }

  @override
  Future getList({int? offset, String? type, bool isPopularItem = false, bool isReviewedItem = false, bool isFeaturedCategoryItems = false, bool isRecommendedItems = false, bool isCommonConditions = false, bool isDiscountedItems = false, DataSourceEnum? source}) async {
    if(isPopularItem) {
      return await _getPopularItemList(type!, source: source ?? DataSourceEnum.client);
    } else if(isReviewedItem) {
      return await _getReviewedItemList(type!, source: source ?? DataSourceEnum.client);
    } else if(isFeaturedCategoryItems) {
      return await _getFeaturedCategoriesItemList(source: source ?? DataSourceEnum.client);
    } else if(isRecommendedItems) {
      return await _getRecommendedItemList(type!, source: source ?? DataSourceEnum.client);
    } else if(isCommonConditions) {
      return await _getCommonConditions();
    } else if(isDiscountedItems) {
      return await _getDiscountedItemList(type!, source: source ?? DataSourceEnum.client);
    }
  }

  Future<List<Item>?> _getPopularItemList(String type, {required DataSourceEnum source}) async {
    List<Item>? popularItemList;
    String cacheId = '${AppConstants.popularItemUri}?type=$type-${Get.find<SplashController>().module!.id!}';

    switch(source) {

      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.popularItemUri}?type=$type');
        if (response.statusCode == 200) {
          popularItemList = [];
          popularItemList.addAll(ItemModel.fromJson(response.body).items!);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          popularItemList = [];
          popularItemList.addAll(ItemModel.fromJson(jsonDecode(cacheResponseData)).items!);
        }
    }

    return popularItemList;
  }

  Future<ItemModel?> _getReviewedItemList(String type, {required DataSourceEnum source}) async {
    ItemModel? itemModel;
    String cacheId = '${AppConstants.reviewedItemUri}?type=$type${Get.find<SplashController>().module!.id!}';

    print('======source is: $source');
    switch(source) {

      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.reviewedItemUri}?type=$type');
        if(response.statusCode == 200) {
          itemModel = ItemModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          itemModel = ItemModel.fromJson(jsonDecode(cacheResponseData));
        }
    }

    return itemModel;
  }

  Future<ItemModel?> _getFeaturedCategoriesItemList({required DataSourceEnum source}) async {
    ItemModel? featuredCategoriesItem;
    String cacheId = '${AppConstants.featuredCategoriesItemsUri}?limit=30&offset=1${Get.find<SplashController>().module!.id!}';

    switch(source) {

      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.featuredCategoriesItemsUri}?limit=30&offset=1');
        if (response.statusCode == 200) {
          featuredCategoriesItem = ItemModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          featuredCategoriesItem = ItemModel.fromJson(jsonDecode(cacheResponseData));
        }
    }

    return featuredCategoriesItem;
  }

  Future<List<Item>?> _getRecommendedItemList(String type, {required DataSourceEnum source}) async {
    List<Item>? recommendedItemList;
    String cacheId = '${AppConstants.recommendedItemsUri}$type&limit=30${Get.find<SplashController>().module!.id!}';

    switch(source) {

      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.recommendedItemsUri}$type&limit=30');
        if (response.statusCode == 200) {
          recommendedItemList = [];
          recommendedItemList.addAll(ItemModel.fromJson(response.body).items!);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          recommendedItemList = [];
          recommendedItemList.addAll(ItemModel.fromJson(jsonDecode(cacheResponseData)).items!);
        }
    }

    return recommendedItemList;
  }

  Future<List<CommonConditionModel>?> _getCommonConditions() async {
    List<CommonConditionModel>? commonConditions;
    Response response = await apiClient.getData(AppConstants.commonConditionUri);
    if (response.statusCode == 200) {
      commonConditions = [];
      response.body.forEach((condition) => commonConditions!.add(CommonConditionModel.fromJson(condition)));
    }
    return commonConditions;
  }

  Future<List<Item>?> _getDiscountedItemList(String type, {required DataSourceEnum source}) async {
    List<Item>? discountedItemList;
    String cacheId = '${AppConstants.discountedItemsUri}?type=$type&offset=1&limit=50${Get.find<SplashController>().module!.id!}';

    print('======source is: $source');
    switch(source) {

      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.discountedItemsUri}?type=$type&offset=1&limit=50');
        if (response.statusCode == 200) {
          discountedItemList = [];
          discountedItemList.addAll(ItemModel.fromJson(response.body).items!);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());

        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          discountedItemList = [];
          discountedItemList.addAll(ItemModel.fromJson(jsonDecode(cacheResponseData)).items!);
        }
    }

    return discountedItemList;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}