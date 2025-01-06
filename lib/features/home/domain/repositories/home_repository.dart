import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/home/domain/models/cashback_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'home_repository_interface.dart';

class HomeRepository implements HomeRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  HomeRepository({required this.sharedPreferences, required this.apiClient});

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
  Future getList({int? offset}) async {
    List<CashBackModel>? cashBackModelList;
    Response response = await apiClient.getData(AppConstants.cashBackOfferListUri);
    if(response.statusCode == 200) {
      cashBackModelList = [];
      response.body.forEach((data) {
        cashBackModelList!.add(CashBackModel.fromJson(data));
      });
    }
    return cashBackModelList;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

  @override
  Future<CashBackModel?> getCashBackData(double amount) async {
    //double cashbackAmount = 0;
    CashBackModel? cashBackModel;
    Response response = await apiClient.getData('${AppConstants.getCashBackAmountUri}?amount=$amount');
    if(response.statusCode == 200) {
      //cashbackAmount = response.body['cashback_amount'] != null ? double.parse(response.body['cashback_amount'].toString()) : 0;
      cashBackModel = CashBackModel.fromJson(response.body);
    }
    return cashBackModel;
  }

  @override
  Future<bool> saveRegistrationSuccessful(bool status) async {
    return await sharedPreferences.setBool(AppConstants.dmRegisterSuccess, status);
  }

  @override
  Future<bool> saveIsRestaurantRegistration(bool status) async {
    return await sharedPreferences.setBool(AppConstants.isRestaurantRegister, status);
  }

  @override
  bool getRegistrationSuccessful() {
    return sharedPreferences.getBool(AppConstants.dmRegisterSuccess) ?? false;
  }

  @override
  bool getIsRestaurantRegistration() {
    return sharedPreferences.getBool(AppConstants.isRestaurantRegister) ?? false;
  }

}
