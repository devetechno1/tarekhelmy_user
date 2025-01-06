import 'package:sixam_mart/features/home/domain/models/cashback_model.dart';

abstract class HomeServiceInterface {
  Future<List<CashBackModel>> getCashBackOfferList();
  Future<CashBackModel?> getCashBackData(double amount);
  Future<bool> saveRegistrationSuccessful(bool status);
  Future<bool> saveIsRestaurantRegistration(bool status);
  bool getRegistrationSuccessful();
  bool getIsRestaurantRegistration();
}