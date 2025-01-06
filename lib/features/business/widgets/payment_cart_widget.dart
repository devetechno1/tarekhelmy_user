import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/business/controllers/business_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class PaymentCartWidget extends StatelessWidget {
  final String title;
  final int index;
  final Function onTap;
  const PaymentCartWidget({super.key, required this.title, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return Stack( clipBehavior: Clip.none, children: [

        InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: businessController.paymentIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 1) : null,
              boxShadow: businessController.paymentIndex != index ? [BoxShadow(color: Colors.grey[300]!, blurRadius: 10)] : null,
              color: businessController.paymentIndex == index ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
            ),
            alignment: Alignment.centerLeft,
            width: context.width,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Row(children: [
              Text(title, style: robotoBold.copyWith(color: businessController.paymentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color)),
              const Spacer(),

              (ResponsiveHelper.isDesktop(context) && businessController.paymentIndex == index) ? Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor),
              ) : const SizedBox(),
            ]),
          ),
        ),

        (ResponsiveHelper.isMobile(context) && businessController.paymentIndex == index)  ? Positioned(
          top: -8, right: -8,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor),
          ),
        ) : const SizedBox(),

      ]);
    });
  }
}
