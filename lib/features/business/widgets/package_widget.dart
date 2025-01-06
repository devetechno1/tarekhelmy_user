import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class PackageWidget extends StatelessWidget {
  final String title;
  final bool isSelect;
  const PackageWidget({super.key, required this.title, this.isSelect = false});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(Icons.check_circle, size: 18, color: isSelect ? Theme.of(context).cardColor : Colors.green),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(title.tr, style: robotoRegular.copyWith(fontSize: isDesktop ? Dimensions.fontSizeExtraSmall : Dimensions.fontSizeSmall, color: isSelect ? Theme.of(context).cardColor
          : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7))),

        ]),
      ),

      Divider(indent: 20, endIndent: 50, color: Theme.of(Get.context!).disabledColor.withOpacity(0.5), thickness: 1),

    ]);
  }
}
