import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/interfaces/repository_interface.dart';

abstract class OrderRepositoryInterface extends RepositoryInterface {
  @override
  Future get(String? id, {String? guestId});
  @override
  Future getList({int? offset, bool isRunningOrder = false, bool isHistoryOrder = false, bool isCancelReasons = false, bool isRefundReasons = false, bool fromDashboard, bool isSupportReasons = false});
  Future<Response> submitRefundRequest(Map<String, String> body, XFile? data);
  Future<Response> trackOrder(String? orderID, String? guestId, {String? contactNumber});
  Future<bool> cancelOrder(String orderID, String? reason, {String? guestId});
  Future<Response> switchToCOD(String? orderID, {String? guestId});
}