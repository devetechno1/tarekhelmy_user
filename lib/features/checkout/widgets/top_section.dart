import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/features/checkout/widgets/guest_create_account.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/common/models/config_model.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';
import 'package:sixam_mart/features/cart/widgets/delivery_option_button_widget.dart';
import 'package:sixam_mart/features/checkout/widgets/coupon_section.dart';
import 'package:sixam_mart/features/checkout/widgets/delivery_instruction_view.dart';
import 'package:sixam_mart/features/checkout/widgets/delivery_section.dart';
import 'package:sixam_mart/features/checkout/widgets/deliveryman_tips_section.dart';
import 'package:sixam_mart/features/checkout/widgets/partial_pay_view.dart';
import 'package:sixam_mart/features/checkout/widgets/payment_section.dart';
import 'package:sixam_mart/features/checkout/widgets/time_slot_section.dart';
import 'package:sixam_mart/features/checkout/widgets/web_delivery_instruction_view.dart';
import 'package:sixam_mart/features/store/widgets/camera_button_sheet_widget.dart';
import 'dart:io';

import '../../location/controllers/location_controller.dart';

class TopSection extends StatefulWidget {
  final CheckoutController checkoutController;
  final double charge;
  final double deliveryCharge;
  final List<DropdownItem<int>> addressList;
  final bool tomorrowClosed;
  final bool todayClosed;
  final Module? module;
  final  double price;
  final double discount;
  final double addOns;
  final int? storeId;
  final List<AddressModel> address;
  final List<CartModel?>? cartList;
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isWalletActive;
  final double total;
  final bool isOfflinePaymentActive;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  final JustTheController tooltipController1;
  final JustTheController tooltipController2;
  final JustTheController dmTipsTooltipController;
  final TextEditingController guestPasswordController;
  final TextEditingController guestConfirmPasswordController;
  final FocusNode guestPasswordNode;
  final FocusNode guestConfirmPasswordNode;
  final double variationPrice;
  final String deliveryChargeForView;
  final double badWeatherCharge;
  final double extraChargeForToolTip;

  const TopSection({
    super.key, required this.deliveryCharge, required  this.charge, required this.tomorrowClosed,
    required this.todayClosed, required this.price, required this.discount, required this.addOns,
    required this.addressList, required this.checkoutController,
    this.module, this.storeId, required this.address, required this.cartList,
    required this.isCashOnDeliveryActive, required this.isDigitalPaymentActive, required this.isWalletActive,
    required this.total, required this.isOfflinePaymentActive, required this.guestNameTextEditingController,
    required this.guestNumberTextEditingController, required this.guestNumberNode,
    required this.guestEmailController, required this.guestEmailNode, required this.tooltipController1,
    required this.tooltipController2, required this.dmTipsTooltipController, required this.guestPasswordController, required this.guestConfirmPasswordController,
    required this.guestPasswordNode, required this.guestConfirmPasswordNode, required this.variationPrice, required this.deliveryChargeForView,
    required this.badWeatherCharge, required this.extraChargeForToolTip
  });

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {

  @override
  void initState() {
    super.initState();
    sortAddress();
  }


  void sortAddress()async{
    for (int i = 0; i < widget.address.length; i++) {
      if(widget.address[i].streetNumber?.trim().isNotEmpty == true && widget.address[i].house?.trim().isNotEmpty == true && widget.address[i].floor?.trim().isNotEmpty == true){

        widget.checkoutController.getDistanceInKM(
          LatLng(
            double.parse(widget.address[i].latitude!),
            double.parse(widget.address[i].longitude!),
          ),
          LatLng(double.parse(widget.checkoutController.store!.latitude!), double.parse(widget.checkoutController.store!.longitude!)),
        );
        
        widget.checkoutController.setAddressIndex(i,false);
        widget.checkoutController.streetNumberController.text = widget.address[i].streetNumber ?? '';
        widget.checkoutController.houseController.text = widget.address[i].house ?? '';
        widget.checkoutController.floorController.text = widget.address[i].floor ?? '';
        final AddressModel? add = await Get.find<LocationController>().prepareZoneInCheckout(widget.address[i]);
        if(add != null) widget.address[i] = add;
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    bool takeAway = (widget.checkoutController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = AuthHelper.isGuestLoggedIn();

    return Container(
      decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      ) : null,
      child: Column(children: [

        widget.storeId != null ? Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              Text('your_prescription'.tr, style: robotoMedium),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              JustTheTooltip(
                backgroundColor: Colors.black87,
                controller: widget.tooltipController1,
                preferredDirection: AxisDirection.right,
                tailLength: 14,
                tailBaseWidth: 20,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('prescription_tool_tip'.tr, style: robotoRegular.copyWith(color: Colors.white)),
                ),
                child: InkWell(
                  onTap: () => widget.tooltipController1.showTooltip(),
                  child: const Icon(Icons.info_outline),
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.checkoutController.pickedPrescriptions.length+1,
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                itemBuilder: (context, index) {
                  XFile? file = index == widget.checkoutController.pickedPrescriptions.length ? null : widget.checkoutController.pickedPrescriptions[index];
                  if(index < 5 && index == widget.checkoutController.pickedPrescriptions.length) {
                    return InkWell(
                      onTap: () {
                        if (ResponsiveHelper.isDesktop(context) || GetPlatform.isIOS){
                          widget.checkoutController.pickPrescriptionImage(isRemove: false, isCamera: false);
                        } else {
                          Get.bottomSheet(const CameraButtonSheetWidget());
                        }
                      },
                      child: DottedBorder(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [5, 5],
                        padding: const EdgeInsets.all(0),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(Dimensions.radiusDefault),
                        child: Container(
                          height: 98, width: 98, alignment: Alignment.center, decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                          child:  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.cloud_upload, color: Theme.of(context).disabledColor, size: 32),
                            Text('upload_your_prescription'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,),
                          ]),
                        ),
                      ),
                    );
                  }
                  return file != null ? Container(
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: DottedBorder(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 1,
                      strokeCap: StrokeCap.butt,
                      dashPattern: const [5, 5],
                      padding: const EdgeInsets.all(0),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(Dimensions.radiusDefault),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: GetPlatform.isWeb ? Image.network(
                              file.path, width: 98, height: 98, fit: BoxFit.cover,
                            ) : Image.file(
                              File(file.path), width: 98, height: 98, fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0, top: 0,
                            child: InkWell(
                              onTap: () => widget.checkoutController.removePrescriptionImage(index),
                              child: const Padding(
                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Icon(Icons.delete_forever, color: Colors.red),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ) : const SizedBox();
                },
              ),
            ),
          ]),
        ) : const SizedBox(),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        // delivery option
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          width: double.infinity,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('delivery_type'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              widget.storeId != null ? DeliveryOptionButtonWidget(
                value: 'delivery', title: 'home_delivery'.tr, charge: widget.charge,
                isFree: widget.checkoutController.store!.freeDelivery, fromWeb: true, total: widget.total,
                deliveryChargeForView: widget.deliveryChargeForView, badWeatherCharge: widget.badWeatherCharge, extraChargeForToolTip: widget.extraChargeForToolTip,
              ) : SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                Get.find<SplashController>().configModel!.homeDeliveryStatus == 1 && widget.checkoutController.store!.delivery! ? DeliveryOptionButtonWidget(
                  value: 'delivery', title: 'home_delivery'.tr, charge: widget.charge,
                  isFree: widget.checkoutController.store!.freeDelivery,  fromWeb: true, total: widget.total,
                  deliveryChargeForView: widget.deliveryChargeForView, badWeatherCharge: widget.badWeatherCharge, extraChargeForToolTip: widget.extraChargeForToolTip,
                ) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Get.find<SplashController>().configModel!.takeawayStatus == 1 && widget.checkoutController.store!.takeAway! ? DeliveryOptionButtonWidget(
                  value: 'take_away', title: 'take_away'.tr, charge: widget.deliveryCharge, isFree: true,  fromWeb: true, total: widget.total,
                  deliveryChargeForView: widget.deliveryChargeForView, badWeatherCharge: widget.badWeatherCharge, extraChargeForToolTip: widget.extraChargeForToolTip,
                ) : const SizedBox(),
              ]),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        /*///Delivery_fee
        !takeAway && !isGuestLoggedIn ? Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('${'delivery_charge'.tr}: '),
          Text(
            checkoutController.store!.freeDelivery! ? 'free'.tr
                : checkoutController.distance != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr,
            textDirection: TextDirection.ltr,
          ),
        ])) : const SizedBox(),
        SizedBox(height: !takeAway && !isGuestLoggedIn ? Dimensions.paddingSizeLarge : 0),*/

        ///delivery section
        DeliverySection(checkoutController: widget.checkoutController, address: widget.address, addressList: widget.addressList,
          guestNameTextEditingController: widget.guestNameTextEditingController, guestNumberTextEditingController: widget.guestNumberTextEditingController,
          guestNumberNode: widget.guestNumberNode, guestEmailController: widget.guestEmailController, guestEmailNode: widget.guestEmailNode,
        ),

        SizedBox(height: !takeAway ? isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall : 0),

        ///delivery instruction
        !takeAway ? isDesktop ? const WebDeliveryInstructionView() : const DeliveryInstructionView() : const SizedBox(),
        SizedBox(height: !takeAway ? isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall : 0),

        ///Create Account with existing info

        isGuestLoggedIn && Get.find<SplashController>().configModel!.centralizeLoginSetup!.manualLoginStatus! ? GuestCreateAccount(
          guestPasswordController: widget.guestPasswordController, guestConfirmPasswordController: widget.guestConfirmPasswordController,
          guestPasswordNode: widget.guestPasswordNode, guestConfirmPasswordNode: widget.guestConfirmPasswordNode,
        ) : const SizedBox(),
        SizedBox(height: isGuestLoggedIn && Get.find<SplashController>().configModel!.centralizeLoginSetup!.manualLoginStatus! ? Dimensions.paddingSizeSmall : 0),

        /// Time Slot
        TimeSlotSection(
          storeId: widget.storeId, checkoutController: widget.checkoutController, cartList: widget.cartList, tooltipController2: widget.tooltipController2,
          tomorrowClosed: widget.tomorrowClosed, todayClosed: widget.todayClosed, module: widget.module,
        ),

        /// Coupon..
        !isDesktop && !isGuestLoggedIn ? CouponSection(
          storeId: widget.storeId, checkoutController: widget.checkoutController, total: widget.total, price: widget.price,
          discount: widget.discount, addOns: widget.addOns, deliveryCharge: widget.deliveryCharge, variationPrice: widget.variationPrice,
        ) : const SizedBox(),

        ///DmTips..
        DeliveryManTipsSection(
          takeAway: takeAway, tooltipController3: widget.dmTipsTooltipController,
          totalPrice: widget.total, onTotalChange: (double price) => widget.total + price, storeId: widget.storeId,
        ),

        ///Payment..
        Container(
          decoration: isDesktop ? const BoxDecoration() : BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [

            PaymentSection(
              storeId: widget.storeId, isCashOnDeliveryActive: widget.isCashOnDeliveryActive, isDigitalPaymentActive: widget.isDigitalPaymentActive,
              isWalletActive: widget.isWalletActive, total: widget.total, checkoutController: widget.checkoutController, isOfflinePaymentActive: widget.isOfflinePaymentActive,
            ),
            SizedBox(height: isGuestLoggedIn ? 0 : Dimensions.paddingSizeLarge),

            !isDesktop && !isGuestLoggedIn ? PartialPayView(totalPrice: widget.total, isPrescription: widget.storeId != null) : const SizedBox(),

          ]),
        ),
        SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),


      ]),
    );
  }
}
