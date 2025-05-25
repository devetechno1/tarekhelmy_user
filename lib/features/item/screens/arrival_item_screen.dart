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

class ArrivalItemScreen extends StatefulWidget {
  const ArrivalItemScreen({super.key});

  @override
  State<ArrivalItemScreen> createState() => _ArrivalItemScreenState();
}

class _ArrivalItemScreenState extends State<ArrivalItemScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Get.find<ItemController>().getNewArrivalItemList(true, false, Get.find<ItemController>().discountedType);
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ItemController>(
      builder: (itemController) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(
            key: scaffoldKey,
            title:  'new_arrival'.tr,
            widget: TitleWidget(
              title: 'new_arrival'.tr,
              image: Images.highlightIcon,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            showCart: true,
            type: itemController.newArrivalType,
            onVegFilterTap: (String type) =>itemController.getNewArrivalItemList(true, true, type),
          ),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if(scrollNotification.metrics.pixels >= 0.9 * scrollNotification.metrics.maxScrollExtent && !itemController.isLoadingMore) {
                itemController.getMoreNewArrivalItemList();
              }
              return false;
            },
            child: SingleChildScrollView(
              child: FooterView(child: Column(
                children: [
                  WebScreenTitleWidget(title: 'new_arrival'.tr, image: Images.highlightIcon),
                  SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(
                      children: [
                        ItemsView(isStore: false, stores: null, items: itemController.newArrivalItemList),
                        if(itemController.isLoadingMore)
                          Center(child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                          )),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ),
        );
      }
    );
  }
}
