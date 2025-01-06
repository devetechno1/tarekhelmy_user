import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/features/order/widgets/support_reason_bottom_sheet.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/order/widgets/order_item_widget.dart';
import 'package:sixam_mart/features/parcel/widgets/details_widget.dart';

class OrderCalculationWidget extends StatelessWidget {
  final OrderController orderController;
  final OrderModel order;
  final bool ongoing;
  final bool parcel;
  final bool prescriptionOrder;
  final double deliveryCharge;
  final double itemsPrice;
  final double discount;
  final double couponDiscount;
  final double tax;
  final double addOns;
  final double dmTips;
  final bool taxIncluded;
  final double subTotal;
  final double total;
  final Widget bottomView;
  final double extraPackagingAmount;
  final double referrerBonusAmount;
  final Function timerCancel;
  final Function startApiCall;
  const OrderCalculationWidget({
    super.key, required this.orderController, required this.order, required this.ongoing,
    required this.parcel, required this.prescriptionOrder, required this.deliveryCharge,
    required this.itemsPrice, required this.discount, required this.couponDiscount, required this.tax,
    required this.addOns, required this.dmTips, required this.taxIncluded, required this.subTotal,
    required this.total, required this.bottomView, required this.extraPackagingAmount, required this.referrerBonusAmount, required this.timerCancel, required this.startApiCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeSmall),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault) ,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular( ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 0),
          boxShadow: ResponsiveHelper.isDesktop(context) ? const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)] : [],
        ),
        child: Column(
          children: [
            (ResponsiveHelper.isDesktop(context) && orderController.orderDetails!.isNotEmpty) ? Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: parcel ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                DetailsWidget(title: 'sender_details'.tr, address: order.deliveryAddress),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                DetailsWidget(title: 'receiver_details'.tr, address: order.receiverDetails),
              ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderController.orderDetails!.length,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    return OrderItemWidget(order: order, orderDetails: orderController.orderDetails![index]);
                  },
                ),
              ]),
            ) : const SizedBox(),
            SizedBox(height: parcel &&  orderController.orderDetails!.isNotEmpty ? Dimensions.paddingSizeLarge : 0),

            SizedBox(height: (order.orderAttachmentFullUrl != null && order.orderAttachmentFullUrl!.isNotEmpty ) ? Dimensions.paddingSizeLarge : 0),

            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    child: Text('order_summary'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)))
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Total
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(
                children: [
                  parcel ? Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('delivery_fee'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text(
                        '(+) ${order.deliveryCharge}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                      ),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('delivery_man_tips'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Text('(+) ${order.dmTips}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                    ]),
                    (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                    (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text('(+) ${PriceConverter.convertPrice(order.additionalCharge)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                    ]) : const SizedBox(),


                  ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('item_price'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text(PriceConverter.convertPrice(itemsPrice), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                    ]),
                    const SizedBox(height: 10),

                    Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('addons'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Text('(+) ${PriceConverter.convertPrice(addOns)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ],
                    ) : const SizedBox(),

                    Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5),) : const SizedBox(),

                    Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${'subtotal'.tr} ${taxIncluded ? 'tax_included'.tr : ''}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Text(PriceConverter.convertPrice(subTotal), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ],
                    ) : const SizedBox(),
                    SizedBox(height: Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? 10 : 0),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('discount'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text('(-) ${PriceConverter.convertPrice(discount)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                    ]),
                    const SizedBox(height: 10),

                    couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('coupon_discount'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text(
                        '(-) ${PriceConverter.convertPrice(couponDiscount)}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                      ),
                    ]) : const SizedBox(),
                    SizedBox(height: couponDiscount > 0 ? 10 : 0),

                    (referrerBonusAmount > 0) ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('referral_discount'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Text('(+) ${PriceConverter.convertPrice(referrerBonusAmount)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ],
                    ) : const SizedBox(),
                    SizedBox(height: referrerBonusAmount > 0 ? 10 : 0),

                    (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text('(+) ${PriceConverter.convertPrice(order.additionalCharge)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                    ]) : const SizedBox(),
                    (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('${'vat_tax'.tr} ${taxIncluded ? 'tax_included'.tr : ''} (${order.taxPercentage ?? 0}%)', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text('(+) ${PriceConverter.convertPrice(tax)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                    ]),
                    const SizedBox(height: 10),

                    (dmTips > 0) ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('delivery_man_tips'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Text('(+) ${PriceConverter.convertPrice(dmTips)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ],
                    ) : const SizedBox(),
                    SizedBox(height: dmTips > 0 ? 10 : 0),

                    (extraPackagingAmount > 0) ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('extra_packaging'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Text('(+) ${PriceConverter.convertPrice(extraPackagingAmount)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr),
                      ],
                    ) : const SizedBox(),
                    SizedBox(height: extraPackagingAmount > 0 ? 10 : 0),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('delivery_fee'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      deliveryCharge > 0 ? Text(
                        '(+) ${PriceConverter.convertPrice(deliveryCharge)}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                      ) : Text('free'.tr, style: robotoRegular.copyWith( fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                    ]),

                  ]),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
            ),

            order.paymentMethod == 'partial_payment' ? Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: DottedBorder(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1,
                  strokeCap: StrokeCap.butt,
                  dashPattern: const [8, 5],
                  padding: const EdgeInsets.all(8),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(Dimensions.radiusDefault),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('total_amount'.tr, style: robotoMedium.copyWith(
                        fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor,
                      )),
                      Text(
                        PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                        style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('paid_by_wallet'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      Text(
                        PriceConverter.convertPrice(order.payments?[0].amount ?? 0),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        '${order.payments?[1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order.payments?[1].paymentMethod?.tr})',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                      Text(
                        PriceConverter.convertPrice(order.payments?[1].amount ?? 0),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ]),

                  ]),
                ),
              ),
            ) : Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('total_amount'.tr, style: robotoMedium.copyWith(
                  fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor,
                )),
                Text(
                  PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                  style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                ),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            AuthHelper.isLoggedIn() ? TextButton(
              onPressed: () async {
                if(ResponsiveHelper.isDesktop(context)) {
                  await Get.dialog(Dialog(child: SupportReasonBottomSheet(orderId: order.id!, timerCancel: timerCancel, startApiCall: startApiCall,)));
                } else {
                  await Get.bottomSheet(SupportReasonBottomSheet(orderId: order.id!, timerCancel: timerCancel, startApiCall: startApiCall,), backgroundColor: Colors.transparent, isScrollControlled: true,);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const CustomAssetImageWidget(Images.chatSupport, height: 20, width: 20),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Flexible(
                    child: RichText(text: TextSpan(children: [
                      TextSpan(
                        text: '${'message_to'.tr} ',
                        style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                      ),
                      TextSpan(
                        text: Get.find<SplashController>().configModel!.businessName,
                        style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeDefault, decoration: TextDecoration.underline),
                      ),
                    ]), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ) : const SizedBox(),

            SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
            ResponsiveHelper.isDesktop(context) ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: bottomView) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
