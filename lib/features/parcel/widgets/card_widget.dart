import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final bool showCard;
  const CardWidget({super.key, required this.child, this.showCard = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: showCard ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
      decoration: showCard ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      ) : null,
      child: child,
    );
  }
}
