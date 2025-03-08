import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:sixam_mart/features/brands/controllers/brands_controller.dart';
import 'package:sixam_mart/features/brands/widgets/brands_view_shimmer_widget.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';

class BrandsViewWidget extends StatelessWidget {
  const BrandsViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BrandsController>(builder: (brandsController) {
      return brandsController.brandList != null ? brandsController.brandList!.isNotEmpty ? Column(children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: TitleWidget(
            title: 'shop_by_brands'.tr,
            onTap: () => Get.toNamed(RouteHelper.getBrandsScreen()),
          ),
        ),

        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: brandsController.brandList?.length??0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getBrandsItemScreen(brandsController.brandList![index].id!, brandsController.brandList![index].name!)),
                  borderRadius: BorderRadius.circular(200),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      shape: BoxShape.circle,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CustomImage(
                        image: '${brandsController.brandList![index].imageFullUrl}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ),
              );
            },
          ),
        ),

      ]) : const SizedBox() : const BrandViewShimmer();
    });
  }
}
