import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/home/domain/models/advertisement_model.dart';
import 'package:sixam_mart/features/home/domain/repositories/advertisement_repository_interface.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';

class AdvertisementRepository implements AdvertisementRepositoryInterface {
  final ApiClient apiClient;
  AdvertisementRepository({required this.apiClient});

  @override
  Future<List<AdvertisementModel>?> getList({int? offset, DataSourceEnum source = DataSourceEnum.client}) async {
    List<AdvertisementModel>? advertisementList;
    String cacheId = '${AppConstants.advertisementListUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.advertisementListUri);
        if(response.statusCode == 200) {
          advertisementList = [];
          response.body.forEach((data) {
            advertisementList?.add(AdvertisementModel.fromJson(data));
          });
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          advertisementList = [];
          jsonDecode(cacheResponseData).forEach((data) {
            advertisementList?.add(AdvertisementModel.fromJson(data));
          });
        }
    }
    Response response = await apiClient.getData(AppConstants.advertisementListUri);
    if(response.statusCode == 200) {
      advertisementList = [];
      response.body.forEach((data) {
        advertisementList?.add(AdvertisementModel.fromJson(data));
      });
    }
    return advertisementList;
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