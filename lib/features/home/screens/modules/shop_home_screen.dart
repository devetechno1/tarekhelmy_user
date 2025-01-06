import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/brands_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/top_offers_near_me.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/features/flash_sale/widgets/flash_sale_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/product_with_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/featured_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/popular_store_view.dart';
import 'package:sixam_mart/features/home/widgets/views/item_that_you_love_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/most_popular_item_view.dart';
import 'package:sixam_mart/features/home/widgets/views/new_on_mart_view.dart';
import 'package:sixam_mart/features/home/widgets/views/middle_section_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/special_offer_view.dart';
import 'package:sixam_mart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/visit_again_view.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';

// import '../../widgets/views/all_offers_view.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              context.theme.primaryColor,
              BlendMode.srcIn,
            ),
            image: const AssetImage(Images.shopModuleBannerBg),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(
          children: [
            BadWeatherWidget(),
            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),
      const CategoryView(),
      // if (AppConstants.showAllAvailableOffersList) const AllOffersView(),
      if (AppConstants.removeStores) ...[
        const MostPopularItemView(isFood: false, isShop: true),
        const FlashSaleViewWidget(),
        const MiddleSectionBannerView(),
        const HighlightWidget(),
        const BrandsViewWidget(),
        const SpecialOfferView(isFood: false, isShop: true),
        const ProductWithCategoriesView(fromShop: true),
        const JustForYouView(),
        const TopOffersNearMe(),
        const FeaturedCategoriesView(),
        const ItemThatYouLoveView(forShop: true),
        const PromotionalBannerView(),
      ] else ...[
        isLoggedIn ? const VisitAgainView() : const SizedBox(),
        const MostPopularItemView(isFood: false, isShop: true),
        const FlashSaleViewWidget(),
        const MiddleSectionBannerView(),
        const HighlightWidget(),
        const PopularStoreView(),
        const BrandsViewWidget(),
        const SpecialOfferView(isFood: false, isShop: true),
        const ProductWithCategoriesView(fromShop: true),
        const JustForYouView(),
        const TopOffersNearMe(),
        const FeaturedCategoriesView(),
        const ItemThatYouLoveView(forShop: true),
        const NewOnMartView(isShop: true, isPharmacy: false),
        const PromotionalBannerView(),
      ]
    ]);
  }
}
