import 'package:cached_network_image/cached_network_image.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  final bool isHovered;
  final Color? placeholderColor;
  final double? placeHolderSize;
  const CustomImage({super.key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.isNotification = false, this.placeholder = '', this.isHovered = false, this.placeholderColor, this.placeHolderSize});

  @override
  Widget build(BuildContext context) {

    return AnimatedScale(
      scale: isHovered ? 1.1 : 1.0,  // Scale to 1.2 when hovered
      duration: const Duration(milliseconds: 300), // Animation duration
      curve: Curves.easeInOut,
      child: CachedNetworkImage(
        imageUrl: image, height: height, width: width, fit: fit,
        placeholder: (context, url) => Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder, height: placeHolderSize ?? height, width: placeHolderSize ?? width, fit: fit,color: placeholderColor),
        errorWidget: (context, url, error) => Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder, height: height, width: width, fit: fit, color: placeholderColor),
      ),
    );
  }
}

