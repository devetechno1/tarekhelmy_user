import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';

class OffersItemScreen extends StatefulWidget {
  const OffersItemScreen({super.key, this.backButton = true});
  final bool backButton;

  @override
  State<OffersItemScreen> createState() => _OffersItemScreenState();
}

class _OffersItemScreenState extends State<OffersItemScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ItemController>().getOffersList(true, Get.find<ItemController>().offersType, false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          backButton: widget.backButton,
          title: 'offers'.tr,
          type: itemController.offersType,
          onVegFilterTap: (String type) => itemController.getOffersList(true, type, true),
        ),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: RefreshIndicator(
          onRefresh: () => itemController.getOffersList(
            true,
            itemController.offersType,
            false,
          ),
          child: ListView(
            children: [
              WebScreenTitleWidget(title: 'offers'.tr),
              SizedBox(
                width: Dimensions.webMaxWidth,
                child: ItemsView(
                  isStore: false,
                  stores: null,
                  items: itemController.offersList,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
