import 'package:sixam_mart/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButtonWidget extends StatefulWidget {
  final String value;
  final String title;
  final double? charge;
  final bool? isFree;
  final bool fromWeb;
  final double total;
  final String deliveryChargeForView;
  final double badWeatherCharge;
  final double extraChargeForToolTip;
  const DeliveryOptionButtonWidget({super.key, required this.value, required this.title, required this.charge, required this.isFree,
    this.fromWeb = false, required this.total, required this.deliveryChargeForView, required this.badWeatherCharge, required this.extraChargeForToolTip});

  @override
  State<DeliveryOptionButtonWidget> createState() => _DeliveryOptionButtonWidgetState();
}

class _DeliveryOptionButtonWidgetState extends State<DeliveryOptionButtonWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), (){
      Get.find<CheckoutController>().setOrderType(Get.find<SplashController>().configModel!.homeDeliveryStatus == 1
          && Get.find<CheckoutController>().store!.delivery! ? 'delivery' : 'take_away', notify: true);
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (checkoutController) {
        bool select = checkoutController.orderType == widget.value;

        return InkWell(
          onTap: () {
            checkoutController.setOrderType(widget.value);
            checkoutController.setInstruction(-1);

            if(checkoutController.orderType == 'take_away') {
              if(checkoutController.isPartialPay) {
                double tips = 0;
                try{
                  tips = double.parse(checkoutController.tipController.text);
                } catch(_) {}
                checkoutController.checkBalanceStatus(widget.total, widget.charge! + tips);
              }
            } else {
              if(checkoutController.isPartialPay){
                checkoutController.changePartialPayment();
              } else {
                checkoutController.setPaymentMethod(-1);
              }

            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: select  ? widget.fromWeb ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor : Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: select ? Theme.of(context).primaryColor : Colors.transparent),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: checkoutController.orderType,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (String? value) {
                    checkoutController.setOrderType(value);
                  },
                  activeColor: Theme.of(context).primaryColor,
                  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.title, style: robotoMedium.copyWith(color: select ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color)),

                  Row(children: [
                    Text(widget.value == 'delivery' ? '${'charge'.tr}: +${widget.deliveryChargeForView}' : 'free'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    widget.deliveryChargeForView != PriceConverter.convertPrice(0) && widget.value == 'delivery' && checkoutController.extraCharge != null && (widget.deliveryChargeForView != '0') && widget.extraChargeForToolTip > 0 ? CustomToolTip(
                      message: '${'this_charge_include_extra_vehicle_charge'.tr} ${PriceConverter.convertPrice(widget.extraChargeForToolTip)} ${widget.badWeatherCharge > 0 ? '${'and_bad_weather_charge'.tr} ${PriceConverter.convertPrice(widget.badWeatherCharge)}' : ''}',
                      preferredDirection: AxisDirection.right,
                      child: const Icon(Icons.info, color: Colors.blue, size: 14),
                    ) : const SizedBox(),
                  ]),

                ]),
                const SizedBox(width: Dimensions.paddingSizeSmall),

              ],
            ),
          ),
        );
      },
    );
  }
}
