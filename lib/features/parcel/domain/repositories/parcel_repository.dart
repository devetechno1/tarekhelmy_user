import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_category_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_instruction_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/video_content_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/why_choose_model.dart';
import 'package:sixam_mart/features/parcel/domain/repositories/parcel_repository_interface.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';

class ParcelRepository implements ParcelRepositoryInterface {
  final ApiClient apiClient;
  ParcelRepository({required this.apiClient});

  @override
  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
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
  Future get(String? id, {bool isVideoDetails = true, DataSourceEnum source = DataSourceEnum.client}) async {
    if(isVideoDetails) {
      return await _getVideoContentDetails(source: source);
    } else {
      return await _getWhyChooseDetails(source: source);
    }
  }

  Future<VideoContentModel?> _getVideoContentDetails({required DataSourceEnum source}) async {
    VideoContentModel? videoContentDetails;
    String cacheId = '${AppConstants.videoContentUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.videoContentUri);
        if(response.statusCode == 200) {
          videoContentDetails = VideoContentModel.fromJson(response.body);
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          videoContentDetails = VideoContentModel.fromJson(jsonDecode(cacheResponseData));
        }
    }
    return videoContentDetails;
  }

  Future<WhyChooseModel?> _getWhyChooseDetails({required DataSourceEnum source}) async {
    WhyChooseModel? whyChooseDetails;
    String cacheId = '${AppConstants.whyChooseUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.whyChooseUri);
        if(response.statusCode == 200) {
          whyChooseDetails = WhyChooseModel.fromJson(response.body);
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          whyChooseDetails = WhyChooseModel.fromJson(jsonDecode(cacheResponseData));
        }
    }
    return whyChooseDetails;
  }

  @override
  Future getList({int? offset, bool parcelCategory = true}) async {
    if(parcelCategory) {
     return await _getParcelCategory();
    } else {
      return await _getParcelInstruction(offset!);
    }
  }

  Future<List<ParcelCategoryModel>?> _getParcelCategory() async {
    List<ParcelCategoryModel>? parcelCategoryList;
    Response response = await apiClient.getData(AppConstants.parcelCategoryUri);
    if(response.statusCode == 200) {
      parcelCategoryList = [];
      response.body.forEach((parcel) => parcelCategoryList!.add(ParcelCategoryModel.fromJson(parcel)));
    }
    return parcelCategoryList;
  }

  Future<List<Data>?> _getParcelInstruction(int offset) async {
    List<Data>? parcelInstructionList;
    Response response = await apiClient.getData('${AppConstants.parcelInstructionUri}?limit=10&offset=$offset');
    if(response.statusCode == 200) {
      parcelInstructionList = [];
      parcelInstructionList.addAll(ParcelInstructionModel.fromJson(response.body).data!);
    }
    return parcelInstructionList;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}
