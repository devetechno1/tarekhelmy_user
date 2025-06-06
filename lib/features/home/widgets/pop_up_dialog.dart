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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraLarge,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: PromotionalBannerView(
            isPopupDialog: true,
            maxHeight: double.maxFinite,
            aspectRatio: 1,
            onTap: () {
              Get.back();
              Get.back();
              if (Get.isDialogOpen == true) Get.back();
              if (Get.isBottomSheetOpen == true) Get.back();
            },
            overlayChild: Positioned(
              top: 9,
              right: 9,
              child: InkWell(
                onTap: Get.back,
                borderRadius: BorderRadius.circular(500),
                child: Container(
                  padding: const EdgeInsets.all(
                    Dimensions.paddingSizeExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                    ],
                    // color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: const Icon(Icons.clear, color: Colors.black, size: 21),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
