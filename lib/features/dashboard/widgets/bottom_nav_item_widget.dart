import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/util/styles.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String? selectedIcon;
  final String? unSelectedIcon;
  final String title;
  final Function? onTap;
  final bool isSelected;
  final bool isCart;
  const BottomNavItemWidget({super.key, this.onTap, this.isSelected = false, required this.title, required this.selectedIcon, required this.unSelectedIcon, this.isCart = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Column(mainAxisAlignment: isSelected? MainAxisAlignment.center :MainAxisAlignment.spaceBetween, children: [
          if(isCart) 
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CartWidget(image: isSelected ? selectedIcon : unSelectedIcon, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color!, size: 20),
            )
          else ...[
            if(selectedIcon != null && unSelectedIcon != null)
              Image.asset(
                isSelected ? selectedIcon! : unSelectedIcon!, height: 25, width: 25,
                color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color!,
              ),
          ],
          
          const SizedBox(height: 1),
          Text(
            title,
            style: robotoRegular.copyWith(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color!, fontSize: 12),
            maxLines: 1,
          ),

        ]),
      ),
    );
  }
}
