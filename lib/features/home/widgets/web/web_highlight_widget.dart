import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/features/home/controllers/advertisement_controller.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class WebHighlightWidget extends StatefulWidget {
  const WebHighlightWidget({super.key});

  @override
  State<WebHighlightWidget> createState() => _WebHighlightWidgetState();
}

class _WebHighlightWidgetState extends State<WebHighlightWidget> {

  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(builder: (advertisementController) {
      return advertisementController.advertisementList != null && advertisementController.advertisementList!.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
        child: Stack(
          children: [

            SizedBox(
              height: 400,
              child: CustomAssetImageWidget(
                Get.isDarkMode ? Images.highlightDarkBg : Images.highlightBg, width: context.width,
                fit: BoxFit.cover, height: 280,
              ),
            ),

            Column(children: [

              Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('highlights_for_you'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Get.isDarkMode ? Colors.white : Colors.black)),
                      const SizedBox(width: 5),

                      Text('see_our_most_popular_store_and_item'.tr, style: robotoRegular.copyWith(color: Get.isDarkMode ? Colors.white70 : Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                    ],
                  ),

                  const CustomAssetImageWidget(
                    Images.highlightIcon, height: 50, width: 50,
                  ),

                ]),
              ),

              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: advertisementController.advertisementList!.length,
                options: CarouselOptions(
                  enableInfiniteScroll: advertisementController.advertisementList!.length > 2,
                  scrollPhysics: advertisementController.advertisementList!.length > 2 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                  autoPlay: advertisementController.advertisementList!.length > 2 ? advertisementController.autoPlay : false,
                  enlargeCenterPage: false,
                  height: 280,
                  viewportFraction: advertisementController.advertisementList!.length == 1 ? 1/2 : 1/3,
                  disableCenter: false,
                  initialPage: advertisementController.advertisementList!.length == 2 ? 1 : 0,
                  onPageChanged: (index, reason) {
                    advertisementController.setCurrentIndex(index, true);

                    if(advertisementController.advertisementList?[index].addType == "video_promotion"){
                      advertisementController.updateAutoPlayStatus(status: false);
                    }else{
                      advertisementController.updateAutoPlayStatus(status: true);
                    }

                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return advertisementController.advertisementList?[index].addType == "video_promotion" ? HighlightVideoWidget(
                    advertisement: advertisementController.advertisementList![index],
                  ) : HighlightStoreWidget(advertisement: advertisementController.advertisementList![index]);
                },
              ),

              const AdvertisementIndicator(),

              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            ]),
          ],
        ),
      ) : advertisementController.advertisementList == null ? const AdvertisementShimmer() : const SizedBox();
    });
  }
}
