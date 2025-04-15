import 'package:flutter/foundation.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/veg_filter_widget.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_image.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryItemScreen({super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int index_category = -1;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);

    Get.find<CategoryController>().getCategoryStoreList(
      widget.categoryID, 1, Get.find<CategoryController>().type, false,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryItemList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex < 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels == storeScrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryStoreList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex < 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    });
  }

  void backMethod(CategoryController catController) {
    if (catController.isSearching) {
      catController.toggleSearch();
    } else if (index_category != -1) {
      index_category = -1;
      catController.setSubCategoryIndex(index_category, widget.categoryID);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item>? item;
      List<Store>? stores;
      if(catController.isSearching ? catController.searchItemList != null : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if(catController.isSearching ? catController.searchStoreList != null : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => backMethod(catController),
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : AppBar(
            backgroundColor: Theme.of(context).cardColor,
            surfaceTintColor: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).disabledColor.withOpacity(0.5),
            elevation: 2,
            title: catController.isSearching ? SizedBox(
              height: 45,
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    borderSide: BorderSide(color: Theme.of(context).disabledColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    borderSide: BorderSide(color: Theme.of(context).disabledColor),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => catController.toggleSearch(),
                    icon: Icon(
                      catController.isSearching ? Icons.close_sharp : Icons.search,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                onSubmitted: (String query) {
                  catController.searchData(
                    query, catController.subCategoryIndex < 0 ? widget.categoryID
                      : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                    catController.type,
                  );
                }
              ),
            ) : Text(widget.categoryName, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => backMethod(catController),
            ),
            actions: [

              !catController.isSearching ? IconButton(
                onPressed: () => catController.toggleSearch(),
                icon: Icon(
                  catController.isSearching ? Icons.close_sharp : Icons.search,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ) : const SizedBox(),

              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
              ),

              VegFilterWidget(type: catController.type, fromAppBar: true, onSelected: (String type) {
                if(catController.isSearching) {
                  catController.searchData(
                    catController.subCategoryIndex < 0 ? widget.categoryID
                        : catController.subCategoryList![catController.subCategoryIndex].id.toString(), '1', type,
                  );
                }else {
                  if(catController.isStore) {
                    catController.getCategoryStoreList(
                      catController.subCategoryIndex < 0 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }else {
                    catController.getCategoryItemList(
                      catController.subCategoryIndex < 0 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }
                }
              }),

              const SizedBox(width: Dimensions.paddingSizeSmall),
            ],
          )),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: ResponsiveHelper.isDesktop(context) ? SingleChildScrollView(
            child: FooterView(
              child: Center(child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(children: [

              Visibility(
                      visible: (catController.subCategoryList != null &&
                          catController.subCategoryList!.isNotEmpty &&
                          !catController.isSearching),
                      maintainState: true,
                      child: Center(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                  height: 120,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: Dimensions.webMaxWidth,
                                  color: Theme.of(context).cardColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeExtraSmall),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      const SizedBox(width: 15),
                                      Align(
                                        child: Builder(
                                          builder: (context) {
                                            bool isHovered = false;
                                            return StatefulBuilder(
                                              builder: (context, setState1) {
                                                return InkWell(
                                                  onHover: (value) => setState1(() => isHovered = value),
                                                  onTap: index_category == -1
                                                      ? null
                                                      : () {
                                                          index_category = -1;
                                                          catController.setSubCategoryIndex(index_category, widget.categoryID);
                                                        },
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.all(
                                                          index_category == -1
                                                              ? Dimensions
                                                                  .paddingSizeExtraSmall
                                                              : Dimensions
                                                                  .paddingSizeSmall),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: index_category == -1
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : context.textTheme
                                                        .bodyLarge!.color!),
                                                                                    borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50))),
                                                      width: 80,
                                                      height: 80,
                                                      child: AnimatedScale(
                                                        duration: const Duration(milliseconds: 300),
                                                        scale: isHovered ? 1.2 : 1,
                                                        child: Text(
                                                          "all".tr,
                                                          textAlign: TextAlign.center,
                                                          style: index_category == -1
                                                              ? TextStyle(
                                                                  color: Theme.of(context)
                                                                      .primaryColor,
                                                                  fontSize: 12)
                                                              : const TextStyle(fontSize: 10),
                                                        ),
                                                      )),
                                                );
                                              }
                                            );
                                          }
                                        ),
                                      ),
                                      ...List.generate(
                                        catController.subCategoryList?.length ?? 0,
                                        (int index) {
                                          bool isHovered = false;
                                          return StatefulBuilder(
                                            builder: (context, setState1) {
                                              return InkWell(
                                                onHover: (value) => setState1(()=> isHovered = value),
                                                  onTap: () {
                                                    setState(() {
                                                      index_category = index;
                                                    });
                                                    catController.setSubCategoryIndex(index, widget.categoryID);
                                                  },
                                                  child: Container(
                                                    // width: 150,
                                                    //height: 100,
                                                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall),
                                                    margin: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(Dimensions.radiusSmall),
                                                      color: index == catController.subCategoryIndex
                                                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                                                          : Colors.transparent,
                                                    ),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          // image
                                                          Expanded(
                                                            flex: 3,
                                                            child: CustomImage(
                                                              isHovered: isHovered,
                                                              image:
                                                                  '${catController.subCategoryList![index].imageFullUrl}',
                                                              placeHolderSize: 50,
                                                              //height: 90,
                                                              //width: 75,
                                                            ),
                                                          ),
                                                                            
                                                                            
                                                          Flexible(
                                                            flex: 1,
                                                            child: Text(
                                                              catController
                                                                  .subCategoryList![
                                                                      index]
                                                                  .name!,
                                                              textAlign: TextAlign
                                                                  .center,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: index ==
                                                                      catController
                                                                          .subCategoryIndex
                                                                  ? robotoMedium.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .paddingSizeSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor)
                                                                  : robotoRegular.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .paddingSizeSmall),
                                                            ),
                                                          ),
                                                        ]),
                                                  ));
                                            }
                                          );
                                        },
                                      ),
                                    ],
                                  ));
                            }
                          )),
                    ),

                  if(!AppConstants.removeStores)
                    Center(child: Container(
                      width: Dimensions.webMaxWidth,
                      color: Theme.of(context).cardColor,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 3,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Theme.of(context).disabledColor,
                        unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        tabs: [
                          Tab(text: 'item'.tr),
                          Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants'.tr : 'stores'.tr),
                        ],
                      ),
                    )),

                  SizedBox(
                    height: 600,
                    child: NotificationListener(
                      onNotification: (dynamic scrollNotification) {
                        if (scrollNotification is ScrollEndNotification) {
                          if((_tabController!.index == 1 && !catController.isStore) || _tabController!.index == 0 && catController.isStore) {
                            catController.setRestaurant(_tabController!.index == 1);
                            if(catController.isSearching) {
                              catController.searchData(
                                catController.searchText, catController.subCategoryIndex < 0 ? widget.categoryID
                                  : catController.subCategoryList![catController.subCategoryIndex].id.toString(), catController.type,
                              );
                            }else {
                              if(_tabController!.index == 1) {
                                catController.getCategoryStoreList(
                                  catController.subCategoryIndex < 0 ? widget.categoryID
                                      : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                  1, catController.type, false,
                                );
                              }else {
                                catController.getCategoryItemList(
                                  catController.subCategoryIndex < 0 ? widget.categoryID
                                      : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                  1, catController.type, false,
                                );
                              }
                            }
                          }
                        }
                        return false;
                      },
                      child: AppConstants.removeStores? SingleChildScrollView(
                        controller: scrollController,
                        child: ItemsView(
                          isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                        ),
                      )
                      : TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            child: ItemsView(
                              isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                            ),
                          ),
                          SingleChildScrollView(
                            controller: storeScrollController,
                            child: ItemsView(
                              isStore: true, items: null, stores: stores,
                              noDataText: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'no_category_restaurant_found'.tr : 'no_category_store_found'.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  catController.isLoading ? Center(child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                  )) : const SizedBox(),

                ]),
              )),
            ),
          ) : SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(children: [
              const SizedBox(height: 10),

              Visibility(
                      visible: (catController.subCategoryList != null &&
                          catController.subCategoryList!.isNotEmpty &&
                          !catController.isSearching),
                      maintainState: true,
                      child: Center(
                          child: Container(
                              height: 120,
                              margin: const EdgeInsets.only(bottom: 10),
                              width: Dimensions.webMaxWidth,
                              color: Theme.of(context).cardColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  const SizedBox(width: 15),
                                  Align(
                                    child: Builder(
                                      builder: (context) {
                                        bool isHovered = false;
                                        return StatefulBuilder(
                                          builder: (context, setState1) {
                                            return InkWell(
                                              onHover: (value) => setState1(() => isHovered = value),
                                              onTap: index_category == -1
                                                  ? null
                                                  : () {
                                                      index_category = -1;
                                                      catController.setSubCategoryIndex(index_category, widget.categoryID);
                                                    },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(
                                                      index_category == -1
                                                          ? Dimensions
                                                              .paddingSizeExtraSmall
                                                          : Dimensions
                                                              .paddingSizeSmall),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: index_category == -1
                                                              ? Theme.of(context)
                                                                  .primaryColor
                                                              : context.textTheme
                                                                  .bodyLarge!.color!),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(50))),
                                                  width: 80,
                                                  height: 80,
                                                  child: AnimatedScale(
                                                    duration: const Duration(milliseconds: 300),
                                                    scale: isHovered ? 1.2 : 1,
                                                    child: Text(
                                                      "all".tr,
                                                      textAlign: TextAlign.center,
                                                      style: index_category == -1
                                                          ? TextStyle(
                                                              color: Theme.of(context)
                                                                  .primaryColor,
                                                              fontSize: 12)
                                                          : const TextStyle(fontSize: 10),
                                                    ),
                                                  )),
                                            );
                                          }
                                        );
                                      }
                                    ),
                                  ),
                                  ...List.generate(
                                    catController.subCategoryList?.length ?? 0,
                                    (int index) {
                                      bool isHovered = false;
                                        return StatefulBuilder(
                                          builder: (context, setState1) {
                                            return InkWell(
                                              onHover: (value) => setState1(()=> isHovered = value),
                                              onTap: () {
                                                setState(() {
                                                  index_category = index;
                                                });
                                                catController.setSubCategoryIndex(index, widget.categoryID);
                                              },
                                              child: Container(
                                                // width: 150,
                                                //height: 100,
                                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall),
                                                margin: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(Dimensions.radiusSmall),
                                                  color: index == catController.subCategoryIndex
                                                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                                                      : Colors.transparent,
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      // image
                                                      Expanded(
                                                        flex: 3,
                                                        child: CustomImage(
                                                          image:
                                                              '${catController.subCategoryList![index].imageFullUrl}',
                                                          placeHolderSize: 50,
                                                          isHovered: isHovered,
                                                          //height: 90,
                                                          //width: 75,
                                                        ),
                                                      ),
                                          
                                          
                                                      Flexible(
                                                        flex: 1,
                                                        child: Text(
                                                          catController
                                                              .subCategoryList![
                                                                  index]
                                                              .name!,
                                                          textAlign: TextAlign
                                                              .center,
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style: index ==
                                                                  catController
                                                                      .subCategoryIndex
                                                              ? robotoMedium.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .paddingSizeSmall,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)
                                                              : robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .paddingSizeSmall),
                                                        ),
                                                      ),
                                                    ]),
                                              ));
                                        }
                                      );
                                    },
                                  ),
                                ],
                              ))),
                    ),

              if(!AppConstants.removeStores)
                Center(child: Container(
                  width: Dimensions.webMaxWidth,
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                    tabs: [
                      Tab(text: 'item'.tr),
                      Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants'.tr : 'stores'.tr),
                    ],
                  ),
                )),


              Expanded(child: NotificationListener(
                onNotification: (dynamic scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if((_tabController!.index == 1 && !catController.isStore) || _tabController!.index == 0 && catController.isStore) {
                      catController.setRestaurant(_tabController!.index == 1);
                      if(catController.isSearching) {
                        catController.searchData(
                          catController.searchText, catController.subCategoryIndex < 0 ? widget.categoryID
                            : catController.subCategoryList![catController.subCategoryIndex].id.toString(), catController.type,
                        );
                      }else {
                        if(_tabController!.index == 1) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex < 0 ? widget.categoryID
                                : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                            1, catController.type, false,
                          );
                        }else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex < 0 ? widget.categoryID
                                : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                            1, catController.type, false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: AppConstants.removeStores? SingleChildScrollView(
                controller: scrollController,
                child: ItemsView(
                  isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                ),
              )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: ItemsView(
                        isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                      ),
                    ),
                    SingleChildScrollView(
                      controller: storeScrollController,
                      child: ItemsView(
                        isStore: true, items: null, stores: stores,
                        noDataText: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'no_category_restaurant_found'.tr : 'no_category_store_found'.tr,
                      ),
                    ),
                  ],
                ),
              )),

              catController.isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              )) : const SizedBox(),

            ]),
          ),
        ),
      );
    });
  }
}
