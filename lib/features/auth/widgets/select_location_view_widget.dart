import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/auth/widgets/zone_selection_widget.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/location/domain/models/zone_data_model.dart';
import 'package:sixam_mart/features/location/widgets/permission_dialog_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/auth/controllers/store_registration_controller.dart';
import 'package:sixam_mart/features/auth/widgets/module_view_widget.dart';
import 'package:sixam_mart/features/location/widgets/location_search_dialog_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/validate_check.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_dropdown.dart';

class SelectLocationViewWidget extends StatefulWidget {
  final bool fromView;
  final bool mapView;
  final bool zoneModuleView;
  final GoogleMapController? mapController;
  final TextEditingController? addressController;
  final FocusNode? addressFocus;
  final bool inDialog;
  const SelectLocationViewWidget({super.key, required this.fromView, this.mapController, this.mapView = false, this.zoneModuleView = false,
    this.addressController, this.addressFocus, this.inDialog = false});

  @override
  State<SelectLocationViewWidget> createState() => _SelectLocationViewWidgetState();
}

class _SelectLocationViewWidgetState extends State<SelectLocationViewWidget> {
  late CameraPosition _cameraPosition;
  Set<Polygon> _polygons = {};
  GoogleMapController? _mapController;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreRegistrationController>(builder: (storeRegController) {

      bool isDesktop = ResponsiveHelper.isDesktop(context);

      List<int> zoneIndexList = [];
      List<DropdownItem<int>> zoneList = [];
      if(storeRegController.zoneList != null && storeRegController.zoneIds != null) {
        for(int index=0; index<storeRegController.zoneList!.length; index++) {
          zoneIndexList.add(index);
          zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${storeRegController.zoneList![index].name}'),
            ),
          )));
        }
      }

      return Container(
        decoration: widget.fromView && !isDesktop ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
        ) : null,
        alignment: Alignment.center,
        height: widget.fromView ? null : context.height,
        padding: widget.fromView && !isDesktop ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault) : EdgeInsets.zero,
        child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
          padding: EdgeInsets.all(widget.fromView ? 0 : 0),
          child: SingleChildScrollView(
            child: isDesktop && widget.fromView ? webView(storeRegController, zoneList): Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),

              widget.fromView ? ZoneSelectionWidget(storeRegController: storeRegController, zoneList: zoneList, callBack: (){
                _setPolygon(storeRegController.zoneList![storeRegController.selectedZoneIndex!]);
              }) : const SizedBox(),
              widget.fromView ? const SizedBox(height: Dimensions.paddingSizeExtraOverLarge) : const SizedBox(),

              widget.fromView ? const ModuleViewWidget() : const SizedBox(),
              widget.fromView ? const SizedBox(height: Dimensions.paddingSizeExtremeLarge) : const SizedBox(),

              mapView(storeRegController),
              SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0),

              !widget.fromView && !widget.inDialog ? CustomButton(
                buttonText: 'set_location'.tr,
                onPressed: () {
                  try{
                    widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    Get.back();
                  }catch(_){
                    Get.back();
                  }
                },
              ) : const SizedBox(),

              !storeRegController.inZone ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(children: [
                  Text('* ', style: robotoBold.copyWith(color: Colors.red)),
                  Text('please_place_the_marker_inside_the_zone'.tr, style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                ]),
              ) : const SizedBox(),

              !isDesktop ? SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0) : const SizedBox(),

              SizedBox(height: widget.fromView ? Dimensions.paddingSizeExtremeLarge : 0),

              widget.fromView && !isDesktop ? CustomTextField(
                titleText: 'write_store_address'.tr,
                labelText: 'address'.tr,
                controller: widget.addressController,
                focusNode: widget.addressFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                capitalization: TextCapitalization.sentences,
                maxLines: 3,
                showTitle: isDesktop,
                required: true,
                validator: (value) => ValidateCheck.validateEmptyText(value, "store_address_field_is_required".tr),
              ) : const SizedBox(),

            ]),
          ),
        )),
      );
    });
  }

  Widget webView(StoreRegistrationController storeRegController, List<DropdownItem<int>> zoneList) {
    return Row(children: [

      (widget.fromView && widget.zoneModuleView) ?  const SizedBox() : const SizedBox(width: Dimensions.paddingSizeLarge),

      (widget.fromView && widget.mapView) ?  Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ZoneSelectionWidget(storeRegController: storeRegController, zoneList: zoneList, callBack: (){
            _setPolygon(storeRegController.zoneList![storeRegController.selectedZoneIndex!]);
          }),

          const SizedBox(height: Dimensions.paddingSizeLarge),
          mapView(storeRegController),

        ],
      )) : const SizedBox(),

    ]);
  }

  Widget mapView(StoreRegistrationController storeRegController) {
    return storeRegController.zoneList!.isNotEmpty ? Center(
      child: Container(
        height: ResponsiveHelper.isDesktop(context) ? widget.fromView ? 190 : MediaQuery.of(context).size.height * 0.8
            : widget.fromView ? 150 : (context.height * 0.87),
        width: widget.inDialog ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width,
        decoration: widget.fromView ? BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        ) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Stack(clipBehavior: Clip.none, children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
                ), zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: false,
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              polygons: _polygons,
              onCameraIdle: () {
                storeRegController.setLocation(
                  _cameraPosition.target, forStoreRegistration: true,
                  zoneId: storeRegController.zoneList![storeRegController.selectedZoneIndex!].id,
                );
                if(!widget.fromView) {
                  widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                }
              },
              onCameraMove: ((position) => _cameraPosition = position),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _setPolygon(storeRegController.zoneList![storeRegController.selectedZoneIndex!]);
              },
              myLocationButtonEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
              },
            ),
            const Center(child: CustomAssetImageWidget(Images.markerStore, height: 40, width: 40)),

             Positioned(
               top: widget.fromView ? 10 : 20, left: widget.fromView ? 10 : 20, right: widget.fromView ? null : 20,
               child: InkWell(
                 onTap: () async {
                    var p = await Get.dialog(LocationSearchDialogWidget(mapController: _mapController));
                    Position? position = p;
                    if(position != null) {
                      _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                      if(!widget.fromView) {
                        widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                        storeRegController.setLocation(
                          _cameraPosition.target, forStoreRegistration: true,
                          zoneId: storeRegController.zoneList![storeRegController.selectedZoneIndex!].id,
                        );
                      }
                    }
                    },
                 child: Container(
                   height: widget.fromView ? 30 : 40, width: 200,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                     color: Theme.of(context).cardColor,
                     boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                   ),
                   padding: const EdgeInsets.only(left: 10),
                   alignment: Alignment.centerLeft,
                   child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                 ),
               ),
            ),

            widget.inDialog ? Positioned(
              top: 0, right: 0,
              child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear)),
            ) : const SizedBox(),

            widget.fromView ? Positioned(
              bottom: 50, right: 0,
              child: InkWell(
                onTap: () {
                  if(storeRegController.selectedZoneIndex == -1) {
                    showCustomSnackBar('please_select_zone'.tr);
                  } else {
                    if(ResponsiveHelper.isDesktop(context)) {
                      showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                        return Center(child: SelectLocationViewWidget(fromView: false, mapController: _mapController, inDialog: true));
                      });
                    } else {
                      Get.to(Scaffold(
                        appBar: CustomAppBar(title: 'set_your_store_location'.tr),
                        body: SelectLocationViewWidget(fromView: false, mapController: _mapController),
                      ));
                    }
                  }
                },
                child: Container(
                  width: 30, height: 30,
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                ),
              ),
            ) : const SizedBox(),

            Positioned(
              bottom: widget.fromView ? 10 : 210, right: 0,
              child: InkWell(
                onTap: () => _checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                }),
                child: Container(
                  padding: EdgeInsets.all(widget.fromView ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
                  child: Icon(Icons.my_location_outlined, color: Theme.of(context).primaryColor, size: widget.fromView ? 20 : 25),
                ),
              ),
            ),

            !widget.fromView ? Positioned(
              bottom: 100, right: 0,
              child: Container(
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  InkWell(
                    onTap: () async {
                      var currentZoomLevel = await _mapController?.getZoomLevel();
                      currentZoomLevel = (currentZoomLevel! + 1);
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _cameraPosition.target,
                            zoom: currentZoomLevel,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add, size: 25),
                  ),
                  const Divider(),

                  InkWell(
                    onTap: () async {
                      var currentZoomLevel = await _mapController?.getZoomLevel();
                      currentZoomLevel = (currentZoomLevel! - 1);
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _cameraPosition.target,
                            zoom: currentZoomLevel,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.remove, size: 25),
                  ),
                ]),
              ),
            ) : const SizedBox(),

            !widget.fromView ? Positioned(
              left: 20, right: 20, bottom: ResponsiveHelper.isDesktop(context) ? 40 : 20,
              child: CustomButton(
                buttonText: storeRegController.inZone ? 'set_location'.tr : 'not_in_zone'.tr,
                onPressed: storeRegController.inZone ? () {
                  try{
                    widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    Get.back();
                  } catch(e){
                    showCustomSnackBar('please_setup_the_marker_in_your_required_location'.tr);
                  }
                } : null,
              ),
            ) : const SizedBox(),

          ]),
        ),
      ),
    ) : const SizedBox();
  }

  _setPolygon(ZoneDataModel zoneModel) {
    List<Polygon> polygonList = [];
    List<LatLng> zoneLatLongList = [];

    zoneModel.formatedCoordinates?.forEach((coordinate) {
      zoneLatLongList.add(LatLng(coordinate.lat!, coordinate.lng!));
    });

    polygonList.add(
      Polygon(
        polygonId: PolygonId('${zoneModel.id!}'),
        points: zoneLatLongList,
        strokeWidth: 2,
        strokeColor: Get.theme.colorScheme.primary,
        fillColor: Get.theme.colorScheme.primary.withOpacity(.2),
      ),
    );

    _polygons = HashSet<Polygon>.of(polygonList);

    Future.delayed( const Duration(milliseconds: 500),(){
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
        boundsFromLatLngList(zoneLatLongList),
        ResponsiveHelper.isDesktop(Get.context) ? 30 : 100.5,
      ));
    });

    setState(() {});
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1 ?? 0, y1 ?? 0), southwest: LatLng(x0 ?? 0, y0 ?? 0));
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialogWidget());
    }else {
      onTap();
    }
  }

}
