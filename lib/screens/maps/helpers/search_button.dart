import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place_picker/helpers/localization/locale.dart';
import 'package:google_place_picker/screens/search/search.dart';
import 'with_shadow_container.dart';

class SearchButton extends StatelessWidget {
  /// The widget which will be used in search
  const SearchButton({
    required this.addressLabelState,
    required this.getLocation,
    required this.apiKey,
    required this.loader,
    required this.mapLocale,
    Key? key,
  }) : super(key: key);

  final dynamic addressLabelState;

  /// Method which gets searched location
  final dynamic Function(LatLng) getLocation;
  final String apiKey;
  final Widget loader;
  final MapLocale mapLocale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addressLabelState();
        showSearchDialog(
          context,
          addressLabelState,
          getLocation,
          apiKey,
          mapLocale,
          loader,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: withShadowDecoration(
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.search,
              size: 20.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          context,
        ),
      ),
    );
  }
}
