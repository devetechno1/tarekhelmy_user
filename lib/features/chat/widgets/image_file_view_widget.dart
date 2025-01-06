import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/chat/domain/models/chat_model.dart';
import 'package:sixam_mart/features/chat/widgets/image_preview_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ImageFileViewWidget extends StatefulWidget {
  final Message currentMessage;
  final bool isRightMessage;
  const ImageFileViewWidget({super.key, required this.currentMessage, required this.isRightMessage});

  @override
  State<ImageFileViewWidget> createState() => _ImageFileViewWidgetState();
}

class _ImageFileViewWidgetState extends State<ImageFileViewWidget> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.currentMessage.fileFullUrl!.length > 3 ? 4 : widget.currentMessage.fileFullUrl!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
      ),
      itemBuilder: (context, index) {

        return InkWell(
          onTap: () {
            if(ResponsiveHelper.isDesktop(context)){
              Get.dialog(
                Dialog(
                  insetPadding: EdgeInsets.zero,
                  child: ImagePreviewWidget(currentMessage: widget.currentMessage, currentIndex: index),
                ),
              );
            }else{
              Get.to(() => ImagePreviewWidget(currentMessage: widget.currentMessage, currentIndex: index));
            }
          },
          child: Stack(
            children: [
              Hero(
                tag: widget.currentMessage.fileFullUrl![index],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  child: CustomImage(image: widget.currentMessage.fileFullUrl![index], fit: BoxFit.cover, height: double.infinity, width: double.infinity,),
                ),
              ),

              if((widget.isRightMessage ? index == 2 : index == 4) && widget.currentMessage.fileFullUrl!.length > 3 && widget.currentMessage.fileFullUrl!.length != 4)
              InkWell(
                onTap: (){
                  if(ResponsiveHelper.isDesktop(context)){
                    Get.dialog(
                      Dialog(
                        insetPadding: EdgeInsets.zero,
                        child: ImagePreviewWidget(currentMessage: widget.currentMessage, currentIndex: index),
                      ),
                    );
                  }else{
                    Get.to(() => ImagePreviewWidget(currentMessage: widget.currentMessage, currentIndex: index));
                  }
                },
                child: Container(
                  height: double.infinity, width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.currentMessage.fileFullUrl!.length - 4} +',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
