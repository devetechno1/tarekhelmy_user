import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/flash_sale/domain/models/flash_sale_model.dart';
import 'package:sixam_mart/features/flash_sale/domain/models/product_flash_sale.dart';
import 'package:sixam_mart/features/flash_sale/domain/repositories/flash_sale_repository_interface.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';

class FlashSaleRepository implements FlashSaleRepositoryInterface {
  final ApiClient apiClient;
  FlashSaleRepository({required this.apiClient});

  @override
  Future<FlashSaleModel?> getFlashSale({required DataSourceEnum source}) async {
    FlashSaleModel? flashSaleModel;
    String cacheId = '${AppConstants.flashSaleUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.flashSaleUri);
        if(response.statusCode == 200) {
          flashSaleModel = FlashSaleModel.fromJson(response.body);
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          flashSaleModel = FlashSaleModel.fromJson(jsonDecode(cacheResponseData));
        }
    }

    return flashSaleModel;
  }

  @override
  Future<ProductFlashSale?> getFlashSaleWithId(int id, int offset) async {
    ProductFlashSale? productFlashSale;
    Response response = await apiClient.getData('${AppConstants.flashSaleProductsUri}?flash_sale_id=$id&offset=$offset&limit=10');
    if(response.statusCode == 200) {
      productFlashSale = ProductFlashSale.fromJson(response.body);
    }
    return productFlashSale;
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
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}
