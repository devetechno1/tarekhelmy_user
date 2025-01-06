import 'package:get/get.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/common_condition_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/item/domain/repositories/item_repository_interface.dart';
import 'package:sixam_mart/features/item/domain/services/item_service_interface.dart';
import 'package:sixam_mart/helper/module_helper.dart';

class ItemService implements ItemServiceInterface {
  final ItemRepositoryInterface itemRepositoryInterface;
  ItemService({required this.itemRepositoryInterface});

  @override
  Future<List<Item>?> getPopularItemList(String type, DataSourceEnum? source) async {
    return await itemRepositoryInterface.getList(type: type, isPopularItem: true, source: source);
  }

  @override
  Future<ItemModel?> getReviewedItemList(String type, DataSourceEnum? source) async {
    return await itemRepositoryInterface.getList(type: type, isReviewedItem: true, source: source);
  }

  @override
  Future<ItemModel?> getFeaturedCategoriesItemList(DataSourceEnum? source) async {
    return await itemRepositoryInterface.getList(isFeaturedCategoryItems: true, source: source);
  }

  @override
  Future<List<Item>?> getRecommendedItemList(String type, DataSourceEnum? source) async {
    return await itemRepositoryInterface.getList(type: type, isRecommendedItems: true, source: source);
  }

  @override
  Future<List<Item>?> getDiscountedItemList(String type, DataSourceEnum? source) async {
    return await itemRepositoryInterface.getList(isDiscountedItems: true, type: type, source: source);
  }

  @override
  Future<Item?> getItemDetails(int? itemID) async {
    return await itemRepositoryInterface.get(itemID.toString());
  }

  @override
  Future<BasicMedicineModel?> getBasicMedicine(DataSourceEnum source) async {
    return await itemRepositoryInterface.getBasicMedicine(source);
  }

  @override
  Future<List<CommonConditionModel>?> getCommonConditions() async {
    return await itemRepositoryInterface.getList(isCommonConditions: true);
  }

  @override
  Future<List<Item>?> getConditionsWiseItems(int id) async {
    return await itemRepositoryInterface.get(id.toString(), isConditionWiseItem: true);
  }

  @override
  List<bool> initializeCartAddonActiveList(List<AddOn>? addOnIds, List<AddOns>? addOns) {
    List<int?> addOnIdList = [];
    List<bool> addOnActiveList = [];
    for (var addOnId in addOnIds!) {
      addOnIdList.add(addOnId.id);
    }
    for (var addOn in addOns!) {
      if(addOnIdList.contains(addOn.id)) {
        addOnActiveList.add(true);
      }else {
        addOnActiveList.add(false);
      }
    }
    return addOnActiveList;
  }

  @override
  List<int?> initializeCartAddonsQtyList(List<AddOn>? addOnIds, List<AddOns>? addOns) {
    List<int?> addOnIdList = [];
    List<int?> addOnQtyList = [];
    for (var addOnId in addOnIds!) {
      addOnIdList.add(addOnId.id);
    }
    for (var addOn in addOns!) {
      if(addOnIdList.contains(addOn.id)) {
        addOnQtyList.add(addOnIds[addOnIdList.indexOf(addOn.id)].quantity);
      }else {
        addOnQtyList.add(1);
      }
    }
    return addOnQtyList;
  }

  @override
  List<bool> collapseVariation(List<FoodVariation>? foodVariations) {
    List<bool> collapseVariation = [];
    for(int index=0; index<foodVariations!.length; index++){
      collapseVariation.add(true);
    }
    return collapseVariation;
  }

  @override
  List<int> initializeCartVariationIndexes(List<Variation>? variation, List<ChoiceOptions>? choiceOptions) {
    List<int> variationIndex = [];
    List<String> variationTypes = [];
    if(variation!.isNotEmpty && variation[0].type != null) {
      variationTypes.addAll(variation[0].type!.split('-'));
    }
    int varIndex = 0;
    for (var choiceOption in choiceOptions!) {
      for(int index=0; index<choiceOption.options!.length; index++) {
        if(choiceOption.options![index].trim().replaceAll(' ', '') == variationTypes[varIndex].trim()) {
          variationIndex.add(index);
          break;
        }
      }
      varIndex++;
    }
    return variationIndex;
  }

  @override
  List<List<bool?>> initializeSelectedVariation(List<FoodVariation>? foodVariations) {
    List<List<bool?>> selectedVariations = [];
    for(int index=0; index<foodVariations!.length; index++) {
      selectedVariations.add([]);
      for(int i=0; i < foodVariations[index].variationValues!.length; i++) {
        selectedVariations[index].add(false);
      }
    }
    return selectedVariations;
  }

  @override
  List<bool> initializeCollapseVariation(List<FoodVariation>? foodVariations) {
    List<bool> collapseVariation = [];
    for(int index=0; index<foodVariations!.length; index++) {
      collapseVariation.add(true);
    }
    return collapseVariation;
  }

  @override
  List<int> initializeVariationIndexes(List<ChoiceOptions>? choiceOptions) {
    List<int> variationIndex = [];
    for(int i=0; i<choiceOptions!.length; i++) {
      variationIndex.add(0);
    }
    return variationIndex;
  }

  @override
  List<bool> initializeAddonActiveList(List<AddOns>? addOns) {
    List<bool> addOnActiveList = [];
    for(int i=0; i<addOns!.length; i++) {
      addOnActiveList.add(false);
    }
    return addOnActiveList;
  }

  @override
  List<int> initializeAddonQtyList(List<AddOns>? addOns) {
    List<int> addOnQtyList = [];
    for(int i=0; i<addOns!.length; i++) {
      addOnQtyList.add(1);
    }
    return addOnQtyList;
  }

  @override
  Future<String> prepareVariationType(List<ChoiceOptions>? choiceOptions, List<int>? variationIndex) async{
    String variationType = '';
    if(!ModuleHelper.getModuleConfig(ModuleHelper.getModule() != null ? ModuleHelper.getModule()!.moduleType : ModuleHelper.getCacheModule()!.moduleType).newVariation!){
      List<String> variationList = [];
      for (int index = 0; index < choiceOptions!.length; index++) {
        variationList.add(choiceOptions[index].options![variationIndex![index]].replaceAll(' ', ''));
      }
      bool isFirst = true;
      for (var variation in variationList) {
        if (isFirst) {
          variationType = '$variationType$variation';
          isFirst = false;
        } else {
          variationType = '$variationType-$variation';
        }
      }
    }
    return variationType;
  }

  @override
  int setAddOnQuantity(bool isIncrement, int addOnQty) {
    int qty = addOnQty;
    if (isIncrement) {
      qty = qty + 1;
    } else {
      qty = qty - 1;
    }
    return qty;
  }

  @override
  Future<int> setQuantity(bool isIncrement, bool moduleStock, int? stock, int qty, int? quantityLimit, {bool getxSnackBar = false}) async{
    int quantity = qty;
    if (isIncrement) {
      if(moduleStock && quantity >= stock!) {
        showCustomSnackBar('out_of_stock'.tr);
      }else {
        if(quantityLimit != null ){
          if(quantity >= quantityLimit && quantityLimit != 0) {
            showCustomSnackBar('${'maximum_quantity_limit'.tr} $quantityLimit', getXSnackBar: getxSnackBar);
          } else {
            quantity = quantity + 1;
          }
        }else {
          quantity = quantity + 1;
        }
      }
    } else {
      quantity = quantity - 1;
    }
    return quantity;
  }

  @override
  List<List<bool?>> setNewCartVariationIndex(int index, int i, List<FoodVariation>? foodVariations, List<List<bool?>> selectedVariations) {
    List<List<bool?>> resultVariations = selectedVariations;
    if(!foodVariations![index].multiSelect!) {
      for(int j = 0; j < resultVariations[index].length; j++) {
        if(foodVariations[index].required!){
          resultVariations[index][j] = j == i;
        }else{
          if(resultVariations[index][j]!){
            resultVariations[index][j] = false;
          }else{
            resultVariations[index][j] = j == i;
          }
        }
      }
    } else {
      if(!resultVariations[index][i]! && selectedVariationLength(resultVariations, index) >= foodVariations[index].max!) {
        showCustomSnackBar(
          '${'maximum_variation_for'.tr} ${foodVariations[index].name} ${'is'.tr} ${foodVariations[index].max}',
          getXSnackBar: true,
        );
      }else {
        resultVariations[index][i] = !resultVariations[index][i]!;
      }
    }
    return resultVariations;
  }

  @override
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    int length = 0;
    for(bool? isSelected in selectedVariations[index]) {
      if(isSelected!) {
        length++;
      }
    }
    return length;
  }

  @override
  double? getStartingPrice(Item item) {
    double? startingPrice = 0;
    if (item.choiceOptions != null && item.choiceOptions!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in item.variations!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
    } else {
      startingPrice = item.price;
    }
    return startingPrice;
  }

  @override
  Future<int> isExistInCartForBottomSheet(List<CartModel> cartList, int? itemId, int? cartIndex, List<List<bool?>>? variations) async{
    for(int index=0; index<cartList.length; index++) {
      if(cartList[index].item!.id == itemId) {
        if((index == cartIndex)) {
          return -1;
        }else {
          if(variations != null && variations.isNotEmpty) {
            bool same = false;
            for(int i=0; i<variations.length; i++) {
              for(int j=0; j<variations[i].length; j++) {
                if(variations[i][j] == cartList[index].foodVariations![i][j]) {
                  same = true;
                } else {
                  same = false;
                  break;
                }

              }
              if(!same) {
                break;
              }
            }
            if(!same) {
              continue;
            }
            if(same) {
              return index;
            } else {
              return -1;
            }
          } else {
            return index;
          }
        }
      }
    }
    return -1;
  }

}