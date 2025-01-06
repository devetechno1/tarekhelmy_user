import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/checkout/widgets/slot_widget.dart';

class TimeSlotBottomSheet extends StatefulWidget {
  final bool tomorrowClosed;
  final bool todayClosed;
  final Module? module;
  const TimeSlotBottomSheet({super.key, required this.tomorrowClosed, required this.todayClosed, required this.module});

  @override
  State<TimeSlotBottomSheet> createState() => _TimeSlotBottomSheetState();
}

class _TimeSlotBottomSheetState extends State<TimeSlotBottomSheet> {

  int selectedTimeSlotIndex = 0;
  String selectedTimeSlot = '';

  @override
  void initState() {
    super.initState();
    selectedTimeSlotIndex = Get.find<CheckoutController>().selectedTimeSlot;
    selectedTimeSlot = Get.find<CheckoutController>().preferableTime;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(builder: (checkoutController) {
      return GetBuilder<StoreController>(builder: (storeController) {
        return Container(
          width: ResponsiveHelper.isDesktop(context) ? 550 : context.width,
          constraints: BoxConstraints(maxHeight: context.height * 0.8, minHeight: 0),
          margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: ResponsiveHelper.isMobile(context) ?
              const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
              : const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                !ResponsiveHelper.isDesktop(context) ? InkWell(
                  onTap: ()=> Get.back(),
                  child: Container(
                    height: 4, width: 35,
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
                  ),
                ) : const SizedBox(),

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [

                      Row(children: [
                        Expanded(
                          child: tabView(context:context, title: 'today'.tr, isSelected: checkoutController.selectedDateSlot == 0, onTap: (){
                            checkoutController.updateDateSlot(0, Get.find<StoreController>().store!.orderPlaceToScheduleInterval);
                          }),
                        ),

                        Expanded(
                          child: tabView(context:context, title: 'tomorrow'.tr, isSelected: checkoutController.selectedDateSlot == 1, onTap: (){
                            checkoutController.updateDateSlot(1, Get.find<StoreController>().store!.orderPlaceToScheduleInterval);
                          }),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Flexible(
                        child: ((checkoutController.selectedDateSlot == 0 && widget.todayClosed) || (checkoutController.selectedDateSlot == 1 && widget.tomorrowClosed))
                            ? Center(child: Text(widget.module!.showRestaurantText! ? 'restaurant_is_closed'.tr : 'store_is_closed'.tr))
                            : checkoutController.timeSlots != null
                            ? checkoutController.timeSlots!.isNotEmpty ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: Dimensions.paddingSizeSmall,
                              crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isMobile(context) ? 2.5 : 3,
                            ),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 2),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: checkoutController.timeSlots!.length,
                            itemBuilder: (context, index){
                              String time = (index == 0 && checkoutController.selectedDateSlot == 0
                                  && storeController.isStoreOpenNow(storeController.store!.active!, storeController.store!.schedules)
                                  && (Get.find<SplashController>().configModel!.moduleConfig!.module!.orderPlaceToScheduleInterval! ? storeController.store!.orderPlaceToScheduleInterval == 0 : true))
                                  ? 'instance'.tr : '${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].startTime!)} '
                                  '- ${DateConverter.dateToTimeOnly(checkoutController.timeSlots![index].endTime!)}';
                              return SlotWidget(
                                title: time,
                                isSelected: selectedTimeSlotIndex == index,
                                onTap: () {
                                  setState(() {
                                    selectedTimeSlotIndex = index;
                                    selectedTimeSlot = time;
                                  });
                                },
                              );
                            }) : Center(child: Text('no_slot_available'.tr)) : const Center(child: CircularProgressIndicator()),
                      ),

                    ]),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Expanded(
                    child: CustomButton(
                      radius: ResponsiveHelper.isDesktop(context) ?  Dimensions.radiusSmall : Dimensions.radiusDefault,
                      height: ResponsiveHelper.isDesktop(context) ? 50 : null,
                      isBold:  ResponsiveHelper.isDesktop(context) ? false : true,
                      buttonText: 'cancel'.tr,
                      color: Theme.of(context).disabledColor,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: CustomButton(
                      radius: ResponsiveHelper.isDesktop(context) ?  Dimensions.radiusSmall : Dimensions.radiusDefault,
                      height: ResponsiveHelper.isDesktop(context) ? 50 : null,
                      isBold:  ResponsiveHelper.isDesktop(context) ? false : true,
                      buttonText: 'schedule'.tr,
                      onPressed: () {
                        checkoutController.updateTimeSlot(selectedTimeSlotIndex);
                        checkoutController.setPreferenceTimeForView(selectedTimeSlot);
                        Get.back();
                      },
                    ),
                  ),
                ]),
              )],
            ),
          ),
        );
      });
    });
  }

  Widget tabView({required BuildContext context, required String title, required bool isSelected, required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: isSelected ? robotoBold.copyWith(color: Theme.of(context).primaryColor) : robotoMedium),
          ResponsiveHelper.isDesktop(context) ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
          Divider(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, thickness: isSelected ? 2 : 1),
        ],
      ),
    );
  }

}
