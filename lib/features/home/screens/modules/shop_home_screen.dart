import 'package:flutter/material.dart';
import 'package:sixam_mart/features/home/widgets/brands_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/top_offers_near_me.dart';
import 'package:sixam_mart/features/flash_sale/widgets/flash_sale_view_widget.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/featured_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/item_that_you_love_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/most_popular_item_view.dart';
import 'package:sixam_mart/features/home/widgets/views/middle_section_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/special_offer_view.dart';
import 'package:sixam_mart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';

import '../../widgets/views/new_arrival_view.dart';

// import '../../widgets/views/all_offers_view.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            BadWeatherWidget(),
            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),
      const CategoryView(),
      const FlashSaleViewWidget(),
      const MiddleSectionBannerView(),
      const HighlightWidget(),
      const PromotionalBannerView(isNewArrivalSection: true),
      const SpecialOfferView(isFood: false, isShop: true),
      const PromotionalBannerView(newArrivalBanner: true),
      const NewArrivalView(),
      const TopOffersNearMe(),
      const FeaturedCategoriesView(),
      const ItemThatYouLoveView(forShop: true),
      const PromotionalBannerView(isTrending: true),
      const MostPopularItemView(isFood: false, isShop: true), // trending
      const PromotionalBannerView(isWeekEnd: true),
      const JustForYouView(), // weekend offers
      const PromotionalBannerView(isBrands: true),
      const BrandsViewWidget(),
      const PromotionalBannerView(isBottomSection: true),
      const SizedBox(height: 50)
    ]);
  }
}
