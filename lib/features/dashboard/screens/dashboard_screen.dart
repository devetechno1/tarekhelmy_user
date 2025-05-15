import 'dart:async';
import 'dart:io';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sixam_mart/features/dashboard/widgets/store_registration_success_bottom_sheet.dart';
import 'package:sixam_mart/features/home/controllers/home_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_dialog.dart';
import 'package:sixam_mart/features/checkout/widgets/congratulation_dialogue.dart';
import 'package:sixam_mart/features/dashboard/widgets/address_bottom_sheet_widget.dart';
import 'package:sixam_mart/features/dashboard/widgets/parcel_bottom_sheet_widget.dart';
import 'package:sixam_mart/features/home/screens/home_screen.dart';
import 'package:sixam_mart/features/menu/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:app_links/app_links.dart';

import '../../../common/widgets/custom_snackbar.dart';
import '../../../common/widgets/hover/on_hover.dart';
import '../../../util/app_constants.dart';
import '../../cart/screens/cart_screen.dart';
import '../../item/screens/offers_item_screen.dart';
import '../widgets/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen({super.key, required this.pageIndex, this.fromSplash = false});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();


  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = AuthHelper.isLoggedIn();

    _showRegistrationSuccessBottomSheet();

    if(_isLogin){
      if(Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 && Get.find<AuthController>().getEarningPint().isNotEmpty
          && !ResponsiveHelper.isDesktop(Get.context)){
        Future.delayed(const Duration(seconds: 1), () => showAnimatedDialog(Get.context!, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1, fromDashboard: true);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);
      

    _screens = [
      const HomeScreen(),
      const OffersItemScreen(backButton: false),
      const SizedBox(),
      const CartScreen(fromNav: true),
      const MenuScreen()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    AppLinks().getInitialLink().then(handleOpenedLinks);
    AppLinks().uriLinkStream.listen(handleOpenedLinks);
  }

  _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet = Get.find<HomeController>().getRegistrationSuccessfulSharedPref();
    if(canShowBottomSheet) {
      Future.delayed(const Duration(seconds: 1), () {
        ResponsiveHelper.isDesktop(Get.context) ? Get.dialog(const Dialog(child: StoreRegistrationSuccessBottomSheet())).then((value) {
          Get.find<HomeController>().saveRegistrationSuccessfulSharedPref(false);
          Get.find<HomeController>().saveIsStoreRegistrationSharedPref(false);
          setState(() {});
        }) : showModalBottomSheet(
          context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => const StoreRegistrationSuccessBottomSheet(),
        ).then((value) {
          Get.find<HomeController>().saveRegistrationSuccessfulSharedPref(false);
          Get.find<HomeController>().saveIsStoreRegistrationSharedPref(false);
          setState(() {});
        });
      });
    }
  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<LocationController>().checkLocationActive();
    if(widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => AddressBottomSheetWidget(text: '${'hey_welcome_back'.tr}\n${'which_location_do_you_want_to_select'.tr}'),
        ).then((value) {
          Get.find<LocationController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return GetBuilder<SplashController>(
      builder: (splashController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (_pageIndex != 0) {
              _setPage(0);
            } else {
              if(!ResponsiveHelper.isDesktop(context) && Get.find<SplashController>().module != null && Get.find<SplashController>().configModel!.module == null) {
                Get.find<SplashController>().setModule(null);
                Get.find<StoreController>().resetStoreData();
              }else {
                if(_canExit) {
                  if (GetPlatform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (GetPlatform.isIOS) {
                    exit(0);
                  }
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  ));
                  _canExit = true;
                  Timer(const Duration(seconds: 2), () {
                    _canExit = false;
                  });
                }
              }
            }
          },
          child: GetBuilder<OrderController>(
            builder: (orderController) {
              List<OrderModel> runningOrder = orderController.runningOrderModel != null ? orderController.runningOrderModel!.orders! : [];

              List<OrderModel> reversOrder =  List.from(runningOrder.reversed);

              return Scaffold(
                key: _scaffoldKey,
                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                floatingActionButton:_pageIndex == 0 ? Padding(
                  padding:ResponsiveHelper.isDesktop(context)? EdgeInsets.zero : EdgeInsets.only(bottom: GetPlatform.isIOS ? 65 : 55),
                  child: OnHover(
                    child: FloatingActionButton(
                      backgroundColor: ResponsiveHelper.isDesktop(context)? Colors.transparent : const Color(0xff2ea218),
                      onPressed: () async {
                        final String link = 'https://api.whatsapp.com/send?phone=${Get.find<SplashController>().configModel!.phone?.replaceAll("+", '')}';
                        if(await canLaunchUrlString(link)) {
                          launchUrlString(link);
                        }else {
                          showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel!.phone}');
                        }
                      },
                      child: SizedBox.square(dimension: 38, child: Image.asset(Images.whatsappImage)),
                    ),
                  ),
                ) : null,
                body: ExpandableBottomSheet(
                  background: Stack(children: [
                    PageView.builder(
                        controller: _pageController,
                        itemCount: _screens.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _screens[index];
                        },
                      ),

                      ResponsiveHelper.isDesktop(context) || keyboardVisible ? const SizedBox() : Align(
                        alignment: Alignment.bottomCenter,
                        child: GetBuilder<SplashController>(
                          builder: (splashController) {
                            bool isParcel = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isParcel!;

                            _screens = [
                              const HomeScreen(),
                              const OffersItemScreen(backButton: false),
                              const SizedBox(),
                              const CartScreen(fromNav: true),
                              const MenuScreen()
                            ];
                            final double height = GetPlatform.isIOS ? 100 : 60;

                            final bool dontShowNavBar = (orderController.showBottomSheet && orderController.runningOrderModel != null && orderController.runningOrderModel!.orders!.isNotEmpty && _isLogin) || (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active);
                            
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: size.width, height: height,
                              transform: Matrix4.translationValues(0,dontShowNavBar ? (height + 50) : 0,0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Stack(children: [
                            
                                Center(
                                  heightFactor: 0.4,
                                  child: Container(
                                      width: 55, height: 55,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).cardColor, width: 5),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                      ),
                                      child: FloatingActionButton(
                                        heroTag: "button",
                                        backgroundColor: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          if(isParcel) {
                                            showModalBottomSheet(
                                              context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                              builder: (con) => ParcelBottomSheetWidget(parcelCategoryList: Get.find<ParcelController>().parcelCategoryList),
                                            );
                                          } else {
                                            Get.toNamed(RouteHelper.getCheckoutRoute('request_prescription',storeId: Get.find<StoreController>().storeModel?.stores?.lastOrNull?.id ?? 5));
                                          }
                                        },
                                        elevation: 0,
                                        child: isParcel ? Icon(CupertinoIcons.add, size: 34, color: Theme.of(context).cardColor) : Image.asset(Images.orderUnselect, height: 28, width: 28, color:  Theme.of(context).cardColor),
                                      ),
                                  ),
                                ),
                                Positioned.fill(
                                  top: 38,
                                  child: Text(
                                    'request_prescription'.tr,
                                    textAlign: TextAlign.center,
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!, fontSize: 12),
                                  ),
                                ),
                            
                                Center(
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                      width: size.width, height: height,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ 
                                        BottomNavItemWidget(
                                          title: 'home'.tr, selectedIcon: Images.homeSelect,
                                          unSelectedIcon: Images.homeUnselect, isSelected: _pageIndex == 0,
                                          onTap: () => _setPage(0),
                                        ),
                                        BottomNavItemWidget(
                                          title: 'offers'.tr,
                                          selectedIcon: Images.offersSelect,
                                          unSelectedIcon:Images.offersUnselect,
                                          isSelected: _pageIndex == 1, onTap: () => _setPage(1),
                                        ),
                                        SizedBox(width: size.width * 0.2),
                                        BottomNavItemWidget(
                                          isCart: true,
                                          title: 'cart'.tr, selectedIcon: Images.shoppingCartSelected, unSelectedIcon: Images.shoppingCart,
                                          isSelected: _pageIndex == 3, onTap: () => _setPage(3),
                                        ),
                                        BottomNavItemWidget(
                                          title: 'menu'.tr, selectedIcon: Images.menu, unSelectedIcon: Images.menu,
                                          isSelected: _pageIndex == 4, onTap: () => _setPage(4),
                                        ),
                                      ]),
                                  ),
                                ),
                              ],
                              ),
                            );
                          }
                        ),
                      ),
                    ]),

                  persistentContentHeight: (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? 0 : GetPlatform.isIOS ? 110 : 100,

                  onIsContractedCallback: () {
                    if(!orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },
                  onIsExtendedCallback: () {
                    if(orderController.showOneOrder) {
                      orderController.showOrders();
                    }
                  },

                  enableToggle: true,

                  expandableContent: (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active && !ResponsiveHelper.isDesktop(context)) ?  const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) || !_isLogin || orderController.runningOrderModel == null
                  || orderController.runningOrderModel!.orders!.isEmpty || !orderController.showBottomSheet) ? const SizedBox()
                  : Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if(orderController.showBottomSheet){
                        orderController.showRunningOrders();
                      }
                    },
                    child: RunningOrderViewWidget(reversOrder: reversOrder, onOrderTap: () {
                      _setPage(3);
                      if(orderController.showBottomSheet){
                        orderController.showRunningOrders();
                      }
                    }),
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(height: 3, decoration: BoxDecoration(color: status ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}

Future<void> handleOpenedLinks(Uri? value) async{
  if(value != null && value.pathSegments[0] == AppConstants.product){
    int? id = int.tryParse(value.queryParameters['id'] ??'');
    if(id == null) return;
    Get.toNamed(RouteHelper.getItemDetailsRoute(id, false));
  }
}

