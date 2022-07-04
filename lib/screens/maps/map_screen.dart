import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place_picker/config/functions/on_camera_move.dart';
import 'package:google_place_picker/config/functions/permission_checker.dart';
import 'package:google_place_picker/config/unit_function.dart';
import 'package:google_place_picker/helpers/localization/locale.dart';
import 'package:google_place_picker/models/fetched_address_model.dart';
import 'package:google_place_picker/screens/maps/helpers/address_label.dart';
import 'package:google_place_picker/screens/maps/helpers/close_button.dart';
import 'package:google_place_picker/screens/maps/helpers/map_view.dart';
import 'package:google_place_picker/screens/maps/helpers/my_location_button.dart';
import 'package:google_place_picker/screens/maps/helpers/search_button.dart';

class GooglePlacePicker extends StatefulWidget {
  const GooglePlacePicker({
    required this.apiKey,
    this.mapLocale = MapLocale.english,
    this.getAddress,
    this.initialPosition = const LatLng(29.9773, 31.1325),
    this.enableMyLocationButton = true,
    this.enableSearchButton = true,
    this.loader =
        const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
    this.doneButton,
    this.errorButton,
    this.zoomFactor = 5.0,
    this.markerColor = MarkerColor.red,
    Key? key,
  }) : super(key: key);

  /// Google Maps API Key
  final String apiKey;

  /// [mapLocale] is the property of [GooglePlacePicker] that controls search results MapLocale.
  ///
  /// It's is a [Locale] that its default locale is [MapLocale.english] but can use other supported MapLocales.
  ///
  /// It's [MapLocale.english] by default.
  final MapLocale mapLocale;

  /// Method to get the position of the place on the map
  final Function(CompleteAddress)? getAddress;

  /// Initial position of the map in case there's no location and GPS is off
  final LatLng initialPosition;

  /// Enable or disable the My Location button
  final bool enableMyLocationButton;

  /// Enable or disable the Search button
  final bool enableSearchButton;

  /// Widget to show while the map is loading
  final Widget loader;

  /// Widget to show when the map is done loading and apply getResult method
  final Widget? doneButton;

  /// Widget to show when there's a corruption or there's no internet connection
  final Widget? errorButton;

  /// Zoom factor of the map (default is 5.0)
  final double zoomFactor;

  /// Marker color of the map (default is red)
  final MarkerColor markerColor;

  @override
  State<GooglePlacePicker> createState() => _GooglePlacePickerState();
}

class _GooglePlacePickerState extends State<GooglePlacePicker> {
  bool loadingLocation = true;
  bool notConnected = true;
  bool showLabel = true;
  CompleteAddress completeAddress = CompleteAddress();
  GoogleMapController? mapController;
  Completer<GoogleMapController> completer = Completer();
  Marker marker = const Marker(
    markerId: MarkerId('1'),
  );

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MapWidget(
            initialPosition: widget.initialPosition,
            marker: marker,
            zoomFactor: widget.zoomFactor,
            onMapCreated: onMapCreated,
            getLocation: getLocation,
          ),
          const CloseMapButton(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.enableMyLocationButton)
                CurrentLocationButton(getCurrentLocation: getCurrentLocation),
              if (widget.enableSearchButton)
                SearchButton(
                  addressLabelState: addressLabelState,
                  mapLocale: widget.mapLocale,
                  getLocation: getLocation,
                  apiKey: widget.apiKey,
                  loader: widget.loader,
                ),
            ],
          ),
          if (showLabel)
            AddressLabel(
              address: completeAddress,
              loader: widget.loader,
              notConnected: notConnected,
              loading: loadingLocation,
              mapLocale: widget.mapLocale,
              onTap: (completeAddress) {
                setState(() {
                  notConnected = false;
                  widget.getAddress!(completeAddress);
                });
                log('${completeAddress.completeAddress} \n${completeAddress.position!.latitude} \n${completeAddress.position!.longitude}');
              },
            ),
        ],
      ),
    );
  }

  /// OnMapCreated responsible for initializing the map controller
  onMapCreated(GoogleMapController controller) async {
    completer.complete(controller);
    mapController = controller;
    checkPermission(getCurrentLocation());
  }

  /// Getting location from the map by tapping
  getLocation(LatLng latLng) async {
    completeAddress.position = customPosition(latLng);
    setState(() {
      loadingLocation = true;
      notConnected = false;
    });
    List<Placemark> addressList = [];
    try {
      addressList = await geocoding.placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);
      await cameraMoving(mapController!, completeAddress.position);
    } catch (e) {
      setState(() {
        notConnected = true;
        loadingLocation = false;
      });
      log('Error: $e');
      log('NotConnected: $notConnected');
    }
    final address = addressList.first;
    completeAddress.completeAddress = "${address.street ?? ''},"
        "${address.name ?? ''},"
        "${address.locality ?? ''},"
        "${address.postalCode ?? ''},"
        "${address.country ?? ''}";
    marker = customMarker(
      latLng,
      getLocation,
      markerColor: widget.markerColor,
    );
    setState(() {
      loadingLocation = false;
    });
  }

  /// Getting the current location
  getCurrentLocation() async {
    log('GETTING LOCATION');
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      completeAddress.position = await Geolocator.getCurrentPosition();
      getLocation(LatLng(completeAddress.position!.latitude,
          completeAddress.position!.longitude));
    } else {
      await Geolocator.requestPermission();
      try {
        completeAddress.position = await Geolocator.getCurrentPosition();
        getLocation(LatLng(completeAddress.position!.latitude,
            completeAddress.position!.longitude));
        log('${completeAddress.position}');
      } catch (e) {
        getLocation(LatLng(
            widget.initialPosition.latitude, widget.initialPosition.longitude));
        log('Error: $e');
      }
    }
  }

  /// Showing & Hiding the address label
  dynamic addressLabelState() {
    setState(() {
      showLabel = !showLabel;
    });
  }
}
