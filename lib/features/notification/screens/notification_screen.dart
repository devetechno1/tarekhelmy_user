import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart/features/notification/widgets/notification_bottom_sheet.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/features/notification/widgets/notification_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, this.fromNotification = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if(Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if(AuthHelper.isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if(widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'notification'.tr, onBackPressed: () {
          if(widget.fromNotification){
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else{
            Get.back();
          }
        }),
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        body: AuthHelper.isLoggedIn() ? GetBuilder<NotificationController>(builder: (notificationController) {
          if(notificationController.notificationList != null) {
            notificationController.saveSeenNotificationCount(notificationController.notificationList!.length);
          }
          List<DateTime> dateTimeList = [];
          return notificationController.notificationList != null ? notificationController.notificationList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await notificationController.getNotificationList(true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: FooterView(
                child: Column(children: [
                  WebScreenTitleWidget(title: 'notification'.tr),

                  Center(
                    child: SizedBox(width: Dimensions.webMaxWidth, child: ListView.builder(
                      itemCount: notificationController.notificationList!.length,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList![index].createdAt!);
                        DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                        bool addTitle = false;
                        if(!dateTimeList.contains(convertedDate)) {
                          addTitle = true;
                          dateTimeList.add(convertedDate);
                        }

                        bool isSeen = notificationController.getSeenNotificationIdList()!.contains(notificationController.notificationList![index].id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            addTitle ? Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                              child: Text(
                                DateConverter.dateTimeStringToDateOnly(notificationController.notificationList![index].createdAt!),
                                style: robotoMedium.copyWith(color: Theme.of(context).hintColor),
                              ),
                            ) : const SizedBox(),

                            InkWell(
                              onTap: () {
                                notificationController.addSeenNotificationId(notificationController.notificationList![index].id!);

                                ResponsiveHelper.isDesktop(context) ? showDialog(context: context, builder: (BuildContext context) {
                                  return NotificationDialogWidget(notificationModel: notificationController.notificationList![index]);
                                }) : showModalBottomSheet(
                                  isScrollControlled: true, useRootNavigator: true, context: Get.context!,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                                  ),
                                  builder: (context) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                                      child: NotificationBottomSheet(notificationModel: notificationController.notificationList![index]),
                                    );
                                  },
                                );

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSeen ? Theme.of(context).cardColor : Theme.of(context).hintColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 1),
                                    child: CustomAssetImageWidget(
                                      notificationController.notificationList![index].data!.type == 'push_notification' ? Images.pushNotificationIcon
                                      : notificationController.notificationList![index].data!.type == 'order_status' ? Images.orderConfirmIcon : Images.referEarnIcon,
                                      height: 30, width: 30, fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                      Expanded(
                                        child: Text(
                                          notificationController.notificationList![index].data!.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                          style: robotoBold.copyWith(color: isSeen ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5) : Theme.of(context).textTheme.bodyLarge?.color,
                                            fontWeight: isSeen ? FontWeight.w500 : FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                        child: Text(
                                          DateConverter.dateTimeStringToFormattedTime(notificationController.notificationList![index].createdAt!),
                                          style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                                        ),
                                      ),

                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Expanded(
                                        child: Text(
                                          notificationController.notificationList![index].data!.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: robotoRegular.copyWith(color: isSeen ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      notificationController.notificationList![index].data!.type == 'push_notification' ? ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        child: CustomImage(
                                          placeholder: Images.placeholder,
                                          image: '${notificationController.notificationList![index].imageFullUrl}',
                                          height: 45, width: 75, fit: BoxFit.cover,
                                        ),
                                      ) : const SizedBox.shrink(),

                                    ]),

                                  ])),

                                ]),
                              ),
                            ),

                          ]),
                        );
                      },
                    )),
                  ),
                ]),
              ),
            ),
          ) : NoDataScreen(text: 'no_notification_found'.tr, showFooter: true) : const Center(child: CircularProgressIndicator());
        }) :  NotLoggedInScreen(callBack: (value){
          _loadData();
          setState(() {});
        }),
      ),
    );
  }
}
