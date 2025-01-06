import 'package:get/get.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/home/domain/models/advertisement_model.dart';
import 'package:sixam_mart/features/home/domain/services/advertisement_service_interface.dart';

class AdvertisementController extends GetxController implements GetxService {
  final AdvertisementServiceInterface advertisementServiceInterface;
  AdvertisementController({required this.advertisementServiceInterface});

  List<AdvertisementModel>? _advertisementList;
  List<AdvertisementModel>? get advertisementList => _advertisementList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Duration autoPlayDuration = const Duration(seconds: 7);

  bool autoPlay = true;

  Future<void> getAdvertisementList({DataSourceEnum dataSource = DataSourceEnum.local}) async {
    List<AdvertisementModel>? responseAdvertisement;
    if(dataSource == DataSourceEnum.local) {
      responseAdvertisement = await advertisementServiceInterface.getAdvertisementList(dataSource);
      if (responseAdvertisement != null) {
        _advertisementList = responseAdvertisement;
      }
      update();
      getAdvertisementList(dataSource: DataSourceEnum.client);
    } else {
      responseAdvertisement = await advertisementServiceInterface.getAdvertisementList(dataSource);
      if (responseAdvertisement != null) {
        _advertisementList = responseAdvertisement;
      }
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void updateAutoPlayStatus({bool shouldUpdate = false, bool status = false}){
    autoPlay = status;
    if(shouldUpdate){
      update();
    }
  }

}