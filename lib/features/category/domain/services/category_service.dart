import 'package:get/get.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/category/domain/models/category_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/category/domain/reposotories/category_repository_interface.dart';
import 'package:sixam_mart/features/category/domain/services/category_service_interface.dart';

import '../../../../helper/date_converter.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface categoryRepositoryInterface;
  CategoryService({required this.categoryRepositoryInterface});

  @override
  Future<List<CategoryModel>?> getCategoryList(bool allCategory, {DataSourceEnum? source}) async {
    return await categoryRepositoryInterface.getList(allCategory: allCategory, categoryList: true, source: source);
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID) async {
    return await categoryRepositoryInterface.getList(id: parentID, subCategoryList: true);
  }

  @override
  Future<ItemModel?> getCategoryItemList(String? categoryID, int offset, String type) async {
    return await categoryRepositoryInterface.getList(id: categoryID, offset: offset, type: type, categoryItemList: true);
  }

  @override
  Future<StoreModel?> getCategoryStoreList(String? categoryID, int offset, String type) async {
    return await categoryRepositoryInterface.getList(id: categoryID, offset: offset, type: type, categoryStoreList: true);
  }

  @override
  Future<Response> getSearchData(String? query, String? categoryID, bool isStore, String type) async {
    return await categoryRepositoryInterface.getSearchData(query, categoryID, isStore, type);
  }

  @override
  Future<bool> saveUserInterests(List<int?> interests) async {
    return await categoryRepositoryInterface.saveUserInterests(interests);
  }

  @override
  List<Item>? sortItemSearchList( List<Item>? allItemList, double upperValue, double lowerValue, int rating, bool veg, bool nonVeg, bool isAvailableItems, bool isDiscountedItems, int sortIndex) {
    List<Item>? searchItemList= [];
    searchItemList.addAll(allItemList!);
    if(upperValue > 0) {
      searchItemList.removeWhere((product) => product.price! <= lowerValue || product.price! > upperValue);
    }
    if(rating != -1) {
      searchItemList.removeWhere((product) => product.avgRating! < rating);
    }
    if(!veg && nonVeg) {
      searchItemList.removeWhere((product) => product.veg == 1);
    }
    if(!nonVeg && veg) {
      searchItemList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableItems || isDiscountedItems) {
      if(isAvailableItems) {
        searchItemList.removeWhere((product) => !DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds));
      }
      if(isDiscountedItems) {
        searchItemList.removeWhere((product) => product.discount == 0);
      }
    }
    if(sortIndex != -1) {
      if(sortIndex == 0) {
        searchItemList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchItemList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchItemList.reversed;
        searchItemList = iterable.toList() as List<Item>?;
      }
    }
    return searchItemList;
  }

  @override
  List<Store>? sortStoreSearchList(List<Store>? allStoreList, int storeRating, bool storeVeg, bool storeNonVeg, bool isAvailableStore, bool isDiscountedStore, int storeSortIndex) {
    List<Store>? searchStoreList = [];
    searchStoreList.addAll(allStoreList!);
    if(storeRating != -1) {
      searchStoreList.removeWhere((store) => store.avgRating! < storeRating);
    }
    if(!storeVeg && storeNonVeg) {
      searchStoreList.removeWhere((product) => product.nonVeg == 0);
    }
    if(!storeNonVeg && storeVeg) {
      searchStoreList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableStore || isDiscountedStore) {
      if(isAvailableStore) {
        searchStoreList.removeWhere((store) => store.open == 0 || !store.active!);
      }
      if(isDiscountedStore) {
        searchStoreList.removeWhere((store) => store.discount == null);
      }
    }
    if(storeSortIndex != -1) {
      if(storeSortIndex == 0) {
        searchStoreList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchStoreList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchStoreList.reversed;
        searchStoreList = iterable.toList() as List<Store>?;
      }
    }
    return searchStoreList;
  }

}