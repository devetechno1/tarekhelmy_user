import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

import '../../../common/widgets/discount_tag.dart';
import '../../../helper/responsive_helper.dart';
import '../../language/controllers/language_controller.dart';

class ItemImageViewWidget extends StatelessWidget {
  final Item? item;
  final bool isCampaign;
  ItemImageViewWidget({super.key, required this.item, this.isCampaign = false});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    XFile? image;
    if(item?.imageFullUrl != null){
      downloadImage().then((img) => image = img);
    }

    List<String?> imageList = [];
    List<String?> imageListForCampaign = [];

    if(isCampaign){
      imageListForCampaign.add(item!.imageFullUrl);
    }else{
      imageList.add(item!.imageFullUrl);
      imageList.addAll(item!.imagesFullUrl!);
    }

    return GetBuilder<ItemController>(builder: (itemController) {
    
      return Column(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: isCampaign
              ? null
              : () {
                  if (!isCampaign) {
                    Navigator.of(context).pushNamed(
                        RouteHelper.getItemImagesRoute(
                            item!, itemController.imageSliderIndex),
                        arguments: ItemImageViewWidget(item: item));
                  }
                },
          child: Stack(children: [
            SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? 350
                  : MediaQuery.of(context).size.width * 0.7,
              child: PageView.builder(
                controller: _controller,
                itemCount:
                    isCampaign ? imageListForCampaign.length : imageList.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImage(
                      image:
                          '${isCampaign ? imageListForCampaign[index] : imageList[index]}',
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                },
                onPageChanged: (index) {
                  itemController.setImageSliderIndex(index);
                },
              ),
            ),
            DiscountEveryTag(
              verticalPadding: 50,
              textDiscount: item?.toGetFree != null && item?.getFree != null
                  ? 'every_products_come_with_free'
                      .tr
                      .replaceAll("{every}", '${item?.toGetFree}')
                      .replaceAll("{on}", "${item?.getFree}")
                  : null
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: Dimensions.paddingSizeSmall,
              child: Align(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _indicators(context, itemController,
                        isCampaign ? imageListForCampaign : imageList),
                  ),
                ),
              ),
            ),
              if(item?.id != null && item?.imageFullUrl != null && !kIsWeb)
                PositionedDirectional(
                  top: Dimensions.paddingSizeDefault,
                  end: Dimensions.paddingSizeDefault,
                  child: Builder(
                    builder: (context) {
                      final GlobalKey key = GlobalKey();
                      return InkWell(
                        key: key,
                        onTap: () async {
                          final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
                          image ??= await downloadImage();
                      
                          Share.shareXFiles(
                            [image!],
                            text: "${getDescription(item!.name!)}\n${AppConstants.productLink}?id=${item!.id}",
                            subject: AppConstants.appName,
                            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.share, size: 24,color: Theme.of(context).primaryColor),
                        ),
                      );
                    }
                  ) ,
                ),
    
            ]),
          ),
    
      ]);
    });
  }

  Future<XFile?> downloadImage() async{
    final Uri uri = Uri.parse(item!.imageFullUrl!);

    XFile? image;

    final List res = await Future.wait([http.get(uri), getTemporaryDirectory()]);

    final String path = '${res[1].path}/${uri.pathSegments.last}';
    io.File(path).writeAsBytesSync(res[0].bodyBytes);
  
    image = XFile(path);
    return image;
  }

  String  getDescription(String name) {
  if(Get.find<LocalizationController>().isLtr){
    return "Check out $name now!\n\n${'for_more_details_visit_link_below'.tr}";
  }
  return "اكتشف الآن $name\n\n${'for_more_details_visit_link_below'.tr}";
}

  List<Widget> _indicators(BuildContext context, ItemController itemController, List<String?> imageList) {
    List<Widget> indicators = [];
    for (int index = 0; index < imageList.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == itemController.imageSliderIndex ? Theme.of(context).primaryColor : Colors.white,
        borderColor: Colors.white,
        size: 10,
      ));
    }
    return indicators;
  }

}
