import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';

import '../../../common/widgets/title_widget.dart';
import '../../../util/images.dart';

class WeekendOfferItemScreen extends StatefulWidget {
  const WeekendOfferItemScreen({super.key});

  @override
  State<WeekendOfferItemScreen> createState() => _WeekendOfferItemScreenState();
}

class _WeekendOfferItemScreenState extends State<WeekendOfferItemScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Get.find<ItemController>().getWeekendOfferItemList(true, false, Get.find<ItemController>().discountedType);
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ItemController>(
      builder: (itemController) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(
            key: scaffoldKey,
            title:  'just_for_you'.tr,
            widget: TitleWidget(
              title: 'just_for_you'.tr,
              image: Images.starFill,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            showCart: true,
            type: itemController.weekendOfferType,
            onVegFilterTap: (String type) =>itemController.getWeekendOfferItemList(true, true, type),
          ),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: FooterView(
            child: SingleChildScrollView(
              child: Column(
            children: [
              WebScreenTitleWidget(title: 'just_for_you'.tr ),
              SizedBox(
                width: Dimensions.webMaxWidth,
                child: ItemsView(isStore: false, stores: null, items: itemController.weekendOfferItemList),
              ),
            ],
          ),
            ),
          ),
        );
      }
    );
  }
}
