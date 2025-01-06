import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/address/domain/services/address_service_interface.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';

class AddressController extends GetxController implements GetxService {
  final AddressServiceInterface addressServiceInterface;

  AddressController({required this.addressServiceInterface});

  List<AddressModel>? _addressList;
  List<AddressModel>? get addressList => _addressList;

  late List<AddressModel> _allAddressList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> addAddress(AddressModel addressModel, bool fromCheckout, int? storeZoneId) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await addressServiceInterface.addAddress(addressModel);
    responseModel = await _processSuccessResponse(responseModel, fromCheckout, storeZoneId);
    _isLoading = false;
    update();
    return responseModel;
  }

  int updateAddressListVariable(AddressModel addressModel){
    int i = 0;
    for (; i < (_addressList?.length ?? 0); i++) {
      if (_addressList![i].id == addressModel.id) {
        _addressList![i] = addressModel;
        break;
      }
    }
    update();
    return i;
  }

  Future<ResponseModel> updateAddress(AddressModel addressModel, int? addressId) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await addressServiceInterface.updateAddress(addressModel, addressId);
    if (responseModel.isSuccess) {
      getAddressList();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    List<AddressModel>? addressList = await addressServiceInterface.getAllAddress();
    if (addressList != null) {
      _addressList = [];
      _allAddressList = [];
      _addressList!.addAll(addressList);
      _allAddressList.addAll(addressList);
    }
    update();
  }

  Future<ResponseModel> deleteUserAddressByID(int? id, int index) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await addressServiceInterface.removeAddressByID(id);
    if(responseModel.isSuccess) {
      _addressList!.removeAt(index);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> _processSuccessResponse(ResponseModel responseModel, bool fromCheckout, int? storeZoneId) async {
    if (responseModel.isSuccess) {
      if(fromCheckout && !responseModel.zoneIds!.contains(storeZoneId)) {
        responseModel = ResponseModel(false, (Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'your_selected_location_is_from_different_zone'.tr : 'your_selected_location_is_from_different_zone_store'.tr));
      }else {
        await getAddressList();
        Get.find<CheckoutController>().setAddressIndex(1);
        responseModel = ResponseModel(true, responseModel.message);
      }
    }
    return responseModel;
  }

}