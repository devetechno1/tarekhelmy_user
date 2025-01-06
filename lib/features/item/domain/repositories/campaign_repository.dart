import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/item/domain/repositories/campaign_repository_interface.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CampaignRepository implements CampaignRepositoryInterface {
  final ApiClient apiClient;
  CampaignRepository({required this.apiClient});

  @override
  Future getList({int? offset, bool isBasicCampaign = false, bool isItemCampaign = false, DataSourceEnum source = DataSourceEnum.client}) async {
    if(isBasicCampaign) {
      return await _getBasicCampaignList(source);
    } else if(isItemCampaign) {
      return await _getItemCampaignList(source);
    }
  }

  Future<List<BasicCampaignModel>?> _getBasicCampaignList(DataSourceEnum source) async {
    List<BasicCampaignModel>? basicCampaignList;
    String cacheId = '${AppConstants.basicCampaignUri}-banner-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.basicCampaignUri);
        if (response.statusCode == 200) {
          basicCampaignList = [];
          response.body.forEach((campaign) => basicCampaignList!.add(BasicCampaignModel.fromJson(campaign)));
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          basicCampaignList = [];
          jsonDecode(cacheResponseData).forEach((campaign) => basicCampaignList!.add(BasicCampaignModel.fromJson(campaign)));
        }
    }

    return basicCampaignList;
  }

  Future<List<Item>?> _getItemCampaignList(DataSourceEnum source) async {
    List<Item>? itemCampaignList;
    String cacheId = '${AppConstants.basicCampaignUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.itemCampaignUri);
        if (response.statusCode == 200) {
          itemCampaignList = [];
          response.body.forEach((camp) => itemCampaignList!.add(Item.fromJson(camp)));
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          itemCampaignList = [];
          jsonDecode(cacheResponseData).forEach((camp) => itemCampaignList!.add(Item.fromJson(camp)));
        }
    }

    return itemCampaignList;
  }

  @override
  Future<BasicCampaignModel?> get(String? id) async {
    BasicCampaignModel? basicCampaign;
    Response response = await apiClient.getData('${AppConstants.basicCampaignDetailsUri}$id');
    if (response.statusCode == 200) {
      basicCampaign = BasicCampaignModel.fromJson(response.body);
    }
    return basicCampaign;
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
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}