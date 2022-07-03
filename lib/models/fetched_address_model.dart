import 'package:geolocator/geolocator.dart';

/// Complete Address Aodel which contains position & typed address
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
