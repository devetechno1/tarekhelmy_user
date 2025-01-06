import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/home/domain/models/advertisement_model.dart';

abstract class AdvertisementServiceInterface {
  Future<List<AdvertisementModel>?> getAdvertisementList(DataSourceEnum source);
}