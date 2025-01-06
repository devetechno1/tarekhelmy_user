import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/util/styles.dart';

class CustomToolTip extends StatefulWidget {
  final String? message;
  final Widget? child;
  final AxisDirection preferredDirection;
  final double? size;
  final Color? iconColor;
  final Widget? content;
  const CustomToolTip({super.key, this.message, this.child, this.preferredDirection = AxisDirection.right, this.size, this.iconColor = Colors.grey, this.content});

  @override
  State<CustomToolTip> createState() => _CustomToolTipState();
}

class _CustomToolTipState extends State<CustomToolTip> {

  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
      controller: tooltipController,
      preferredDirection: widget.preferredDirection,
      tailLength: 14,
      tailBaseWidth: 20,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.content ?? Text(widget.message ?? '', style: robotoRegular.copyWith(color: Get.isDarkMode ? Colors.black87 : Colors.white)),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          tooltipController.showTooltip();
        },
        child: widget.child ?? Icon(Icons.info_outline, size: widget.size ?? 22, color: widget.iconColor),
      ),
    );
  }
}
