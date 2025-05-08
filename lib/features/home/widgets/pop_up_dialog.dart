import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sixam_mart/util/dimensions.dart';

import 'views/promotional_banner_view.dart';

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: Get.back,
                borderRadius: BorderRadius.circular(500),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: const Icon(Icons.clear, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraLarge,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                child: PromotionalBannerView(
                  isPopupDialog: true,
                  aspectRatio: 1,
                  onTap: () {
                    Get.back();
                    Get.back();
                    if (Get.isDialogOpen == true) Get.back();
                    if (Get.isBottomSheetOpen == true) Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
