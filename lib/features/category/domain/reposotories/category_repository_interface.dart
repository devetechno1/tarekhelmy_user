import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/interfaces/repository_interface.dart';

abstract class CategoryRepositoryInterface implements RepositoryInterface {
  @override
  Future getList({int? offset, bool categoryList = false, bool subCategoryList = false, bool categoryItemList = false, bool categoryStoreList = false,
    bool? allCategory, String? id, String? type, DataSourceEnum? source});
  Future<dynamic> getSearchData(String? query, String? categoryID, bool isStore, String type);
  Future<dynamic> saveUserInterests(List<int?> interests);
}