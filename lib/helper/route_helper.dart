import 'dart:convert';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/auth/screens/new_user_setup_screen.dart';
import 'package:sixam_mart/features/brands/screens/brands_product_screen.dart';
import 'package:sixam_mart/features/brands/screens/brands_screen.dart';
import 'package:sixam_mart/features/business/screens/subscription_payment_screen.dart';
import 'package:sixam_mart/features/business/screens/subscription_success_or_failed_screen.dart';
import 'package:sixam_mart/features/chat/domain/models/order_chat_model.dart';
import 'package:sixam_mart/features/loyalty/screens/loyalty_screen.dart';
import 'package:sixam_mart/features/profile/domain/models/update_user_model.dart';
import 'package:sixam_mart/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_category_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/address/screens/add_address_screen.dart';
import 'package:sixam_mart/features/address/screens/address_screen.dart';
import 'package:sixam_mart/features/auth/screens/delivery_man_registration_screen.dart';
import 'package:sixam_mart/features/auth/screens/sign_in_screen.dart';
import 'package:sixam_mart/features/auth/screens/sign_up_screen.dart';
import 'package:sixam_mart/features/auth/screens/store_registration_screen.dart';
import 'package:sixam_mart/features/category/screens/category_screen.dart';
import 'package:sixam_mart/features/location/screens/map_screen.dart';
import 'package:sixam_mart/features/store/screens/campaign_screen.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/html_type.dart';
import 'package:sixam_mart/common/widgets/image_viewer_screen.dart';
import 'package:sixam_mart/common/widgets/not_found.dart';
import 'package:sixam_mart/features/cart/screens/cart_screen.dart';
import 'package:sixam_mart/features/category/screens/category_item_screen.dart';
import 'package:sixam_mart/features/chat/screens/chat_screen.dart';
import 'package:sixam_mart/features/chat/screens/conversation_screen.dart';
import 'package:sixam_mart/features/checkout/screens/checkout_screen.dart';
import 'package:sixam_mart/features/payment/screens/offline_payment_screen.dart';
import 'package:sixam_mart/features/checkout/screens/order_successful_screen.dart';
import 'package:sixam_mart/features/payment/screens/payment_screen.dart';
import 'package:sixam_mart/features/payment/screens/payment_webview_screen.dart';
import 'package:sixam_mart/features/coupon/screens/coupon_screen.dart';
import 'package:sixam_mart/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixam_mart/features/favourite/screens/favourite_screen.dart';
import 'package:sixam_mart/features/flash_sale/screens/flash_sale_details_screen.dart';
import 'package:sixam_mart/features/item/screens/item_campaign_screen.dart';
import 'package:sixam_mart/features/item/screens/item_details_screen.dart';
import 'package:sixam_mart/features/item/screens/popular_item_screen.dart';
import 'package:sixam_mart/features/verification/screens/forget_pass_screen.dart';
import 'package:sixam_mart/features/verification/screens/new_pass_screen.dart';
import 'package:sixam_mart/features/verification/screens/verification_screen.dart';
import 'package:sixam_mart/features/html/screens/html_viewer_screen.dart';
import 'package:sixam_mart/features/interest/screens/interest_screen.dart';
import 'package:sixam_mart/features/language/screens/language_screen.dart';
import 'package:sixam_mart/features/location/screens/access_location_screen.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/notification/screens/notification_screen.dart';
import 'package:sixam_mart/features/onboard/screens/onboarding_screen.dart';
import 'package:sixam_mart/features/order/screens/guest_track_order_screen.dart';
import 'package:sixam_mart/features/order/screens/order_details_screen.dart';
import 'package:sixam_mart/features/order/screens/order_screen.dart';
import 'package:sixam_mart/features/order/screens/order_tracking_screen.dart';
import 'package:sixam_mart/features/order/screens/refund_request_screen.dart';
import 'package:sixam_mart/features/parcel/screens/parcel_category_screen.dart';
import 'package:sixam_mart/features/parcel/screens/parcel_location_screen.dart';
import 'package:sixam_mart/features/parcel/screens/parcel_request_screen.dart';
import 'package:sixam_mart/features/profile/screens/profile_screen.dart';
import 'package:sixam_mart/features/profile/screens/update_profile_screen.dart';
import 'package:sixam_mart/features/store/screens/all_store_screen.dart';
import 'package:sixam_mart/features/store/screens/store_item_search_screen.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:sixam_mart/features/review/screens/review_screen.dart';
import 'package:sixam_mart/features/search/screens/search_screen.dart';
import 'package:sixam_mart/features/splash/screens/splash_screen.dart';
import 'package:sixam_mart/features/support/screens/support_screen.dart';
import 'package:sixam_mart/features/update/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/wallet/screens/wallet_screen.dart';

import '../features/item/screens/offers_item_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String onBoarding = '/on-boarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String search = '/search';
  static const String store = '/store';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String coupon = '/coupon';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String address = '/address';
  static const String orderSuccess = '/order-successful';
  static const String payment = '/payment';
  static const String checkout = '/checkout';
  static const String orderTracking = '/track-order';
  static const String basicCampaign = '/basic-campaign';
  static const String html = '/html-page';
  static const String categories = '/categories';
  static const String categoryItem = '/category-item';
  static const String popularItems = '/popular-items';
  static const String itemCampaign = '/item-campaign';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String storeReview = '/store-review';
  static const String allStores = '/stores';
  static const String itemImages = '/item-images';
  static const String parcelCategory = '/parcel-category';
  static const String parcelLocation = '/parcel-location';
  static const String parcelRequest = '/parcel-request';
  static const String searchStoreItem = '/search-store-item';
  static const String order = '/order';
  static const String itemDetails = '/item-details';
  static const String wallet = '/wallet';
  static const String loyalty = '/loyalty';
  static const String referAndEarn = '/refer-and-earn';
  static const String messages = '/messages';
  static const String conversation = '/conversation';
  static const String restaurantRegistration = '/store-registration';
  static const String deliveryManRegistration = '/delivery-man-registration';
  static const String refund = '/refund';

  static const String offlinePaymentScreen = '/offline-payment-screen';
  static const String flashSaleDetailsScreen = '/flash-sale-details-screen';
  static const String guestTrackOrderScreen = '/guest-track-order-screen';
  static const String offers = '/offers';
  static const String favourite = '/favourite';
  static const String brands = '/brands';
  static const String brandsItemScreen = '/brands-item-screen';

  static const String subscriptionSuccess = '/subscription-success';
  static const String subscriptionPayment = '/subscription-payment';
  static const String newUserSetupScreen = '/new-user-setup-screen';


  static String getInitialRoute({bool fromSplash = false}) => '$initial?from-splash=$fromSplash';
  static String getSplashRoute(NotificationBodyModel? body) {
    String data = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data';
  }
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getOnBoardingRoute() => onBoarding;
  static String getSignInRoute(String page) => '$signIn?page=$page';
  static String getSignUpRoute() => signUp;
  /*static String getVerificationRoute(String? number, String? token, String page, String pass, {String? session}) {
    String? authSession;
    if(session != null) {
      authSession = base64Url.encode(utf8.encode(session));
    }
    return '$verification?page=$page&number=$number&token=$token&pass=$pass&session=$authSession';
  }*/

  static String getVerificationRoute(String? number, String? email, String? token, String page, String? pass, String loginType, {String? session, UpdateUserModel? updateUserModel}) {
    String? authSession;
    String? userModel;
    if(session != null) {
      authSession = base64Url.encode(utf8.encode(session));
    }
    if(updateUserModel != null) {
      List<int> encoded = utf8.encode(jsonEncode(updateUserModel.toJson()));
      userModel = base64Encode(encoded);
    }
    return '$verification?page=$page&number=$number&email=$email&token=$token&pass=$pass&login_type=$loginType&session=$authSession&user_model=$userModel';
  }

  static String getAccessLocationRoute(String page) => '$accessLocation?page=$page';
  static String getPickMapRoute(String? page, bool canRoute) => '$pickMap?page=$page&route=${canRoute.toString()}';
  static String getInterestRoute() => interest;
  static String getMainRoute(String page) => '$main?page=$page';
  /*static String getForgotPassRoute(bool fromSocialLogin, SocialLogInBody? socialLogInBody) {
    String? data;
    if(fromSocialLogin) {
      data = base64Encode(utf8.encode(jsonEncode(socialLogInBody!.toJson())));
    }
    return '$forgotPassword?page=${fromSocialLogin ? 'social-login' : 'forgot-password'}&data=${fromSocialLogin ? data : 'null'}';
  }*/

  static String getForgotPassRoute() => forgotPassword;

  static String getResetPasswordRoute(String? phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getSearchRoute({String? queryText}) => '$search?query=${queryText ?? ''}';
  static String getStoreRoute({required int? id, required String page}) {
    return '$store?id=$id&page=$page';
  }
  static String getOrderDetailsRoute(int? orderID, {bool? fromNotification, bool? fromOffline, String? contactNumber}) {
    return '$orderDetails?id=$orderID&from=${fromNotification.toString()}&from_offline=$fromOffline&contact=$contactNumber';
  }
  static String getProfileRoute() => profile;
  static String getUpdateProfileRoute() => updateProfile;
  static String getCouponRoute() => coupon;
  static String getNotificationRoute({bool? fromNotification}) => '$notification?from=${fromNotification.toString()}';
  static String getMapRoute(AddressModel addressModel, String page, bool isFood, {String? storeName}) {
    List<int> encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String data = base64Encode(encoded);
    return '$map?address=$data&page=$page&module=$isFood&store-name=${storeName?? ''}';
  }
  static String getAddressRoute() => address;
  static String getOrderSuccessRoute(String orderID, String? contactNumber, {bool? createAccount, String guestId = ''}) {
    return '$orderSuccess?id=$orderID&contact_number=$contactNumber&create_account=$createAccount&guest_id=$guestId';
  }
  static String getPaymentRoute(String id, int? user, String? type, double amount, bool? codDelivery, String? paymentMethod, {required String guestId, String? contactNumber, String? addFundUrl, String? subscriptionUrl, int? storeId, bool? createAccount, int? createUserId}
      ) => '$payment?id=$id&user=$user&type=$type&amount=$amount&cod-delivery=$codDelivery&add-fund-url=$addFundUrl&payment-method=$paymentMethod&guest-id=$guestId&number=$contactNumber&subscription-url=$subscriptionUrl&store_id=$storeId&create_account=$createAccount&create_user_id=$createUserId';
  static String getCheckoutRoute(String page,{int? storeId}) => '$checkout?page=$page&store-id=$storeId';
  static String getOrderTrackingRoute(int? id, String? contactNumber) => '$orderTracking?id=$id&number=$contactNumber';
  static String getBasicCampaignRoute(BasicCampaignModel basicCampaignModel) {
    String data = base64Encode(utf8.encode(jsonEncode(basicCampaignModel.toJson())));
    return '$basicCampaign?data=$data';
  }
  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getCategoryRoute() => categories;
  static String getCategoryItemRoute(int? id, String name) {
    List<int> encoded = utf8.encode(name);
    String data = base64Encode(encoded);
    return '$categoryItem?id=$id&name=$data';
  }
  static String getPopularItemRoute(bool isPopular, bool isSpecial) => '$popularItems?page=${isPopular ? 'popular' : 'reviewed'}&special=${isSpecial.toString()}';
  static String getItemCampaignRoute({bool isJustForYou = false}) => itemCampaign + (isJustForYou ? '?just-for-you=${isJustForYou.toString()}' : '');
  static String getSupportRoute() => support;
  static String getReviewRoute() => rateReview;
  static String getUpdateRoute(bool isUpdate) => '$update?update=${isUpdate.toString()}';
  static String getCartRoute() => cart;
  static String getAddAddressRoute(bool fromCheckout, bool fromRide, int? zoneId, {bool isNavbar = false}) => '$addAddress?page=${fromCheckout ? 'checkout' : 'address'}&ride=$fromRide&zone_id=$zoneId&navbar=$isNavbar';
  static String getEditAddressRoute(AddressModel? address, {bool fromGuest = false}) {
    String data = 'null';
    if(address != null) {
      data = base64Url.encode(utf8.encode(jsonEncode(address.toJson())));
    }
    return '$editAddress?data=$data&from-guest=$fromGuest';
  }
  static String getStoreReviewRoute(int? storeID, String? storeName, Store store) {
    String data = base64Url.encode(utf8.encode(jsonEncode(store.toJson())));
    return '$storeReview?storeID=$storeID&storeName=$storeName&store=$data';
  }
  static String getAllStoreRoute(String page, {bool isNearbyStore = false}) => '$allStores?page=$page${isNearbyStore ? '&nearby=${isNearbyStore.toString()}' : ''}';
  static String getItemImagesRoute(Item item,[int? initIndex]) {
    String data = base64Url.encode(utf8.encode(jsonEncode(item.toJson())));
    return '$itemImages?item=$data&initIndex=$initIndex';
  }
  static String getParcelCategoryRoute() => parcelCategory;
  static String getParcelLocationRoute(ParcelCategoryModel category) {
    String data = base64Url.encode(utf8.encode(jsonEncode(category.toJson())));
    return '$parcelLocation?data=$data';
  }
  static String getParcelRequestRoute(ParcelCategoryModel category, AddressModel pickupAddress, AddressModel destinationAddress) {
    String category0 = base64Url.encode(utf8.encode(jsonEncode(category.toJson())));
    String pickedUpAddress = base64Url.encode(utf8.encode(jsonEncode(pickupAddress.toJson())));
    String destinationAddress0 = base64Url.encode(utf8.encode(jsonEncode(destinationAddress.toJson())));
    return '$parcelRequest?category=$category0&picked=$pickedUpAddress&destination=$destinationAddress0';
  }
  static String getSearchStoreItemRoute(int? storeID) => '$searchStoreItem?id=$storeID';
  static String getOrderRoute() => order;
  static String getItemDetailsRoute(int? itemID, bool isRestaurant) => '$itemDetails?id=$itemID&page=${isRestaurant ? 'restaurant' : 'item'}';
  static String getWalletRoute({String? fundStatus, String? token,  bool fromNotification = false}) => '$wallet?payment_status=$fundStatus&token=$token&from_notification=$fromNotification';
  static String getLoyaltyRoute({bool fromNotification = false}) => '$loyalty?from_notification=$fromNotification';
  static String getReferAndEarnRoute() => referAndEarn;
  static String getChatRoute({required NotificationBodyModel? notificationBody, User? user, int? conversationID, int? index, bool? fromNotification, OrderChatModel? orderChatModel}) {
    String notificationBody0 = 'null';
    if(notificationBody != null) {
      notificationBody0 = base64Encode(utf8.encode(jsonEncode(notificationBody.toJson())));
    }
    String orderChat = 'null';
    if(orderChatModel != null) {
      orderChat = base64Encode(utf8.encode(jsonEncode(orderChatModel.toJson())));
    }
    String user0 = 'null';
    if(user != null) {
      user0 = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }
    return '$messages?notification=$notificationBody0&user=$user0&conversation_id=$conversationID&index=$index&from=${fromNotification.toString()}&order-chat=$orderChat';
  }
  static String getConversationRoute() => conversation;
  static String getRestaurantRegistrationRoute() => restaurantRegistration;
  static String getDeliverymanRegistrationRoute() => deliveryManRegistration;
  static String getRefundRequestRoute(String orderID) => '$refund?id=$orderID';

  static String getOfflinePaymentScreen({
    required PlaceOrderBodyModel placeOrderBody, required int? zoneId, required double total,
    required double? maxCodOrderAmount, required bool fromCart, required bool? isCodActive,
    required bool forParcel,
  }) {
    List<int> encoded = utf8.encode(jsonEncode(placeOrderBody.toJson()));
    String data = base64Encode(encoded);
    return '$offlinePaymentScreen?order_body=$data&zone_id=$zoneId&total=$total&max_cod_amount=$maxCodOrderAmount&from_cart=$fromCart&cod_active=$isCodActive&for_parcel=$forParcel';
  }
  static String getFlashSaleDetailsScreen(int id) => '$flashSaleDetailsScreen?id=$id';
  static String getGuestTrackOrderScreen(String orderId, String number) => '$guestTrackOrderScreen?order_id=$orderId&number=$number';
  static String getOffersScreen() => offers;
  static String getFavouriteScreen([bool canBack = false]) => "$favourite?can_back=${jsonEncode(canBack)}";
  static String getBrandsScreen() => brands;
  static String getBrandsItemScreen(int brandId, String brandName) => '$brandsItemScreen?brandId=$brandId&brandName=$brandName';

  static String getSubscriptionSuccessRoute({String? status, required bool fromSubscription, int? storeId}) => '$subscriptionSuccess?flag=$status&from_subscription=$fromSubscription&store_id=$storeId';
  static String getSubscriptionPaymentRoute({required int? storeId, required int? packageId}) => '$subscriptionPayment?store-id=$storeId&package-id=$packageId';
  static String getNewUserSetupScreen({required String name, required String loginType, required String? phone, required String? email}) {
    return '$newUserSetupScreen?name=$name&login_type=$loginType&phone=$phone&email=$email';
  }

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => getRoute(DashboardScreen(pageIndex: 0, fromSplash: Get.parameters['from-splash'] == 'true'))),
    GetPage(name: splash, page: () {
      NotificationBodyModel? data;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(body: data);
    }),
    GetPage(name: language, page: () => ChooseLanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: onBoarding, page: () => const OnBoardingScreen()),
    GetPage(name: signIn, page: () => SignInScreen(
      exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash || Get.parameters['page'] == onBoarding,
      backFromThis: Get.parameters['page'] != splash && Get.parameters['page'] != onBoarding,
      fromNotification: Get.parameters['page'] == notification, fromResetPassword: Get.parameters['page'] == resetPassword,
    )),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    /*GetPage(name: verification, page: () {
      List<int> decode = base64Decode(Get.parameters['pass']!.replaceAll(' ', '+'));
      String data = utf8.decode(decode);
      String? session;
      if(Get.parameters['session'] != null && Get.parameters['session'] != 'null') {
        session = utf8.decode(base64Url.decode(Get.parameters['session'] ?? ''));
      }
      return VerificationScreen(
        number: Get.parameters['number'], fromSignUp: Get.parameters['page'] == signUp, token: Get.parameters['token'],
        password: data, firebaseSession: session,
      );
    }),*/

    GetPage(name: verification, page: () {
      String? pass;
      if(Get.parameters['pass'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['pass']!.replaceAll(' ', '+'));
        pass = utf8.decode(decode);
      }
      String? session;
      if(Get.parameters['session'] != null && Get.parameters['session'] != 'null') {
        session = utf8.decode(base64Url.decode(Get.parameters['session'] ?? ''));
      }
      UpdateUserModel? userModel;
      if(Get.parameters['user_model'] != null && Get.parameters['user_model'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['user_model'] != null ? Get.parameters['user_model']!.replaceAll(' ', '+') : '');
        userModel = UpdateUserModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return VerificationScreen(
        number: Get.parameters['number'] != '' && Get.parameters['number'] != 'null' ? Get.parameters['number'] : null,
        fromSignUp: Get.parameters['page'] == signUp, token: Get.parameters['token'], password: pass,
        email: Get.parameters['email'] != '' && Get.parameters['email'] != 'null' ? Get.parameters['email'] : null, loginType: Get.parameters['login_type']!,
        firebaseSession: session, fromForgetPassword: Get.parameters['page'] == forgotPassword, userModel: userModel,
      );
    }),

    GetPage(name: accessLocation, page: () => AccessLocationScreen(
      fromSignUp: Get.parameters['page'] == signUp, fromHome: Get.parameters['page'] == 'home', route: null,
    )),
    GetPage(name: pickMap, page: () {
      PickMapScreen? pickMapScreen = Get.arguments;
      bool fromAddress = Get.parameters['page'] == 'add-address';
      return ((Get.parameters['page'] == 'parcel' && pickMapScreen == null) || (fromAddress && pickMapScreen == null))
          ? const NotFound() : pickMapScreen ?? PickMapScreen(
        fromSignUp: Get.parameters['page'] == signUp, fromAddAddress: fromAddress, route: Get.parameters['page'],
        canRoute: Get.parameters['route'] == 'true',
      );
    }),
    GetPage(name: interest, page: () => const InterestScreen()),
    GetPage(name: main, page: () => getRoute(DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    ))),

    /*GetPage(name: forgotPassword, page: () {
      SocialLogInBody? data;
      if(Get.parameters['page'] == 'social-login') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = SocialLogInBody.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return ForgetPassScreen(fromSocialLogin: Get.parameters['page'] == 'social-login', socialLogInBody: data);
    }),*/

    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),

    GetPage(name: resetPassword, page: () => NewPassScreen(
      resetToken: Get.parameters['token'], number: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: search, page: () => getRoute(SearchScreen(queryText: Get.parameters['query']))),
    GetPage(name: store, page: () {
      return getRoute(Get.arguments ?? StoreScreen(
        store: Store(id: Get.parameters['id'] != 'null' && Get.parameters['id'] != null ? int.parse(Get.parameters['id']!) : null),
        fromModule: Get.parameters['page'] != null && Get.parameters['page'] == 'module',
        slug: Get.parameters['slug'] ?? '',
      ), byPuss: Get.parameters['slug']?.isNotEmpty ?? false);
    }),
    GetPage(name: orderDetails, page: () {
      return getRoute(Get.arguments ?? OrderDetailsScreen(
        orderId: int.parse(Get.parameters['id'] ?? '0'), orderModel: null, fromNotification: Get.parameters['from'] == 'true',
        fromOfflinePayment: Get.parameters['from_offline'] == 'true', contactNumber: Get.parameters['contact'],
      ),);
    }),
    GetPage(name: profile, page: () => getRoute(const ProfileScreen())),
    GetPage(name: updateProfile, page: () => getRoute(const UpdateProfileScreen())),
    GetPage(name: coupon, page: () => getRoute(const CouponScreen())),
    GetPage(name: notification, page: () => getRoute(NotificationScreen(fromNotification: Get.parameters['from'] == 'true'))),
    GetPage(name: map, page: () {
      List<int> decode = base64Decode(Get.parameters['address']!.replaceAll(' ', '+'));
      AddressModel data = AddressModel.fromJson(jsonDecode(utf8.decode(decode)));
      return getRoute(MapScreen(fromStore: Get.parameters['page'] == 'store', address: data, isFood: Get.parameters['module'] == 'true', storeName: Get.parameters['store-name'] ?? ''));
    }),
    GetPage(name: address, page: () => getRoute(const AddressScreen())),
    GetPage(name: orderSuccess, page: () => getRoute(OrderSuccessfulScreen(
      orderID: Get.parameters['id'],
      contactPersonNumber: Get.parameters['contact_number'] != null && Get.parameters['contact_number'] != 'null'
          ? Get.parameters['contact_number']
          : AuthHelper.isGuestLoggedIn() ? Get.find<AuthController>().getGuestNumber() : null,
      createAccount: Get.parameters['create_account'] == 'true', guestId: Get.parameters['guest_id'] ?? '',
    ),
    )),
    GetPage(name: payment, page: () {
      OrderModel order = OrderModel(
        id: int.parse(Get.parameters['id']!), orderType: Get.parameters['type'], userId: int.parse(Get.parameters['user']!),
        orderAmount: double.parse(Get.parameters['amount']!),
      );
      bool isCodActive = Get.parameters['cod-delivery'] == 'true';
      String addFundUrl = '';
      String subscriptionUrl = '';
      String paymentMethod = Get.parameters['payment-method']!;
      if(Get.parameters['add-fund-url'] != null && Get.parameters['add-fund-url'] != 'null'){
        addFundUrl = Get.parameters['add-fund-url']!;
      }
      if(Get.parameters['subscription-url'] != null && Get.parameters['subscription-url'] != 'null'){
        subscriptionUrl = Get.parameters['subscription-url']!;
      }
      String guestId = Get.parameters['guest-id']!;
      String number = Get.parameters['number']!;
      int? storeId = (Get.parameters['store_id'] != null && Get.parameters['store_id'] != 'null') ? int.parse(Get.parameters['store_id']!) : null;
      bool createAccount = Get.parameters['create_account'] == 'true';
      int? createUserId = Get.parameters['create_user_id'] != null && Get.parameters['create_user_id'] != 'null' ? int.parse(Get.parameters['create_user_id']!) : null;
      return getRoute(AppConstants.payInWevView ? PaymentWebViewScreen(
        orderModel: order, isCashOnDelivery: isCodActive, addFundUrl: addFundUrl, paymentMethod: paymentMethod, guestId: guestId,
        contactNumber: number, subscriptionUrl: subscriptionUrl, storeId: storeId, createAccount: createAccount,
      ) : PaymentScreen(
        orderModel: order, isCashOnDelivery: isCodActive, addFundUrl: addFundUrl, paymentMethod: paymentMethod, guestId: guestId,
        contactNumber: number, subscriptionUrl: subscriptionUrl, storeId: storeId, createAccount: createAccount, createUserId: createUserId,
      ));
    }),
    GetPage(name: checkout, page: () {
      CheckoutScreen? checkoutScreen = Get.arguments;
      bool fromCart = Get.parameters['page'] == 'cart';
      bool requestPrescription = Get.parameters['page'] == 'request_prescription';
      return getRoute(checkoutScreen ?? (!fromCart && !requestPrescription ? const NotFound() : CheckoutScreen(
        cartList: null, fromCart: Get.parameters['page'] == 'cart', storeId: Get.parameters['store-id'] != 'null' ? int.parse(Get.parameters['store-id']!) : null,
      )));
    }),
    GetPage(name: orderTracking, page: () => getRoute(OrderTrackingScreen(orderID: Get.parameters['id'], contactNumber: Get.parameters['number'],))),
    GetPage(name: basicCampaign, page: () {
      BasicCampaignModel data = BasicCampaignModel.fromJson(jsonDecode(utf8.decode(base64Decode(Get.parameters['data']!.replaceAll(' ', '+')))));
      return getRoute(CampaignScreen(campaign: data));
    }),
    GetPage(name: html, page: () => HtmlViewerScreen(
      htmlType: Get.parameters['page'] == 'terms-and-condition' ? HtmlType.termsAndCondition
          : Get.parameters['page'] == 'privacy-policy' ? HtmlType.privacyPolicy
          : Get.parameters['page'] == 'shipping-policy' ? HtmlType.shippingPolicy
          : Get.parameters['page'] == 'cancellation-policy' ? HtmlType.cancellation
          : Get.parameters['page'] == 'refund-policy' ? HtmlType.refund : HtmlType.aboutUs,
    )),
    GetPage(name: categories, page: () => getRoute(const CategoryScreen())),
    GetPage(name: categoryItem, page: () {
      List<int> decode = base64Decode(Get.parameters['name']!.replaceAll(' ', '+'));
      String data = utf8.decode(decode);
      return getRoute(CategoryItemScreen(categoryID: Get.parameters['id'], categoryName: data));
    }),
    GetPage(name: popularItems, page: () => getRoute(PopularItemScreen(isPopular: Get.parameters['page'] == 'popular', isSpecial: Get.parameters['special'] == 'true'))),
    GetPage(name: itemCampaign, page: () => getRoute(ItemCampaignScreen(isJustForYou: Get.parameters['just-for-you'] == 'true'))),
    GetPage(name: support, page: () => const SupportScreen()),
    GetPage(name: update, page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: cart, page: () => getRoute(const CartScreen(fromNav: false))),
    GetPage(name: addAddress, page: () => getRoute(AddAddressScreen(
      fromCheckout: Get.parameters['page'] == 'checkout', fromRide: Get.parameters['ride'] == 'true', zoneId: int.parse(Get.parameters['zone_id']!),
      fromNavBar: Get.parameters['navbar'] == 'true',
    ))),
    GetPage(name: editAddress, page: () {
      AddressModel? data;
      if(Get.parameters['data'] != 'null') {
      data = AddressModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['data']!.replaceAll(' ', '+')))));
      }
      return getRoute(AddAddressScreen(
        fromCheckout: false, fromRide: false,
        address: data, forGuest: Get.parameters['from-guest'] == 'true',
      ));
    }),
    GetPage(name: rateReview, page: () => getRoute(Get.arguments ?? const NotFound())),
    GetPage(name: storeReview, page: () => getRoute(ReviewScreen(storeID: Get.parameters['storeID'], storeName: Get.parameters['storeName'], store: Store.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['store']!.replaceAll(' ', '+')))))))),
    GetPage(name: allStores, page: () => getRoute(AllStoreScreen(
      isPopular: Get.parameters['page'] == 'popular', isFeatured: Get.parameters['page'] == 'featured',
      isTopOfferStore: Get.parameters['page'] == 'topOffer', isNearbyStore: Get.parameters['nearby'] == 'true',
    ))),
    GetPage(name: itemImages, page: () => getRoute(ImageViewerScreen(
      item: Item.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['item']!.replaceAll(' ', '+'))))),
      initIndex: int.tryParse(Get.parameters['initIndex'] ?? "0") ?? 0,
    ))),
    GetPage(name: parcelCategory, page: () => getRoute(const ParcelCategoryScreen())),
    GetPage(name: parcelLocation, page: () => getRoute(ParcelLocationScreen(
      category: ParcelCategoryModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['data']!.replaceAll(' ', '+'))))),
    ))),
    GetPage(name: parcelRequest, page: () => getRoute(ParcelRequestScreen(
      parcelCategory: ParcelCategoryModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['category']!.replaceAll(' ', '+'))))),
      pickedUpAddress: AddressModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['picked']!.replaceAll(' ', '+'))))),
      destinationAddress: AddressModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['destination']!.replaceAll(' ', '+'))))),
    ))),
    GetPage(name: searchStoreItem, page: () => getRoute(StoreItemSearchScreen(storeID: Get.parameters['id']))),
    GetPage(name: order, page: () => getRoute(const OrderScreen())),
    GetPage(name: itemDetails, page: () => getRoute(Get.arguments ?? ItemDetailsScreen(item: Item(id: int.parse(Get.parameters['id']!)), inStorePage: Get.parameters['page'] == 'restaurant'))),
    GetPage(name: wallet, page: () {
      return getRoute(WalletScreen(
        fundStatus: Get.parameters['flag'] ?? Get.parameters['payment_status'],
        token: Get.parameters['token'],
        fromNotification: Get.parameters['from_notification'] == 'true',
      ));
    }),
    GetPage(name: loyalty, page: () => getRoute(LoyaltyScreen(fromNotification: Get.parameters['from_notification'] == 'true'))),
    GetPage(name: referAndEarn, page: () => getRoute(const ReferAndEarnScreen())),
    GetPage(name: messages, page: () {
      NotificationBodyModel? notificationBody;
      if(Get.parameters['notification'] != 'null') {
        notificationBody = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification']!.replaceAll(' ', '+')))));
      }
      OrderChatModel? orderChat;
      if(Get.parameters['order-chat'] != 'null') {
        orderChat = OrderChatModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['order-chat']!.replaceAll(' ', '+')))));
      }
      User? user;
      if(Get.parameters['user'] != 'null') {
        user = User.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))));
      }
      return getRoute(ChatScreen(
        notificationBody: notificationBody, user: user, index: Get.parameters['index'] != 'null' ? int.parse(Get.parameters['index']!) : null, fromNotification: Get.parameters['from'] == 'true',
        conversationID: (Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null') ? int.parse(Get.parameters['conversation_id']!) : null,
        orderChatModel: orderChat,
      ));
    }),
    GetPage(name: conversation, page: () => const ConversationScreen()),
    GetPage(name: restaurantRegistration, page: () => const StoreRegistrationScreen()),
    GetPage(name: deliveryManRegistration, page: () => const DeliveryManRegistrationScreen()),
    GetPage(name: refund, page: () => RefundRequestScreen(orderId: Get.parameters['id'])),
    GetPage(name: offlinePaymentScreen, page: () {
      List<int> decode = base64Decode(Get.parameters['order_body']!.replaceAll(' ', '+'));
      PlaceOrderBodyModel orderBody = PlaceOrderBodyModel.fromJson(jsonDecode(utf8.decode(decode)));

      return OfflinePaymentScreen(
        placeOrderBody: orderBody, zoneId: int.parse(Get.parameters['zone_id']!),
        total: double.parse(Get.parameters['total']!),
        maxCodOrderAmount: (Get.parameters['max_cod_amount'] != null && Get.parameters['max_cod_amount'] != 'null') ? double.parse(Get.parameters['max_cod_amount']!) : null,
        fromCart: Get.parameters['from_cart'] == 'true', isCashOnDeliveryActive: Get.parameters['cod_active'] == 'true', forParcel : Get.parameters['for_parcel'] == 'true',
      );
    },
    ),
    GetPage(name: flashSaleDetailsScreen, page: () => FlashSaleDetailsScreen(id: int.parse(Get.parameters['id']!))),
    GetPage(name: guestTrackOrderScreen, page: () => GuestTrackOrderScreen(
      orderId: Get.parameters['order_id']!, number: Get.parameters['number']!,
    )),
    GetPage(name: offers, page: () => const OffersItemScreen()),
    GetPage(name: favourite, page: () => FavouriteScreen(canBack: jsonDecode(Get.parameters['can_back'] ?? "false"))),
    GetPage(name: brands, page: () => const BrandsScreen()),
    GetPage(name: brandsItemScreen, page: () => BrandsItemScreen(
      brandId: int.parse(Get.parameters['brandId']!), brandName: Get.parameters['brandName']!,
    )),

    GetPage(name: subscriptionSuccess, page: () => SubscriptionSuccessOrFailedScreen(success: Get.parameters['flag'] == 'success', fromSubscription: Get.parameters['from_subscription'] == 'true', storeId: (Get.parameters['store_id'] != null && Get.parameters['store_id'] != 'null') ? int.parse(Get.parameters['store_id']!) : null)),
    GetPage(name: subscriptionPayment, page: () => SubscriptionPaymentScreen(storeId: int.parse(Get.parameters['store-id']!), packageId: int.parse(Get.parameters['package-id']!))),
    GetPage(name: newUserSetupScreen, page: () => NewUserSetupScreen(
      name: Get.parameters['name']!, loginType: Get.parameters['login_type']!,
      phone: Get.parameters['phone'] != '' && Get.parameters['phone'] != 'null' ? Get.parameters['phone']!.replaceAll(' ', '+') : null,
      email: Get.parameters['email'] != '' && Get.parameters['email'] != 'null' ? Get.parameters['email']!.replaceAll(' ', '+') : null,
    )),
  ];

  static Widget getRoute(Widget navigateTo, {AccessLocationScreen? locationScreen, bool byPuss = false}) {
    double? minimumVersion = 0;
    if(GetPlatform.isAndroid) {
      minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
    }else if(GetPlatform.isIOS) {
      minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionIos;
    }
    return (AppConstants.appVersion < minimumVersion! && !GetPlatform.isWeb)  ? const UpdateScreen(isUpdate: true)
        : Get.find<SplashController>().configModel!.maintenanceMode! ? const UpdateScreen(isUpdate: false)
        : (AddressHelper.getUserAddressFromSharedPref() == null && !byPuss)
        ? AccessLocationScreen(fromSignUp: false, fromHome: false, route: Get.currentRoute) : navigateTo;
  }


}