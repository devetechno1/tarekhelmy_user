import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/chat/domain/models/order_chat_model.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class SupportReasonBottomSheet extends StatefulWidget {
  final int? orderId;
  final bool fromChatPage;
  final Function? timerCancel;
  final Function? startApiCall;
  const SupportReasonBottomSheet({super.key, required this.orderId, this.fromChatPage = false, this.timerCancel, this.startApiCall});

  @override
  State<SupportReasonBottomSheet> createState() => _SupportReasonBottomSheetState();
}

class _SupportReasonBottomSheetState extends State<SupportReasonBottomSheet> {
  int selectIndex = -1;
  bool isTextFieldNotEmpty = false;
  late final TextEditingController massageTextController;

  @override
  void initState() {
    super.initState();

    massageTextController = TextEditingController();
    Get.find<OrderController>().getSupportReasons();
  }

  @override
  void dispose() {
    massageTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<OrderController>(
        builder: (orderController) {
          return Stack(
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  !ResponsiveHelper.isDesktop(context) ? Container(
                    height: 4, width: 35,
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
                  ) : const SizedBox(),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [

                        orderController.supportReasons != null ? orderController.supportReasons!.isNotEmpty ? Column(mainAxisSize: MainAxisSize.min, children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            child: Text('choose_the_reason_for_support'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderController.supportReasons!.length,
                            itemBuilder: (context, index){
                              bool isSelected = selectIndex == index;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectIndex = index;
                                  });

                                  if(widget.fromChatPage) {
                                    Get.back(result: orderController.supportReasons![index]!);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    border: Border.all(color: isSelected ? Colors.transparent : Theme.of(context).disabledColor, width: 0.5),
                                    boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.5), blurRadius: 5)] : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          orderController.supportReasons![index]!, maxLines: 2,
                                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: isSelected ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6)),
                                        ),
                                      ),

                                      if(!widget.fromChatPage)
                                      Icon(isSelected ? Icons.radio_button_on : Icons.radio_button_off_outlined, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        ]) : const SizedBox() : const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                            child: CircularProgressIndicator(),
                          ),
                        ),

                        !widget.fromChatPage ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Text(
                            orderController.supportReasons != null && orderController.supportReasons!.isNotEmpty ? 'or_custom_message'.tr : 'custom_message'.tr,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                        ) : const SizedBox(),

                        !widget.fromChatPage ? CustomTextField(
                          controller: massageTextController,
                          titleText: 'type_here_to_write_a_custom_message'.tr,
                          showLabelText: false,
                          maxLines: 3,
                          inputType: TextInputType.multiline,
                          inputAction: TextInputAction.done,
                          capitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            setState(() {
                              isTextFieldNotEmpty = massageTextController.text.isNotEmpty;
                            });
                          },
                        ) : const SizedBox(),

                      ]),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  !widget.fromChatPage ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: CustomButton(
                        buttonText: 'send_message'.tr,
                        onPressed: (selectIndex != -1 || isTextFieldNotEmpty) ? () async {

                          Get.back();
                          if(widget.timerCancel != null) {
                            widget.timerCancel!();
                          }
                          await Get.toNamed(RouteHelper.getChatRoute(
                            notificationBody: NotificationBodyModel(
                              type: 'admin', notificationType: NotificationType.message,
                              adminId: 0, restaurantId: null, deliverymanId: null,
                            ),
                            orderChatModel: OrderChatModel(
                              orderId: widget.orderId.toString(), reason: (orderController.supportReasons != null && orderController.supportReasons!.isNotEmpty && selectIndex != -1) ? orderController.supportReasons![selectIndex] : '',
                              customMessage: massageTextController.text.trim(),
                            ),
                          ));
                          if(widget.startApiCall != null) {
                            widget.startApiCall!();
                          }
                        } : null,
                      ),
                    ),
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeLarge)
                ]),
              ),

              ResponsiveHelper.isDesktop(context) ? Positioned(top: 10, right: 10, child: InkWell(onTap: ()=> Get.back(), child: const Icon(Icons.clear))) : const SizedBox(),
            ],
          );
        }
      ),
    );
  }
}
