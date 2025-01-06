import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/features/business/controllers/business_controller.dart';
import 'package:sixam_mart/features/business/domain/models/package_model.dart';
import 'package:sixam_mart/features/home/controllers/home_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/location/domain/services/location_service_interface.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_data_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/auth/domain/models/store_body_model.dart';
import 'package:sixam_mart/features/auth/domain/services/store_registration_service_interface.dart';
import 'package:sixam_mart/helper/route_helper.dart';

class StoreRegistrationController extends GetxController implements GetxService {
  final StoreRegistrationServiceInterface storeRegistrationServiceInterface;
  final LocationServiceInterface locationServiceInterface;

  StoreRegistrationController({required this.locationServiceInterface, required this.storeRegistrationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double _storeStatus = 0.1;
  double get storeStatus => _storeStatus;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  LatLng? _restaurantLocation;
  LatLng? get restaurantLocation => _restaurantLocation;

  List<int>? _zoneIds;
  List<int>? get zoneIds => _zoneIds;

  int? _selectedZoneIndex = 0;
  int? get selectedZoneIndex => _selectedZoneIndex;

  List<ZoneDataModel>? _zoneList;
  List<ZoneDataModel>? get zoneList => _zoneList;

  List<ModuleModel>? _moduleList;
  List<ModuleModel>? get moduleList => _moduleList;

  int? _selectedModuleIndex = -1;
  int? get selectedModuleIndex => _selectedModuleIndex;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  String? _storeAddress;
  String? get storeAddress => _storeAddress;

  String _storeMinTime = '--';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  bool _inZone = false;
  bool get inZone => _inZone;

  int _businessIndex = 0;
  int get businessIndex => _businessIndex;

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  String _businessPlanStatus = 'business';
  String get businessPlanStatus => _businessPlanStatus;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  Future<void> setZoneIndex(int? index, {bool canUpdate = true}) async {
    _selectedZoneIndex = index;
    _moduleList = null;
    _selectedModuleIndex = -1;
    update();
    if(canUpdate){
      await getModules(zoneList![selectedZoneIndex!].id);
      update();
    }
  }

  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void storeStatusChange(double value, {bool isUpdate = true}){
    _storeStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void selectModuleIndex(int? index, {canUpdate = true}) {
    _selectedModuleIndex = index;
    if(canUpdate) {
      update();
    }
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}) {
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))) {
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }

  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = -1;
    _restaurantLocation = null;
    _zoneIds = null;
    List<ZoneDataModel>? zones = await storeRegistrationServiceInterface.getZoneList();
    if (zones != null) {
      _zoneList = [];
      _zoneList!.addAll(zones);
      setLocation(LatLng(
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
      ), forStoreRegistration: true, zoneId: _zoneList![0].id);
      await getModules(_zoneList![0].id);
    }
    update();
  }

  void setLocation(LatLng location, {bool forStoreRegistration = false, int? zoneId}) async {
    // ZoneResponseModel response = await Get.find<LocationController>().getZone(
    //   location.latitude.toString(), location.longitude.toString(), false, handleError: true,
    // );
    ZoneResponseModel response = await locationServiceInterface.getZone(location.latitude.toString(), location.longitude.toString(), handleError: true);

    if(zoneId != null) {
      _inZone = await storeRegistrationServiceInterface.checkInZone(location.latitude.toString(), location.longitude.toString(), zoneId);
    }

    _storeAddress = await Get.find<LocationController>().getAddressFromGeocode(LatLng(location.latitude, location.longitude));
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      _restaurantLocation = location;
      _zoneIds = response.zoneIds;
      // _selectedZoneIndex = storeRegistrationServiceInterface.prepareSelectedZoneIndex(_zoneIds, _zoneList);
      for(int index=0; index<zoneList!.length; index++) {
        if(zoneIds!.contains(zoneList![index].id)) {
          if(!forStoreRegistration) {
            _selectedZoneIndex = index;
          }
          break;
        }
      }
    }else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }

  Future<void> getModules(int? zoneId) async {
    List<ModuleModel>? modules = await storeRegistrationServiceInterface.getModules(zoneId);
    if (modules != null) {
      _moduleList = [];
      _moduleList!.addAll(modules);
    }
    update();
  }

  void resetStoreRegistration(){
    _pickedLogo = null;
    _pickedCover = null;
    _selectedModuleIndex = -1;
    _selectedModuleIndex = -1;
    _storeMinTime = '--';
    _storeMaxTime = '--';
    _storeTimeUnit = 'minute';
    update();
  }

  Future<void> registerStore(StoreBodyModel storeBody) async {
    _isLoading = true;
    update();
    Response? response = await storeRegistrationServiceInterface.registerStore(storeBody, _pickedLogo, _pickedCover);
    if(response.statusCode == 200) {
      Get.find<HomeController>().saveRegistrationSuccessfulSharedPref(true);
      int? storeId = response.body['store_id'];
      int? packageId = response.body['package_id'];
      if(packageId == null) {
        Get.find<BusinessController>().submitBusinessPlan(storeId: storeId!, packageId: null);
      } else {
        Get.toNamed(RouteHelper.getSubscriptionPaymentRoute(
          storeId: storeId,
          packageId: packageId,
        ));
      }
      // Get.offAllNamed(RouteHelper.getBusinessPlanRoute(storeId, packageId));
    }
    _isLoading = false;
    update();
  }

  void resetBusiness(){
    _businessIndex = Get.find<SplashController>().configModel!.commissionBusinessModel == 0 ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    // _isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus??false ? 1 : 0;
  }

  Future<void> getPackageList({bool isUpdate = true}) async {
    _packageModel = await storeRegistrationServiceInterface.getPackageList();
    if(isUpdate) {
      update();
    }
  }

  void changeDigitalPaymentName(String? name, {bool canUpdate = true}){
    _digitalPaymentName = name;
    if(canUpdate) {
      update();
    }
  }

  void setPaymentIndex(int index){
    _paymentIndex = index;
    update();
  }

  void setBusiness(int business){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    update();
  }

  void setBusinessStatus(String status){
    _businessPlanStatus = status;
    update();
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

}