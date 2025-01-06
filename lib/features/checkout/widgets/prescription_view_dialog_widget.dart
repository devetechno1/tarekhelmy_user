import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';

class PrescriptionViewDialogWidget extends StatelessWidget {
  final String filePath;
  const PrescriptionViewDialogWidget({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [

      Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: (){
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).hintColor,
              border: Border.all(color: Colors.white, width: 1),
            ),
            padding: const EdgeInsets.all(3),
            child: const Icon(Icons.clear, color: Colors.white),
          ),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Container(
        constraints: BoxConstraints(minHeight: context.height * 0.2, maxHeight: context.height * 0.8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        width: context.width,
        child: GetPlatform.isWeb ? ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Image.network(
            filePath, fit: BoxFit.cover, width: context.width, height: context.height * 0.8,
          ),
        ) : ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Image.file(
            File(filePath), fit: BoxFit.cover, /*width: context.width, height: context.height * 0.8,*/
          ),
        ),
      ),

    ]);
  }
}
