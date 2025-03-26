// Project: 	   barkingclub
// File:    	   location_picker
// Path:    	   lib/widgets/location_picker.dart
// Author:       Ali Akbar
// Date:        24-06-24 15:39:31 -- Monday
// Description:

import 'package:petcare/exceptions/data_exceptions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:place_picker/place_picker.dart';

import '../models/location_model.dart';
import '../utils/dialogs/dialogs.dart';

class LocationPicker {
  Future<bool> _checkOrPermitPermission() async {
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }

    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      CustomDialogs().alertBox(
          message: "Please allow location permission from settings.",
          title: "Location Permission Denied.",
          positiveTitle: "Open Setting",
          onPositivePressed: () async {
            await Geolocator.openLocationSettings();
          },
          showNegative: false);
    }

    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  Future<LocationModel> pick() async {
    final bool isAllowed = await _checkOrPermitPermission();
    if (!isAllowed) {
      throw DataExceptionPermissionDenialed(
          message: "Location Permission denied by user.");
    }
    final String api = "AIzaSyCBI-MFYmutIsSlg2s3BKE62barYgvhz6Q";
    final LocationResult result = await Get.to(PlacePicker(api));
    return LocationModel(
      latitude: result.latLng?.latitude ?? 0,
      longitude: result.latLng?.longitude ?? 0,
      city: result.city?.name,
      address: result.formattedAddress,
      country: result.country?.name,
    );
  }
}
