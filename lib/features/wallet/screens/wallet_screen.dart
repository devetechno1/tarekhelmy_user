import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/wallet/controllers/wallet_controller.dart';
import 'package:sixam_mart/features/wallet/widgets/bonus_banner_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:sixam_mart/features/wallet/widgets/wallet_card_widget.dart';
import 'package:sixam_mart/features/wallet/widgets/wallet_history_widget.dart';
import 'package:sixam_mart/features/wallet/widgets/web_bonus_banner_widget.dart';

class WalletScreen extends StatefulWidget {
  final String? fundStatus;
  final String? token;
  final bool fromNotification;
  const WalletScreen({super.key, this.fundStatus, this.token, this.fromNotification = false});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController scrollController = ScrollController();
  final tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();

    initCall();

  }

  void initCall(){
    if(AuthHelper.isLoggedIn()){

      Get.find<WalletController>().insertFilterList();
      Get.find<WalletController>().setWalletFilerType('all', isUpdate: false);

      if((widget.fundStatus == 'success' || widget.fundStatus == 'fail' || widget.fundStatus == 'cancel') && Get.find<WalletController>().getWalletAccessToken() != widget.token){
        Future.delayed(const Duration(seconds: 2), () {

          Get.showSnackbar(GetSnackBar(
            backgroundColor: widget.fundStatus == 'fail' || widget.fundStatus == 'cancel' ? Colors.red : Colors.green,
            message: widget.fundStatus == 'success' ? 'fund_successfully_added_to_wallet'.tr : 'fund_not_added_to_wallet'.tr,
            maxWidth: 500,
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
            margin: const EdgeInsets.all(Dimensions.paddingSizeExtremeLarge),
            borderRadius: Dimensions.radiusExtraLarge,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
          ));
        }).then((value) {
          Get.find<WalletController>().setWalletAccessToken(widget.token ?? '');
        });
      }
      Get.find<ProfileController>().getUserInfo();

      Get.find<WalletController>().getWalletBonusList(isUpdate: false);

      Get.find<WalletController>().getWalletTransactionList('1', false, Get.find<WalletController>().type);

      Get.find<WalletController>().setOffset(1);

      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent
            && Get.find<WalletController>().transactionList != null
            && !Get.find<WalletController>().isLoading) {
          int pageSize = (Get.find<WalletController>().popularPageSize! / 10).ceil();
          if (Get.find<WalletController>().offset < pageSize) {
            Get.find<WalletController>().setOffset(Get.find<WalletController>().offset + 1);
            if (kDebugMode) {
              print('end of the page');
            }
            Get.find<WalletController>().showBottomLoader();
            Get.find<WalletController>().getWalletTransactionList(Get.find<WalletController>().offset.toString(), false, Get.find<WalletController>().type);
          }
        }
      });
    }
  }
  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();

    return PopScope(
      canPop:  Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) {
        if(widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        appBar: CustomAppBar(title: 'wallet'.tr, backButton: true, onBackPressed: () {
          if(widget.fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else {
            Get.back();
          }
        }),
        body: GetBuilder<ProfileController>(
            builder: (profileController) {
              return isLoggedIn ? profileController.userInfoModel != null ? SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async{
                    Get.find<WalletController>().setWalletFilerType('all');
                    Get.find<WalletController>().getWalletTransactionList('1', true, 'all');
                    Get.find<ProfileController>().getUserInfo();
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        WebScreenTitleWidget(title: 'wallet'.tr),
                        FooterView(
                          child: SizedBox(width: Dimensions.webMaxWidth,
                            child: GetBuilder<WalletController>(
                                builder: (walletController) {
                                  return ResponsiveHelper.isDesktop(context) ? Padding(
                                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Expanded (flex: 4 , child: Column(children: [
                                            Container(
                                              decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                              ) : null,
                                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                              child: WalletCardWidget(tooltipController: tooltipController)
                                            ),
                                          ],
                                        )),
                                        const SizedBox(width: Dimensions.paddingSizeDefault),

                                        Expanded (flex: 6, child: Column(children: [
                                          const WebBonusBannerWidget(),
                                          Container(
                                            decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                            ) : null,
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                            child: const WalletHistoryWidget(),
                                          ),

                                        ])),
                                      ]),
                                  )
                               : Column(children: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                    child: WalletCardWidget(tooltipController: tooltipController),
                                  ),
                                  const BonusBannerWidget(),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                    child: WalletHistoryWidget(),
                                  ),

                                ]);
                              }
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ) : const Center(child: CircularProgressIndicator()) : NotLoggedInScreen(callBack: (value){
                initCall();
                setState(() {});
              });
            }
        ),
      ),
    );
  }
}