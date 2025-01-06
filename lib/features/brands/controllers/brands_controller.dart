import 'package:get/get.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/brands/domain/models/brands_model.dart';
import 'package:sixam_mart/features/brands/domain/services/brands_service_interface.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';

class BrandsController extends GetxController implements GetxService {
  final BrandsServiceInterface brandsServiceInterface;
  BrandsController({required this.brandsServiceInterface});

  List<BrandModel>? _brandList;
  List<BrandModel>? get brandList => _brandList;

  List<Item>? _brandItems;
  List<Item>? get brandItems => _brandItems;

  int _offset = 1;
  int get offset => _offset;

  int? _pageSize;
  int? get pageSize => _pageSize;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getBrandList({DataSourceEnum dataSource = DataSourceEnum.local}) async {
    List<BrandModel>? brandList;
    if(dataSource == DataSourceEnum.local) {
      brandList = await brandsServiceInterface.getBrandList(DataSourceEnum.local);
      print('=====brand controller cache : $brandList');
      _prepareBandList(brandList);
      getBrandList(dataSource: DataSourceEnum.client);
    } else {
      brandList = await brandsServiceInterface.getBrandList(DataSourceEnum.client);
      print('=====brand controller api : $brandList');
      _prepareBandList(brandList);
    }

  }

  _prepareBandList(List<BrandModel>? brandList) {
    if (brandList != null) {
      _brandList = [];
      _brandList!.addAll(brandList);
    }
    update();
  }

  Future<void> getBrandItemList(int brandId, int offset, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      _brandItems = null;
      if(notify) {
        update();
      }
    }
    ItemModel? brandItemModel = await brandsServiceInterface.getBrandItemList(brandId: brandId, offset: offset);
    if (brandItemModel != null) {
      if (offset == 1) {
        _brandItems = [];
      }
      _brandItems!.addAll(brandItemModel.items!);
      _pageSize = brandItemModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

}