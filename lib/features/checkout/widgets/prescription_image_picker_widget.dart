import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/features/checkout/widgets/prescription_view_dialog_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/widgets/camera_button_sheet_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class PrescriptionImagePickerWidget extends StatelessWidget {
  final CheckoutController checkoutController;
  final int? storeId;
  final bool isPrescriptionRequired;
  const PrescriptionImagePickerWidget({super.key, required this.checkoutController, this.storeId, required this.isPrescriptionRequired});

  @override
  Widget build(BuildContext context) {
    return storeId == null && Get.find<SplashController>().configModel!.moduleConfig!.module!.orderAttachment! ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row(children: [
        Text('prescription'.tr, style: robotoMedium),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Text(
          '(${'max_size_2_mb'.tr})',
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeExtraSmall,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        CustomToolTip(
          message: 'upload_jpg_png_jpeg_maximum_2_MB'.tr,
          iconColor: Theme.of(context).textTheme.bodyLarge!.color!,
        ),

      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: checkoutController.pickedPrescriptions.length+1,
          itemBuilder: (context, index) {
            XFile? file = index == checkoutController.pickedPrescriptions.length ? null : checkoutController.pickedPrescriptions[index];
            if(index < 5 && index == checkoutController.pickedPrescriptions.length) {
              return InkWell(
                onTap: () {
                  if(ResponsiveHelper.isDesktop(context)){
                    checkoutController.pickPrescriptionImage(isRemove: false, isCamera: false);
                  }else{
                    Get.bottomSheet(const CameraButtonSheetWidget());
                  }
                },
                child: DottedBorder(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1,
                  strokeCap: StrokeCap.butt,
                  dashPattern: const [5, 5],
                  padding: const EdgeInsets.all(0),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(Dimensions.radiusDefault),
                  child: Container(
                    height: 98, width: 98, alignment: Alignment.center, decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                    child:  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.cloud_upload, color: Theme.of(context).disabledColor, size: 32),
                      Text('upload_your_prescription'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,),
                    ]),
                  ),
                ),
              );
            }
            return file != null ? Container(
              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: DottedBorder(
                color: Theme.of(context).primaryColor,
                strokeWidth: 1,
                strokeCap: StrokeCap.butt,
                dashPattern: const [5, 5],
                padding: const EdgeInsets.all(0),
                borderType: BorderType.RRect,
                radius: const Radius.circular(Dimensions.radiusDefault),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(children: [
                    InkWell(
                      onTap: () {
                        Get.dialog(
                          Dialog(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, child: SizedBox(
                            width: 500, child: PrescriptionViewDialogWidget(filePath: file.path),
                          )),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: GetPlatform.isWeb ? Image.network(
                          file.path, width: 98, height: 98, fit: BoxFit.cover,
                        ) : Image.file(
                          File(file.path), width: 98, height: 98, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5, top: 5,
                      child: InkWell(
                        onTap: () => checkoutController.removePrescriptionImage(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ) : const SizedBox();
          },
        ),
      ),

      isPrescriptionRequired ? Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtremeLarge),
        decoration: BoxDecoration(
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).colorScheme.error.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Text(
          'prescription_required_for_this_order_because_you_have_a_item_that_need_prescription'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
        ),
      ) : const SizedBox(height: Dimensions.paddingSizeLarge),

    ]) : const SizedBox();
  }
}
