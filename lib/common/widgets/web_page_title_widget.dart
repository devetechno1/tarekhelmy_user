import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../util/dimensions.dart';

class WebScreenTitleWidget extends StatelessWidget {
  final String title;
  final String? image;
  const WebScreenTitleWidget({super.key, required this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Container(
      height: 64,
      color: Theme.of(context).primaryColor.withOpacity(0.10),
      child: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: robotoMedium),
          if(image != null) ...[
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Image.asset(image!, height: 20, width: 20),
          ],
        ],
      )),
    ) : const SizedBox();
  }
}
