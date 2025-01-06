import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
class CartCountView extends StatelessWidget {
  final Item item;
  final Widget? child;
  final int? index;
  final double bottomPadding;
  final AlignmentGeometry? alignment;
  const CartCountView({super.key, required this.item, this.child, this.index = -1, this.bottomPadding = 15, this.alignment});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      int cartQty = cartController.cartQuantity(item.id!);
      int cartIndex = cartController.isExistInCart(item.id, cartController.cartVariant(item.id!), false, null);
      return cartQty != 0 ? Center(
        child: Container(
          width: 100,
          margin: cartController.cartList[cartIndex].quantity! >= 1? EdgeInsets.only(bottom: bottomPadding) : null,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: cartController.isLoading && cartController.directAddCartItemIndex == index? null : () {
                if (cartController.cartList[cartIndex].quantity! > 1) {
                  cartController.setDirectlyAddToCartIndex(index);
                  cartController.setQuantity(false, cartIndex, cartController.cartList[cartIndex].stock, cartController.cartList[cartIndex].item!.quantityLimit);
                }else {
                  cartController.removeFromCart(cartIndex);
                }
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Icon(
                  Icons.remove, size: 16, color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: cartController.isLoading && cartController.directAddCartItemIndex == index
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Theme.of(context).cardColor))
                  : Text(cartQty.toString(),
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
              ) ,
            ),

            InkWell(
              onTap: cartController.isLoading && cartController.directAddCartItemIndex == index ? null : () {
                cartController.setDirectlyAddToCartIndex(index);
                cartController.setQuantity(true, cartIndex, cartController.cartList[cartIndex].stock, cartController.cartList[cartIndex].quantityLimit);
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Icon(
                  Icons.add, size: 16, color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ]),
        ),
      ) : Align(
        alignment: alignment ?? AlignmentDirectional.topStart,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            Get.find<ItemController>().itemDirectlyAddToCart(item, context);
          },
          child: child ?? Container(
            height: 25, width: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
            ),
            child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
          ),
        ),
      );
    });
  }
}
