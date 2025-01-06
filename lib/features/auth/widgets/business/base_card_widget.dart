import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BaseCardWidget extends StatelessWidget {
  final StoreRegistrationController storeRegistrationController;
  final String title;
  final String? description;
  final int index;
  final Function onTap;
  const BaseCardWidget({super.key, required this.storeRegistrationController, required this.title, required this.index, required this.onTap, this.description});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return InkWell(
      onTap: onTap as void Function()?,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: storeRegistrationController.businessIndex == index ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
            border: storeRegistrationController.businessIndex == index && isDesktop ? Border.all(color: Theme.of(context).primaryColor) : !isDesktop ? Border.all(color: storeRegistrationController.businessIndex == index ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5), width: 0.5) : null,
            boxShadow: storeRegistrationController.businessIndex == index ? null : [BoxShadow(color: Colors.grey[200]!, offset: const Offset(5, 5), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
          child: Column(crossAxisAlignment : isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center, children: [

            Align(
              alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
              child: Text(title, style: robotoMedium.copyWith(color: storeRegistrationController.businessIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7), fontSize: Dimensions.fontSizeDefault,
                fontWeight: storeRegistrationController.businessIndex == index ? FontWeight.w600 : isDesktop ? FontWeight.w600 : FontWeight.w400,
              )),
            ),

            SizedBox(height: isDesktop ? Dimensions.paddingSizeSmall : 0),

            isDesktop ? Text(
              description ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
            ) : const SizedBox(),

          ]),
        ),

        storeRegistrationController.businessIndex == index ? Positioned(
          top: -10, right: -10,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.check, size: 14, color: Theme.of(context).cardColor),
          ),

        ) : const SizedBox()
      ]),
    );
  }
}