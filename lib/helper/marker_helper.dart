import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerHelper{

  static Future<BitmapDescriptor> convertAssetToBitmapDescriptor({
    required final String imagePath,
    final int? width,
    final int? height,
  }) async {
    try {
      if(GetPlatform.isWeb) {
        //return BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5, size: Size(50, 50), ), imagePath);
        return BitmapDescriptor.asset(const ImageConfiguration(devicePixelRatio: 2.5, size: Size(50, 50), ), imagePath);
      }
      final ByteData byteDataFromImage = await rootBundle.load(imagePath).timeout(const Duration(seconds: 8));
      final ui.Codec codec = await ui
          .instantiateImageCodec(byteDataFromImage.buffer.asUint8List(), targetHeight: height, targetWidth: width)
          .timeout(const Duration(seconds: 8));
      final ui.FrameInfo frameInfo = await codec.getNextFrame().timeout(const Duration(seconds: 8));
      final ByteData? byteDataFromFrame =
      await frameInfo.image.toByteData(format: ui.ImageByteFormat.png).timeout(const Duration(seconds: 8));
      if (byteDataFromFrame != null) {
        final Uint8List uint8List = byteDataFromFrame.buffer.asUint8List();
        //return BitmapDescriptor.fromBytes(uint8List);
        return BitmapDescriptor.bytes(uint8List);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      }
    } catch(_) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }
}