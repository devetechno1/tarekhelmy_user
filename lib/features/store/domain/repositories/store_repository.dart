import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/domain/models/cart_suggested_item_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/recommended_product_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_banner_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/store/domain/repositories/store_repository_interface.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/header_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

class StoreRepository implements StoreRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  StoreRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future getList({int? offset, bool isStoreList = false, String? filterBy, bool isPopularStoreList = false, String? type, bool isLatestStoreList = false,
    bool isFeaturedStoreList = false, bool isVisitAgainStoreList = false, bool isStoreRecommendedItemList = false, int? storeId,
    bool isStoreBannerList = false, bool isRecommendedStoreList = false, bool isTopOfferStoreList = false, DataSourceEnum? source}) async {
    if(isStoreList){
      return await _getStoreList(offset!, filterBy!, type!, source: source ?? DataSourceEnum.client);
    }else if(isPopularStoreList){
      return await _getPopularStoreList(type!, source: source ?? DataSourceEnum.client);
    }else if(isLatestStoreList){
      return await _getLatestStoreList(type!, source: source ?? DataSourceEnum.client);
    }else if(isFeaturedStoreList){
      return await _getFeaturedStoreList(source: source ?? DataSourceEnum.client);
    }else if(isVisitAgainStoreList){
      return await _getVisitAgainStoreList(source: source ?? DataSourceEnum.client);
    }else if(isStoreRecommendedItemList){
      return await _getStoreRecommendedItemList(storeId);
    }else if(isStoreBannerList){
      return await _getStoreBannerList(storeId);
    }else if(isRecommendedStoreList){
      return await _getRecommendedStoreList(source: source ?? DataSourceEnum.client);
    }else if(isTopOfferStoreList){
      return await _getTopOfferStoreList(source: source ?? DataSourceEnum.client);
    }
  }

  Future<StoreModel?> _getStoreList(int offset, String filterBy, String storeType, {required DataSourceEnum source}) async {
    StoreModel? storeModel;
    String cacheId = '${AppConstants.storeUri}/$filterBy?store_type=$storeType&offset=$offset&limit=12-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.storeUri}/$filterBy?store_type=$storeType&offset=$offset&limit=12');
        if(response.statusCode == 200){
          storeModel = StoreModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:

        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          storeModel = StoreModel.fromJson(jsonDecode(cacheResponseData));
        }
    }
    return storeModel;
  }

  Future<List<Store>?> _getPopularStoreList(String type, {required DataSourceEnum source}) async {
    List<Store>? popularStoreList;
    String cacheId = '${AppConstants.popularStoreUri}?type=$type}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.popularStoreUri}?type=$type');
        if (response.statusCode == 200) {
          popularStoreList = [];
          response.body['stores'].forEach((store) => popularStoreList!.add(Store.fromJson(store)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body['stores']), apiClient.getHeader());
        }

      case DataSourceEnum.local:

        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          popularStoreList = [];
          jsonDecode(cacheResponseData).forEach((store) => popularStoreList!.add(Store.fromJson(store)));
        }
    }
    return popularStoreList;
  }

  Future<List<Store>?> _getLatestStoreList(String type, {required DataSourceEnum source}) async {
    List<Store>? latestStoreList;
    String cacheId = '${AppConstants.popularStoreUri}?type=$type-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData('${AppConstants.latestStoreUri}?type=$type');
        if (response.statusCode == 200) {
          latestStoreList = [];
          response.body['stores'].forEach((store) => latestStoreList!.add(Store.fromJson(store)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body['stores']), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          latestStoreList = [];
          jsonDecode(cacheResponseData).forEach((store) => latestStoreList!.add(Store.fromJson(store)));
        }
    }

    return latestStoreList;
  }

  Future<List<Store>?> _getTopOfferStoreList({required DataSourceEnum source}) async {
    List<Store>? topOfferStoreList;
    String cacheId = '${AppConstants.topOfferStoreUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.topOfferStoreUri);
        if (response.statusCode == 200) {
          topOfferStoreList = [];
          response.body['stores'].forEach((store) => topOfferStoreList!.add(Store.fromJson(store)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body['stores']), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          topOfferStoreList = [];
          jsonDecode(cacheResponseData).forEach((store) => topOfferStoreList!.add(Store.fromJson(store)));
        }
    }
    return topOfferStoreList;
  }

  Future<List<Store>?> _getFeaturedStoreList({required DataSourceEnum source}) async {
    List<Store>? featuredStoreList;
    String cacheId = '${AppConstants.storeUri}/all?featured=1&offset=1&limit=50-${Get.find<SplashController>().module?.id??''}';
    Map<String, String> header = (Get.find<SplashController>().module == null && Get.find<SplashController>().configModel!.module == null) ? HeaderHelper.featuredHeader() : apiClient.getHeader();

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(
          '${AppConstants.storeUri}/all?featured=1&offset=1&limit=50',
          headers: Get.find<SplashController>().module == null && Get.find<SplashController>().configModel!.module == null ? HeaderHelper.featuredHeader() : null,
        );
        if (response.statusCode == 200) {
          featuredStoreList = [];
          response.body['stores'].forEach((store) => featuredStoreList!.add(Store.fromJson(store)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body['stores']), header);
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          featuredStoreList = [];
          jsonDecode(cacheResponseData).forEach((store) => featuredStoreList!.add(Store.fromJson(store)));
        }
    }
    return featuredStoreList;
  }

  Future<List<Store>?> _getVisitAgainStoreList({required DataSourceEnum source}) async {
    List<Store>? visitAgainStoreList;
    String cacheId = AppConstants.visitAgainStoreUri;

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.visitAgainStoreUri);
        if (response.statusCode == 200) {
          visitAgainStoreList = [];
          response.body.forEach((store) => visitAgainStoreList!.add(Store.fromJson(store)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          visitAgainStoreList = [];
          jsonDecode(cacheResponseData).forEach((store) => visitAgainStoreList!.add(Store.fromJson(store)));
        }
    }
    return visitAgainStoreList;
  }

  @override
  Future<Store?> getStoreDetails(String storeID, bool fromCart, String slug, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId) async {
    Store? store;
    Map<String, String>? header ;
    if(fromCart){
      AddressModel? addressModel = AddressHelper.getUserAddressFromSharedPref();
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
        languageCode, module == null ? cacheModuleId : moduleId,
        addressModel?.latitude, addressModel?.longitude, setHeader: false,
      );
    }
    if(slug.isNotEmpty){
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token), [], [],
        languageCode, 0, '', '', setHeader: false,
      );
    }
    Response response = await apiClient.getData('${AppConstants.storeDetailsUri}${slug.isNotEmpty ? slug : storeID}', headers: header);
    if(response.statusCode == 200){
      store = Store.fromJson(response.body);
    }
    return store;
  }

  @override
  Future<ItemModel?> getStoreItemList(int? storeID, int offset, int? categoryID, String type) async {
    ItemModel? storeItemModel;
    Response response = await apiClient.getData(
      '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=13&type=$type');
    if(response.statusCode == 200){
      storeItemModel = ItemModel.fromJson(response.body);
    }
    return storeItemModel;
  }

  @override
  Future<ItemModel?> getStoreSearchItemList(String searchText, String? storeID, int offset, String type, int? categoryID) async {
    ItemModel? storeSearchItemModel;
    Response response = await apiClient.getData(
      '${AppConstants.searchUri}items/search?store_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type&category_id=${categoryID ?? ''}');
    if(response.statusCode == 200){
      storeSearchItemModel = ItemModel.fromJson(response.body);
    }
    return storeSearchItemModel;
  }

  Future<RecommendedItemModel?> _getStoreRecommendedItemList(int? storeId) async {
    RecommendedItemModel? recommendedItemModel;
    Response response = await apiClient.getData('${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50');
    if(response.statusCode == 200){
      recommendedItemModel = RecommendedItemModel.fromJson(response.body);
    }
    return recommendedItemModel;
  }

  @override
  Future<CartSuggestItemModel?> getCartStoreSuggestedItemList(int? storeId, String languageCode, ModuleModel? module, int? cacheModuleId, int? moduleId) async {
    CartSuggestItemModel? cartSuggestItemModel;
    AddressModel? addressModel = AddressHelper.getUserAddressFromSharedPref();
    Map<String, String> header = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
      languageCode, module == null ? cacheModuleId : moduleId,
      addressModel?.latitude, addressModel?.longitude, setHeader: false,
    );
    Response response = await apiClient.getData('${AppConstants.cartStoreSuggestedItemsUri}?recommended=1&store_id=$storeId&offset=1&limit=50', headers: header);
    if(response.statusCode == 200){
      cartSuggestItemModel = CartSuggestItemModel.fromJson(response.body);
    }
    return cartSuggestItemModel;
  }

  Future<List<StoreBannerModel>?> _getStoreBannerList(int? storeId) async {
    List<StoreBannerModel>? storeBanners;
    Response response = await apiClient.getData('${AppConstants.storeBannersUri}$storeId');
    if (response.statusCode == 200) {
      storeBanners = [];
      response.body.forEach((banner) => storeBanners!.add(StoreBannerModel.fromJson(banner)));
    }
    return storeBanners;
  }

  Future<List<Store>?> _getRecommendedStoreList({required DataSourceEnum source}) async {
    List<Store>? recommendedStoreList;
    String cacheId = '${AppConstants.storeUri}/all?featured=1&offset=1&limit=50-${Get.find<SplashController>().module?.id??''}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.recommendedStoreUri);
        if (response.statusCode == 200) {
          recommendedStoreList = [];
          response.body['stores'].forEach((store) => recommendedStoreList!.add(Store.fromJson(store)));
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body['stores']), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          recommendedStoreList = [];
          jsonDecode(cacheResponseData).forEach((store) => recommendedStoreList!.add(Store.fromJson(store)));
        }
    }

    return recommendedStoreList;
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
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
  
}