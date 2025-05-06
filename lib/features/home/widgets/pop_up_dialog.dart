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
              IconButton(
                onPressed: Get.back,
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.error,
                ),
                icon: const Icon(Icons.clear),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraLarge,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                child: PromotionalBannerView(
                  isBottomSection: true,
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
