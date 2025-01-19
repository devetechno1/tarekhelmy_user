import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/home/widgets/web/web_basic_medicine_nearby_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/medicine_item_card.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../common/widgets/custom_image.dart';

class ProductWithCategoriesView extends StatelessWidget {
  const ProductWithCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Categories>? categories = [];
      if (itemController.basicMedicineModel != null) {
        for (var category in itemController.basicMedicineModel!.categories!) {
          categories.add(category);
        }
      }
      if (itemController.basicMedicineModel == null) {
        return Column(
          children: List.generate(
            5,
            (index) {
              return const Padding(
                padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: MedicineCardShimmer(makeTitle: true),
              );
            },
          ),
        );
      }
      return itemController.basicMedicineModel!.products!.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeDefault),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      categories.length,
                      (index) {
                        List<Item> products = [];
                        for (Item product
                            in itemController.basicMedicineModel!.products!) {
                          if (categories[index].id ==
                              product.categoryIds?.firstOrNull?.id) {
                            products.add(product);
                          }
                        }
                        return _CategoryData(categories[index], products);
                      },
                    ),
                  ]),
            )
          : const SizedBox();
    });
  }
}

class _CategoryData extends StatelessWidget {
  const _CategoryData(this.category, this.products);
  final Categories category;
  final List<Item> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: Dimensions.paddingSizeDefault,start: Dimensions.paddingSizeSmall),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      bottom: Dimensions.paddingSizeLarge,
                    ),
                    child: Text(
                      category.name ?? '',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(
                    RouteHelper.getCategoryItemRoute(
                        category.id, category.name!),
                  ),
                  child: Text('see_all'.tr),
                )
              ],
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.isDesktop(context) ? 260 : 250,
            width: context.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault),
                  child: MedicineItemCard(item: products[index]),
                );
              },
            ),
          ),
          if(category.bannerFullUrl != null)
            InkWell(
              onTap: ()=> Get.toNamed(
                RouteHelper.getCategoryItemRoute(category.id, category.name!),
              ),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: Container(
                height: 150, width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  child: CustomImage(
                    image: '${category.bannerFullUrl}',
                    fit: BoxFit.cover, height: 140, width: double.infinity,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
