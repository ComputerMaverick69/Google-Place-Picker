import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Checking the permission status, get location permission and get the current location
dynamic checkPermission(Future<dynamic> getCurrentLocation) async {
  Geolocator.checkPermission().then((geoStatus) {
    log("Location: $geoStatus");
    if (geoStatus == LocationPermission.denied) {
      return Permission.location.request().then((_) => getCurrentLocation);
    } else {
      return getCurrentLocation;
    }
  });
}
