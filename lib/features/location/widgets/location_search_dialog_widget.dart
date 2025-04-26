import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSearchDialogWidget extends StatefulWidget {
  final GoogleMapController? mapController;
  final bool? isPickedUp;
  final bool isFrom;
  const LocationSearchDialogWidget({super.key, required this.mapController, this.isPickedUp, this.isFrom = false});

  @override
  State<LocationSearchDialogWidget> createState() => _LocationSearchDialogWidgetState();
}

class _LocationSearchDialogWidgetState extends State<LocationSearchDialogWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      margin: EdgeInsets.only(
        top: ResponsiveHelper.isDesktop(context) ? 180 : 0,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: SizedBox(width: ResponsiveHelper.isDesktop(context) ? 600 : Dimensions.webMaxWidth, child: TypeAheadField(
          controller: controller,
          suggestionsCallback: (pattern) async {
            return await Get.find<LocationController>().searchLocation(context, pattern);
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'search_location'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                ),
                filled: true, fillColor: Theme.of(context).cardColor,
              ),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
              ),
            );
          },
          itemBuilder: (context, PredictionModel suggestion) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [
                const Icon(Icons.location_on),
                Expanded(
                  child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                  )),
                ),
              ]),
            );
          },
          onSelected: (PredictionModel suggestion) {
            if(widget.isPickedUp == null) {
              Get.find<LocationController>().setLocation(suggestion.placeId, suggestion.description, widget.mapController);
            }else {
              Get.find<ParcelController>().setLocationFromPlace(suggestion.placeId, suggestion.description, widget.isPickedUp);
            }
            Get.back();
          },
        )),
      ),
    );
  }
}
