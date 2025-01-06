import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/features/chat/domain/models/chat_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';

class ImagePreviewWidget extends StatefulWidget {
  final Message currentMessage;
  final int currentIndex;
  const ImagePreviewWidget({super.key, required this.currentMessage, this.currentIndex = 0});

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: isDesktop ? 500 : MediaQuery.of(context).size.width,
      height: isDesktop ? 600 : MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: isDesktop ? const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)) : null,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        Stack(
          children: [
            SizedBox(
              height: isDesktop ? 500 : MediaQuery.of(context).size.height - 70,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.currentMessage.fileFullUrl!.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CustomImage(
                    image: widget.currentMessage.fileFullUrl![index],
                    fit: BoxFit.fitWidth,
                  );
                },
              ),
            ),

            Positioned(
              top: 0, left: 0, right: 0, bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  if (_currentIndex > 0)
                  InkWell(
                    onTap: () {
                      if (_currentIndex > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Spacer(),

                  if (_currentIndex < widget.currentMessage.fileFullUrl!.length - 1)
                  InkWell(
                    onTap: () {
                      if (_currentIndex < widget.currentMessage.fileFullUrl!.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
