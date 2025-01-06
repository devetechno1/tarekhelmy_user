import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/domain/services/campaign_service_interface.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignServiceInterface campaignServiceInterface;
  CampaignController({required this.campaignServiceInterface});

  List<BasicCampaignModel>? _basicCampaignList;
  List<BasicCampaignModel>? get basicCampaignList => _basicCampaignList;

  BasicCampaignModel? _basicCampaign;
  BasicCampaignModel? get basicCampaign => _basicCampaign;

  List<Item>? _itemCampaignList;
  List<Item>? get itemCampaignList => _itemCampaignList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void itemAndBasicCampaignNull(){
    _itemCampaignList = null;
    _basicCampaignList = null;
  }

  Future<void> getBasicCampaignList(bool reload, {DataSourceEnum dataSource = DataSourceEnum.local, bool fromRecall = false}) async {
    if(_basicCampaignList == null || reload || fromRecall) {
      List<BasicCampaignModel>? basicCampaignList;
      if(dataSource == DataSourceEnum.local) {
        basicCampaignList = await campaignServiceInterface.getBasicCampaignList(DataSourceEnum.local);
        _prepareBasicCampaign(basicCampaignList);
        getBasicCampaignList(false, dataSource: DataSourceEnum.client, fromRecall: true);
      } else {
        basicCampaignList = await campaignServiceInterface.getBasicCampaignList(DataSourceEnum.client);
        _prepareBasicCampaign(basicCampaignList);
      }

    }
  }

  _prepareBasicCampaign(List<BasicCampaignModel>? basicCampaignList) {
    if (basicCampaignList != null) {
      _basicCampaignList = [];
      _basicCampaignList!.addAll(basicCampaignList);
    }
    update();
  }

  Future<void> getBasicCampaignDetails(int? campaignID) async {
    _basicCampaign = null;
    BasicCampaignModel? basicCampaign = await campaignServiceInterface.getCampaignDetails(campaignID.toString());
    if (basicCampaign != null) {
      _basicCampaign = basicCampaign;
    }
    update();
  }

  Future<void> getItemCampaignList(bool reload, {DataSourceEnum dataSource = DataSourceEnum.local, bool fromRecall = false}) async {
    if(_itemCampaignList == null || reload || fromRecall) {
      List<Item>? itemCampaignList;
      if(dataSource == DataSourceEnum.local) {
        itemCampaignList = await campaignServiceInterface.getItemCampaignList(DataSourceEnum.local);
        _prepareItemCampaign(itemCampaignList);
        getItemCampaignList(false, dataSource: DataSourceEnum.client, fromRecall: true);
      } else {
        itemCampaignList = await campaignServiceInterface.getItemCampaignList(DataSourceEnum.client);
        _prepareItemCampaign(itemCampaignList);
      }

    }
  }

  _prepareItemCampaign(List<Item>? itemCampaignList) {
    if (itemCampaignList != null) {
      _itemCampaignList = [];
      List<Item> campaign = [];
      campaign.addAll(itemCampaignList);
      for (var c in campaign) {
        if(!Get.find<SplashController>().getModuleConfig(c.moduleType).newVariation! || c.variations!.isEmpty || c.foodVariations!.isNotEmpty) {
          _itemCampaignList!.add(c);
        }
      }
    }
    update();
  }

}