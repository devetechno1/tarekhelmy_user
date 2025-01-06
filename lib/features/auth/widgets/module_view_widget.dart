import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';
import 'package:sixam_mart/util/styles.dart';

class ModuleViewWidget extends StatelessWidget {
  const ModuleViewWidget({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<StoreRegistrationController>(builder: (storeRegController) {

      List<int> moduleIndexList = [];
      List<DropdownItem<int>> moduleList = [];
      if(storeRegController.moduleList != null && storeRegController.moduleList!.isNotEmpty) {
        for(int index=0; index < storeRegController.moduleList!.length; index++) {
          if(storeRegController.moduleList![index].moduleType != 'parcel') {
            moduleIndexList.add(index);
            moduleList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${storeRegController.moduleList![index].moduleName}'),
              ),
            )));
          }
        }
      }

      return storeRegController.moduleList != null ? Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).disabledColor, width: 0.3),
          ),
          child: CustomDropdown<int>(
            onChange: (int? value, int index) {
              storeRegController.selectModuleIndex(value);
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
            items: moduleList,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('select_module_type'.tr),
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
            child: Text('select_module'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: isDesktop ? Dimensions.fontSizeExtraSmall : Dimensions.fontSizeDefault)),
          ),
        ),

      ]) : Center(child: Text('not_available_module'.tr));

    });
  }
}
