import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:drift/drift.dart' as drift;
import 'package:sixam_mart/helper/db_helper.dart';
import 'package:sixam_mart/local/cache_response.dart';

class LocalClient {

  static Future<String?> organize(DataSourceEnum source, String cacheId, String? responseBody, Map<String, String>? header) async {
    SharedPreferences sharedPreferences = Get.find();
    switch(source) {
      case DataSourceEnum.client:
        try{
          print('==========cache data : endpoint banner=${cacheId}, '
              'header= ${header.toString()}, '
              'response= ${responseBody}');

          if(GetPlatform.isWeb) {
            await sharedPreferences.setString(cacheId, responseBody??'');
          } else {
            DbHelper.insertOrUpdate(
              id: cacheId,
              data: CacheResponseCompanion(
                endPoint: drift.Value(cacheId),
                header: drift.Value(header.toString()),
                response: drift.Value(responseBody??''),
              ),
            );
          }
        } catch(e) {
          print('=====error occure in repo api bannaer add: $e');
        }
      case DataSourceEnum.local:
        try {
          if(GetPlatform.isWeb) {
            String? cacheData = sharedPreferences.getString(cacheId);
            return cacheData;
          } else {
            final CacheResponseData? cacheResponseData = await database.getCacheResponseById(cacheId);
            return cacheResponseData?.response;
          }

        } catch (e) {
          print('=====error occur in repo local banner: $e');
        }
    }
    return null;
  }
}