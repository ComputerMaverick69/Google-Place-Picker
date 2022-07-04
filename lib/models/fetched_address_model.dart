import 'package:geolocator/geolocator.dart';

/// Complete Address Model which contains position & fetched address
class CompleteAddress {
  /// Position of the address
  Position? position;

  /// Formatted address
  String? completeAddress;

  CompleteAddress({
    this.position,
    this.completeAddress,
  });
}
