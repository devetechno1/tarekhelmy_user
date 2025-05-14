import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';

import '../../../../util/app_constants.dart';
import '../../../../util/images.dart';

class SiginWithApple extends StatelessWidget {
  const SiginWithApple({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height:Dimensions.paddingSizeSmall),
        Text(
          'login_with'.tr,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.grey),
        ),
        const SizedBox(
          height: Dimensions.paddingSizeSmall,
        ),
        if(AppConstants.useLoginWithApple&& !(kIsWeb || Platform.isAndroid))
        GestureDetector(
          onTap: () async {         
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.appleLogo),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  child: Text(
                    'sign_in_with_apple'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
