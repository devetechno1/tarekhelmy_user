import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/brands/controllers/brands_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {

  @override
  void initState() {
    Get.find<BrandsController>().getBrandList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'all_brands'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<BrandsController>(builder: (brandsController) {
        return SingleChildScrollView(
          child: FooterView(
            child: Column(children: [

              WebScreenTitleWidget(title: 'all_brands'.tr),

              SizedBox(
                width: Dimensions.webMaxWidth,
                child: brandsController.brandList != null ? brandsController.brandList!.isNotEmpty ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 0 : Dimensions.paddingSizeExtraLarge,
                    vertical: Dimensions.paddingSizeExtraLarge,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : 2,
                    crossAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisExtent: isDesktop ? 120 : 95,
                  ),
                  itemCount: brandsController.brandList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Get.toNamed(RouteHelper.getBrandsItemScreen(brandsController.brandList![index].id!, brandsController.brandList![index].name!)),
                      child: Row(children: [

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              image: '${brandsController.brandList![index].imageFullUrl}',
                              height: isDesktop ? 100 : 80, width: isDesktop ? 100 : 80,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Flexible(
                          child: Text(brandsController.brandList![index].name ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.7))),
                        ),

                      ]),
                    );
                  },
                ) : Center(child: Padding(padding: EdgeInsets.only(top: isDesktop ? context.height * 0.3 : context.height * 0.4), child: Text('no_brands_found'.tr)))
                    : Center(child: Padding(padding: EdgeInsets.only(top: isDesktop ? context.height * 0.3 : context.height * 0.4), child: const CircularProgressIndicator())),
              ),

            ]),
          ),
        );
      }),
    );
  }
}
