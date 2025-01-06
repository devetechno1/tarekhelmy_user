import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/brands/controllers/brands_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';

class WebBrandsViewWidget extends StatelessWidget {
  const WebBrandsViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BrandsController>(builder: (brandsController) {
      return brandsController.brandList != null ? brandsController.brandList!.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: TitleWidget(
              title: 'brands'.tr,
              onTap: () => Get.toNamed(RouteHelper.getBrandsScreen()),
            ),
          ),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: brandsController.brandList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                    right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: TextHover(
                      builder: (hovered) {
                        return InkWell(
                          onTap: () => Get.toNamed(RouteHelper.getBrandsItemScreen(brandsController.brandList![index].id!, brandsController.brandList![index].name!)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              isHovered: hovered,
                              image: '${brandsController.brandList![index].imageFullUrl}',
                              height: 100, width: 100, fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                );
              },
            ),
          ),

        ]),
      ) : const SizedBox() : const WebBrandViewShimmer();
    });
  }
}

class WebBrandViewShimmer extends StatelessWidget {
  const WebBrandViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
      child: Column(children: [

        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: TitleWidget(
            title: 'brands'.tr,
            onTap: () => null,
          ),
        ),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                  right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Container(
                    height: 100, width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

      ]),
    );
  }
}
