import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class HeaderHelper {
  static Map<String, String> featuredHeader() {
    SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    }catch(_) {}
    int? moduleID;
    if(GetPlatform.isWeb && sharedPreferences.containsKey(AppConstants.moduleId)) {
      try {
        moduleID = ModuleModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.moduleId)!)).id;
      }catch(_) {}
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.zoneId: addressModel?.zoneIds != null ? jsonEncode(addressModel?.zoneIds) : '',
      moduleID != null ? AppConstants.moduleId: '$moduleID' : '',
      AppConstants.localizationKey: sharedPreferences.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode!,
      AppConstants.latitude: addressModel?.latitude != null ? jsonEncode(addressModel?.latitude) : '',
      AppConstants.longitude: addressModel?.longitude != null ? jsonEncode(addressModel?.longitude) : '',
      // 'Authorization': 'Bearer $token'
    };
  }
}