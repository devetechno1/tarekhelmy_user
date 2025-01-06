import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:sixam_mart/features/home/controllers/home_controller.dart';
import 'package:sixam_mart/features/item/controllers/campaign_controller.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/splash/domain/models/landing_model.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/home/screens/home_screen.dart';
import 'package:sixam_mart/features/splash/domain/services/splash_service_interface.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/helper/splash_route_helper.dart';
import 'package:universal_html/html.dart' as html;

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;

  ModuleModel? _module;
  ModuleModel? get module => _module;

  ModuleModel? _cacheModule;
  ModuleModel? get cacheModule => _cacheModule;

  List<ModuleModel>? _moduleList;
  List<ModuleModel>? get moduleList => _moduleList;

  int _moduleIndex = 0;
  int get moduleIndex => _moduleIndex;

  Map<String, dynamic>? _data = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _selectedModuleIndex = 0;
  int get selectedModuleIndex => _selectedModuleIndex;

  LandingModel? _landingModel;
  LandingModel? get landingModel => _landingModel;

  bool _savedCookiesData = false;
  bool get savedCookiesData => _savedCookiesData;

  bool _webSuggestedLocation = false;
  bool get webSuggestedLocation => _webSuggestedLocation;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  bool _showReferBottomSheet = false;
  bool get showReferBottomSheet => _showReferBottomSheet;

  DateTime get currentTime => DateTime.now();

  void selectModuleIndex(int index) {
    _selectedModuleIndex = index;
    update();
  }

  Future<void> getConfigData({NotificationBodyModel? notificationBody, bool loadModuleData = false, bool loadLandingData = false, DataSourceEnum source = DataSourceEnum.local, bool fromMainFunction = false, bool fromDemoReset = false}) async {
    _hasConnection = true;
    _moduleIndex = 0;
    Response response;
    if(source == DataSourceEnum.local && !fromDemoReset) {
      response = await splashServiceInterface.getConfigData(source: DataSourceEnum.local);
      _handleConfigResponse(response, loadModuleData, loadLandingData, fromMainFunction, fromDemoReset, notificationBody);
      getConfigData(loadModuleData: loadModuleData, loadLandingData: loadLandingData, source: DataSourceEnum.client);

    } else {
      response = await splashServiceInterface.getConfigData(source: DataSourceEnum.client);
      _handleConfigResponse(response, loadModuleData, loadLandingData, fromMainFunction, fromDemoReset, notificationBody);
    }

  }

  Future<void> _handleConfigResponse(Response response, bool loadModuleData, bool loadLandingData, bool fromMainFunction, bool fromDemoReset, NotificationBodyModel? notificationBody) async {
    if(response.statusCode == 200) {
      _data = response.body;
      _configModel = ConfigModel.fromJson(response.body);
      if(_configModel!.module != null) {
        setModule(_configModel!.module);
      }else if(GetPlatform.isWeb || (loadModuleData && _module != null)) {
        setModule(GetPlatform.isWeb ? splashServiceInterface.getModule() : _module);
      }
      if(loadLandingData){
        await getLandingPageData();
      }
      if(fromMainFunction) {
        _mainConfigRouting();
      } else if (fromDemoReset) {
        Get.offAllNamed(RouteHelper.getInitialRoute(fromSplash: true));
      } else {
        route(body: notificationBody);
      }
      _onRemoveLoader();
    }else {
      if(response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
    }
    update();
  }

  _mainConfigRouting() async {
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<AuthController>().updateToken();
      if(Get.find<SplashController>().module != null) {
        await Get.find<FavouriteController>().getFavouriteList();
      }
    }
  }

  void _onRemoveLoader() {
    final preloader = html.document.querySelector('.preloader');
    if (preloader != null) {
      preloader.remove();
    }
  }

  Future<void> getLandingPageData({DataSourceEnum source = DataSourceEnum.local}) async {
    LandingModel? landingModel;
    if(source == DataSourceEnum.local) {
      landingModel = await splashServiceInterface.getLandingPageData(source: DataSourceEnum.local);
      _prepareLandingModel(landingModel);
      getLandingPageData(source: DataSourceEnum.client);
    } else {
      landingModel = await splashServiceInterface.getLandingPageData(source: DataSourceEnum.client);
      _prepareLandingModel(landingModel);
    }

  }

  _prepareLandingModel(LandingModel? landingModel) {
    if(landingModel != null) {
      _landingModel = landingModel;
      hoverStates = List<bool>.generate(_landingModel!.availableZoneList!.length, (index) => false);
    }
    update();
  }

  Future<void> initSharedData() async {
    if(!GetPlatform.isWeb) {
      _module = null;
      splashServiceInterface.initSharedData();
    }else {
      _module = await splashServiceInterface.initSharedData();
    }
    _cacheModule = splashServiceInterface.getCacheModule();
    setModule(_module, notify: false);
  }

  void setCacheConfigModule(ModuleModel? cacheModule) {
    _configModel!.moduleConfig!.module = Module.fromJson(_data!['module_config'][cacheModule!.moduleType]);
  }

  bool? showIntro() {
    return splashServiceInterface.showIntro();
  }

  void disableIntro() {
    splashServiceInterface.disableIntro();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  Future<void> setModule(ModuleModel? module, {bool notify = true}) async {
    _module = module;
    splashServiceInterface.setModule(module);
    if(module != null) {
      if(_configModel != null) {
        _configModel!.moduleConfig!.module = Module.fromJson(_data!['module_config'][module.moduleType]);
      }
      await splashServiceInterface.setCacheModule(module);
      if((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) && Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }
    }
    if(AuthHelper.isLoggedIn()) {
      if(Get.find<SplashController>().module != null) {
        Get.find<HomeController>().getCashBackOfferList();
        Get.find<FavouriteController>().getFavouriteList();
      }
    }
    if(notify) {
      update();
    }
  }

  Module getModuleConfig(String? moduleType) {
    Module module = Module.fromJson(_data!['module_config'][moduleType]);
    moduleType == 'food' ? module.newVariation = true : module.newVariation = false;
    return module;
  }

  Future<void> getModules({Map<String, String>? headers, DataSourceEnum dataSource = DataSourceEnum.local}) async {
    _moduleIndex = 0;
    List<ModuleModel>? moduleList;
    if(dataSource == DataSourceEnum.local) {
      moduleList = await splashServiceInterface.getModules(headers: headers, source: DataSourceEnum.local);
      _prepareModuleList(moduleList);
      getModules(headers: headers, dataSource: DataSourceEnum.client);
    } else {
      moduleList = await splashServiceInterface.getModules(headers: headers, source: DataSourceEnum.client);
      _prepareModuleList(moduleList);
    }

  }

  _prepareModuleList(List<ModuleModel>? moduleList) {
    if (moduleList != null) {
      _moduleList = [];
      _moduleList!.addAll(moduleList);
    }
    update();
  }

  Future<void> _showInterestPage() async {
    if(!Get.find<ProfileController>().userInfoModel!.selectedModuleForInterest!.contains(Get.find<SplashController>().module!.id)
        && (Get.find<SplashController>().module!.moduleType == 'food' || Get.find<SplashController>().module!.moduleType == 'grocery' || Get.find<SplashController>().module!.moduleType == 'ecommerce')
    ) {
      await Get.toNamed(RouteHelper.getInterestRoute());
    }
  }

  void switchModule(int index, bool fromPhone) async {
    if(_module == null || _module!.id != _moduleList![index].id) {
      await Get.find<SplashController>().setModule(_moduleList![index]);
      Get.find<CartController>().getCartDataOnline();
      Get.find<ItemController>().clearItemLists();
      Get.find<BannerController>().clearBanner();
      Get.find<CategoryController>().clearCategoryList();
      Get.find<CampaignController>().itemAndBasicCampaignNull();
      Get.find<FlashSaleController>().setEmptyFlashSale(fromModule: true);

      if(AuthHelper.isLoggedIn()) {
        Get.find<HomeController>().getCashBackOfferList();
        await _showInterestPage();
      }
      HomeScreen.loadData(true, fromModule: true);
    }
  }

  int getCacheModule() {
    return splashServiceInterface.getCacheModule()?.id ?? 0;
  }

  void setModuleIndex(int index) {
    _moduleIndex = index;
    update();
  }

  void removeModule() {
    setModule(null);
    Get.find<BannerController>().getFeaturedBanner();
    getModules();
    Get.find<HomeController>().forcefullyNullCashBackOffers();
    if(AuthHelper.isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }
    Get.find<StoreController>().getFeaturedStoreList();
    Get.find<CampaignController>().itemAndBasicCampaignNull();
  }

  void removeCacheModule() {
    splashServiceInterface.setCacheModule(null);
  }

  Future<bool> subscribeMail(String email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await splashServiceInterface.subscribeEmail(email);
    if (responseModel.isSuccess) {
      showCustomSnackBar(responseModel.message, isError: false);
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return responseModel.isSuccess;
  }

  void saveCookiesData(bool data) {
    splashServiceInterface.saveCookiesData(data);
    _savedCookiesData = true;
    update();
  }

  getCookiesData(){
    _savedCookiesData = splashServiceInterface.getSavedCookiesData();
    update();
  }

  void cookiesStatusChange(String? data) {
    splashServiceInterface.cookiesStatusChange(data);
  }

  bool getAcceptCookiesStatus(String data) => splashServiceInterface.getAcceptCookiesStatus(data);


  void saveWebSuggestedLocationStatus(bool data) {
    splashServiceInterface.saveSuggestedLocationStatus(data);
    _webSuggestedLocation = true;
    update();
  }

  void getWebSuggestedLocationStatus(){
    _webSuggestedLocation = splashServiceInterface.getSuggestedLocationStatus();
  }

  void setRefreshing(bool status) {
    _isRefreshing = status;
    update();
  }

  void saveReferBottomSheetStatus(bool data) {
    splashServiceInterface.saveReferBottomSheetStatus(data);
    _showReferBottomSheet = data;
    update();
  }

  void getReferBottomSheetStatus(){
    _showReferBottomSheet = splashServiceInterface.getReferBottomSheetStatus();
  }

  var hoverStates = <bool>[];

  void setHover(int index, bool state) {
    hoverStates[index] = state;
    update();
  }

}