import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ZoneSelectionWidget extends StatelessWidget {
  final StoreRegistrationController storeRegController;
  final List<DropdownItem<int>> zoneList;
  final Function() callBack;
  const ZoneSelectionWidget({super.key, required this.storeRegController, required this.zoneList, required this.callBack});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return storeRegController.zoneIds != null ? Stack(clipBehavior: Clip.none, children: [

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).disabledColor, width: 0.3),
        ),
        child: CustomDropdown<int>(
          onChange: (int? value, int index) {
            storeRegController.setZoneIndex(value);
            callBack();
          },
          dropdownButtonStyle: DropdownButtonStyle(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          iconColor: Theme.of(context).disabledColor,
          dropdownStyle: DropdownStyle(
            elevation: 10,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          ),
          items: zoneList,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(storeRegController.selectedZoneIndex == -1 ? 'select_zone'.tr : storeRegController.zoneList![storeRegController.selectedZoneIndex!].name.toString()),
          ),
        ),
      ),

      Positioned(
        left: 10, top: -15,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          padding: const EdgeInsets.all(5),
          child: Text('select_zone'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: isDesktop ? Dimensions.fontSizeExtraSmall : Dimensions.fontSizeDefault)),
        ),
      ),

    ]) : Center(child: Text('service_not_available_in_this_area'.tr));
  }
}