import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/category/domain/models/category_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/category/domain/services/category_service_interface.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  List<Item>? _categoryItemList;
  List<Item>? get categoryItemList => _categoryItemList;

  List<Store>? _categoryStoreList;
  List<Store>? get categoryStoreList => _categoryStoreList;

  List<Item>? _searchItemList = [];
  List<Item>? get searchItemList => _searchItemList;

  List<Store>? _searchStoreList = [];
  List<Store>? get searchStoreList => _searchStoreList;

  List<bool>? _interestSelectedList;
  List<bool>? get interestSelectedList => _interestSelectedList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  int? _restPageSize;
  int? get restPageSize => _restPageSize;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int _subCategoryIndex = -1;
  int get subCategoryIndex => _subCategoryIndex;

  String _type = 'all';
  String get type => _type;

  bool _isStore = false;
  bool get isStore => _isStore;

  String? _searchText = '';
  String? get searchText => _searchText;

  int _offset = 1;
  int get offset => _offset;

  void clearCategoryList() {
    _categoryList = null;
  }

  Future<void> getCategoryList(bool reload, {bool allCategory = false, DataSourceEnum dataSource = DataSourceEnum.local, bool fromRecall = false}) async {
    if(_categoryList == null || reload || fromRecall) {
      if(reload) {
        _categoryList = null;
      }
      List<CategoryModel>? categoryList;
      if(dataSource == DataSourceEnum.local) {
        categoryList = await categoryServiceInterface.getCategoryList(allCategory, source: DataSourceEnum.local);
        _prepareCategoryList(categoryList);
        getCategoryList(false, fromRecall: true, allCategory: allCategory, dataSource: DataSourceEnum.client);
      } else {
        categoryList = await categoryServiceInterface.getCategoryList(allCategory, source: DataSourceEnum.client);
        _prepareCategoryList(categoryList);
      }

    }
  }

  _prepareCategoryList(List<CategoryModel>? categoryList) {
    if (categoryList != null) {
      _categoryList = [];
      _interestSelectedList = [];
      _categoryList!.addAll(categoryList);
      for(int i = 0; i < _categoryList!.length; i++) {
        _interestSelectedList!.add(false);
      }
    }
    update();
  }

  void getSubCategoryList(String? categoryID) async {
    _subCategoryIndex = -1;
    _subCategoryList = null;
    _categoryItemList = null;
    List<CategoryModel>? subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
    if (subCategoryList != null) {
      _subCategoryList= [];
      _subCategoryList!.addAll(subCategoryList);
      getCategoryItemList(categoryID, 1, 'all', false);
    }
  }

  void setSubCategoryIndex(int index, String? categoryID) {
    _subCategoryIndex = index;
    if(_isStore) {
      getCategoryStoreList(_subCategoryIndex < 0 ? categoryID : _subCategoryList![index].id.toString(), 1, _type, true);
    }else {
      getCategoryItemList(_subCategoryIndex < 0 ? categoryID : _subCategoryList![index].id.toString(), 1, _type, true);
    }
  }
  String? GetsetSubCategoryIndex(int index) {
    _subCategoryIndex = index;
    return _subCategoryList![index].id?.toString() ;
  }
  void getCategoryItemList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryItemList = null;
    }
    ItemModel? categoryItem = await categoryServiceInterface.getCategoryItemList(categoryID, offset, type);
    if (categoryItem != null) {
      if (offset == 1) {
        _categoryItemList = [];
      }
      _categoryItemList!.addAll(categoryItem.items!);
      _pageSize = categoryItem.totalSize;
      _isLoading = false;
    }
    update();
  }

  void getCategoryStoreList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryStoreList = null;
    }
    StoreModel? categoryStore = await categoryServiceInterface.getCategoryStoreList(categoryID, offset, type);
    if (categoryStore != null) {
      if (offset == 1) {
        _categoryStoreList = [];
      }
      _categoryStoreList!.addAll(categoryStore.stores!);
      _restPageSize = categoryStore.totalSize;
      _isLoading = false;
    }
    update();
  }

  void searchData(String? query, String? categoryID, String type) async {
    if((_isStore && query!.isNotEmpty) || (!_isStore && query!.isNotEmpty /*&& query != _itemResultText*/)) {
      _searchText = query;
      _type = type;
      _isStore ? _searchStoreList = null : _searchItemList = null;
      _isSearching = true;
      update();

      if(query.trim().isEmpty){
        reInitMethod();
        return;
      }

      Response response = await categoryServiceInterface.getSearchData(query, categoryID, _isStore, type);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          _isStore ? _searchStoreList = [] : _searchItemList = [];
        } else {
          if (_isStore) {
            _searchStoreList = [];
            _searchStoreList!.addAll(StoreModel.fromJson(response.body).stores!);
            update();
          } else {
            _searchItemList = [];
            _searchItemList!.addAll(ItemModel.fromJson(response.body).items!);
          }
        }
      }
      update();
    }
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    _searchItemList = [];
    if(_categoryItemList != null) {
      _searchItemList!.addAll(_categoryItemList!);
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<bool> saveInterest(List<int?> interests) async {
    _isLoading = true;
    update();
    bool isSuccess = await categoryServiceInterface.saveUserInterests(interests);
    _isLoading = false;
    update();
    return isSuccess;
  }

  void addInterestSelection(int index) {
    _interestSelectedList![index] = !_interestSelectedList![index];
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isStore = isRestaurant;
    update();
  }


  // search filter



  int _sortIndex = -1;
  int get sortIndex => _sortIndex;

  int _storeSortIndex = -1;
  int get storeSortIndex => _storeSortIndex;
  
  int _rating = -1;
  int get rating => _rating;

  int _storeRating = -1;
  int get storeRating => _storeRating;
  
  bool _isAvailableItems = false;
  bool get isAvailableItems => _isAvailableItems;

  bool _isAvailableStore = false;
  bool get isAvailableStore => _isAvailableStore;
  
  bool _isDiscountedItems = false;
  bool get isDiscountedItems => _isDiscountedItems;

  bool _isDiscountedStore = false;
  bool get isDiscountedStore => _isDiscountedStore;
  
  bool _veg = false;
  bool get veg => _veg;

  bool _storeVeg = false;
  bool get storeVeg => _storeVeg;
  
  bool _nonVeg = false;
  bool get nonVeg => _nonVeg;

  bool _storeNonVeg = false;
  bool get storeNonVeg => _storeNonVeg;
  
  double _lowerValue = 0;
  double get lowerValue => _lowerValue;
  
  double _upperValue = 0;
  double get upperValue => _upperValue;

  final List<String> _sortList = ['ascending'.tr, 'descending'.tr];
  List<String> get sortList => _sortList;

  bool _reInitSearch = false;


  void resetStoreFilter() {
    _storeRating = -1;
    _isAvailableStore = false;
    _isDiscountedStore = false;
    _storeVeg = false;
    _storeNonVeg = false;
    _storeSortIndex = -1;
    update();
  }

  void resetFilter() {
    _reInitSearch = true;
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableItems = false;
    _isDiscountedItems = false;
    _veg = false;
    _nonVeg = false;
    _sortIndex = -1;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void setStoreSortIndex(int index) {
    _storeSortIndex = index;
    update();
  }

  void toggleVeg() {
    _veg = !_veg;
    update();
  }

  void toggleStoreVeg() {
    _storeVeg = !_storeVeg;
    update();
  }

  void toggleNonVeg() {
    _nonVeg = !_nonVeg;
    update();
  }

  void toggleAvailableItems() {
    _isAvailableItems = !_isAvailableItems;
    update();
  }

  void toggleAvailableStore() {
    _isAvailableStore = !_isAvailableStore;
    update();
  }

  void toggleDiscountedItems() {
    _isDiscountedItems = !_isDiscountedItems;
    update();
  }

  void toggleDiscountedStore() {
    _isDiscountedStore = !_isDiscountedStore;
    update();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }
  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setStoreRating(int rate) {
    _storeRating = rate;
    update();
  }
  void toggleStoreNonVeg() {
    _storeNonVeg = !_storeNonVeg;
    update();
  }

  void sortItemSearchList() {
    if(_reInitSearch && _searchText?.trim().isEmpty == true){
      reInitMethod();
    }
    _searchItemList = categoryServiceInterface.sortItemSearchList(_searchItemList, _upperValue, _lowerValue, _rating, _veg, _nonVeg, _isAvailableItems, _isDiscountedItems, _sortIndex);
    update();
  }

  void reInitMethod() {
    _searchItemList = [];
    if(_categoryItemList != null) {
      _searchItemList!.addAll(_categoryItemList!);
    }
    _reInitSearch = false;
  }

  void sortStoreSearchList() {
    _searchStoreList = categoryServiceInterface.sortStoreSearchList(_searchStoreList, _storeRating, _storeVeg, _storeNonVeg, _isAvailableStore, _isDiscountedStore, _storeSortIndex);
    update();
  }
}
