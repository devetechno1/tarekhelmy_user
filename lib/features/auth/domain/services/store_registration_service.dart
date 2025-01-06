import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/business/domain/models/package_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_data_model.dart';
import 'package:sixam_mart/features/auth/domain/models/store_body_model.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/deliveryman_registration_repository_interface.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/store_registration_repository_interface.dart';
import 'package:sixam_mart/features/auth/domain/services/store_registration_service_interface.dart';

class StoreRegistrationService implements StoreRegistrationServiceInterface {
  final StoreRegistrationRepositoryInterface storeRegistrationRepoInterface;
  final DeliverymanRegistrationRepositoryInterface deliverymanRegistrationRepositoryInterface;

  StoreRegistrationService({required this.deliverymanRegistrationRepositoryInterface, required this.storeRegistrationRepoInterface});

  @override
  Future<List<ZoneDataModel>?> getZoneList() async {
    return await deliverymanRegistrationRepositoryInterface.getList();
  }

  @override
  int? prepareSelectedZoneIndex(List<int>? zoneIds, List<ZoneDataModel>? zoneList) {
    int? selectedZoneIndex = 0;
    for(int index=0; index<zoneList!.length; index++) {
      if(zoneIds!.contains(zoneList[index].id)) {
        selectedZoneIndex = index;
        break;
      }
    }
    return selectedZoneIndex;
  }

  @override
  Future<List<ModuleModel>?> getModules(int? zoneId) async {
    return await deliverymanRegistrationRepositoryInterface.getList(isZone: false, zoneId: zoneId);
  }

  @override
  Future<Response> registerStore(StoreBodyModel store, XFile? logo, XFile? cover) async {
    return await storeRegistrationRepoInterface.registerStore(store, logo, cover);
  }

  @override
  Future<bool> checkInZone(String? lat, String? lng, int zoneId) async {
    return await storeRegistrationRepoInterface.checkInZone(lat, lng, zoneId);
  }

  @override
  Future<PackageModel?> getPackageList() async {
    return await storeRegistrationRepoInterface.getList();
  }

}