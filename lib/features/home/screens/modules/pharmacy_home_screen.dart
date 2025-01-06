import 'package:flutter/material.dart';
import 'package:sixam_mart/features/home/widgets/bad_weather_widget.dart';
import 'package:sixam_mart/features/home/widgets/highlight_widget.dart';
import 'package:sixam_mart/features/home/widgets/views/product_with_categories_view.dart';
import 'package:sixam_mart/features/home/widgets/views/best_store_nearby_view.dart';
import 'package:sixam_mart/features/home/widgets/views/common_condition_view.dart';
import 'package:sixam_mart/features/home/widgets/views/just_for_you_view.dart';
import 'package:sixam_mart/features/home/widgets/views/middle_section_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/new_on_mart_view.dart';
import 'package:sixam_mart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/top_offers_near_me.dart';
import 'package:sixam_mart/features/home/widgets/views/visit_again_view.dart';
import 'package:sixam_mart/features/home/widgets/banner_view.dart';
import 'package:sixam_mart/features/home/widgets/views/category_view.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

class PharmacyHomeScreen extends StatelessWidget {
  const PharmacyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        child:  const Column(
          children: [
            BadWeatherWidget(),

            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),

      const CategoryView(),
      if (AppConstants.removeStores) ...[
        const ProductWithCategoriesView(),
        const HighlightWidget(),
        const MiddleSectionBannerView(),
        const JustForYouView(),
        const TopOffersNearMe(),
        const CommonConditionView(),
        const PromotionalBannerView(),
      ] else ...[
        if(isLoggedIn) const VisitAgainView(),
        const ProductWithCategoriesView(),
        const HighlightWidget(),
        const MiddleSectionBannerView(),
        const BestStoreNearbyView(),
        const JustForYouView(),
        const TopOffersNearMe(),
        const NewOnMartView(isShop: false, isPharmacy: true, isNewStore: true),
        const CommonConditionView(),
        const PromotionalBannerView(),
      ]
    ]);
  }
}
