import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/review/controllers/review_controller.dart';
import 'package:sixam_mart/features/review/widgets/rating_widget.dart';
import 'package:sixam_mart/features/review/widgets/review_list_widget.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReviewScreen extends StatefulWidget {
  final String? storeName;
  final String? storeID;
  final Store? store;
  const ReviewScreen({super.key, required this.storeID, this.storeName, this.store});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ReviewController>().getStoreReviewList(widget.storeID);
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: CustomAppBar(title: widget.storeName ?? 'store_reviews'.tr),
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<ReviewController>(builder: (reviewController) {
        return reviewController.storeReviewList != null ? reviewController.storeReviewList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await reviewController.getStoreReviewList(widget.storeID);
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: Column(children: [

                WebScreenTitleWidget(title: widget.storeName ?? 'store_reviews'.tr),

                Center(child: SizedBox(width: Dimensions.webMaxWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: isDesktop ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Expanded(flex: 4, child: RatingWidget(averageRating: widget.store?.avgRating ?? 0, ratingCount: widget.store?.ratingCount ?? 0, reviewCommentCount: widget.store?.reviewsCommentsCount ?? 0, ratings: widget.store?.ratings)),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          height: 600,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                          ),
                          child: ReviewListWidget(reviewController: reviewController, storeName: widget.storeName),
                        ),
                      ),

                    ]) : Column(children: [

                      RatingWidget(averageRating: widget.store?.avgRating ?? 0, ratingCount: widget.store?.ratingCount ?? 0, reviewCommentCount: widget.store?.reviewsCommentsCount ?? 0, ratings: widget.store?.ratings),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      ReviewListWidget(reviewController: reviewController, storeName: widget.storeName),

                    ]),
                  ),

                )),

              ]),
            ),
          ),
        ) : Center(child: NoDataScreen(text: 'no_review_found'.tr, showFooter: true)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
