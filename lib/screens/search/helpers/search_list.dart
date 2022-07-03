import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/helpers/localization/get_response_phrases_model.dart';
import 'package:place_picker/helpers/localization/locale.dart';
import 'package:place_picker/helpers/localization/response_phrases_model.dart';
import 'package:place_picker/helpers/size_config.dart';
import 'package:place_picker/models/map_view_model.dart';
import 'package:place_picker/widgets/title_text_widget.dart';

class SearchList extends StatelessWidget {
  const SearchList({
    required this.getSearched,
    required this.isSearching,
    required this.isError,
    required this.mapModel,
    required this.loader,
    required this.getLocation,
    required this.addressLabelState,
    required this.mapLocale,
    Key? key,
  }) : super(key: key);

  final bool getSearched;
  final bool isSearching;
  final bool isError;
  final MapModel mapModel;
  final Widget loader;

  /// Method which getting the location
  final dynamic Function(LatLng) getLocation;
  final dynamic addressLabelState;
  final MapLocale mapLocale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.height30, vertical: SizeConfig.height10),
      child: !getSearched
          ? const SizedBox()
          : ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.radius15),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: SizeConfig.width10, sigmaY: SizeConfig.height10),
                child: Container(
                  decoration: BoxDecoration(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white.withOpacity(0.25)
                        : Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(SizeConfig.radius15),
                  ),
                  width: double.infinity,
                  height: SizeConfig.height200 + SizeConfig.height150,
                  child: isSearching
                      ? loader
                      : isError
                          ? Center(
                              child: TitleTextWidget(
                                titleText: getResponsePhrase(
                                    ResponsePhrasesModel.errorInConnection,
                                    mapLocale.locale),
                                titleColor: Colors.red,
                              ),
                            )
                          : mapModel.results!.isEmpty
                              ? Center(
                                  child: TitleTextWidget(
                                      titleText: getResponsePhrase(
                                          ResponsePhrasesModel.noPlacesFound,
                                          mapLocale.locale)))
                              : ListView.separated(
                                  itemCount: mapModel.results!.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.grey,
                                    thickness: 1.0,
                                    height: 0.0,
                                  ),
                                  itemBuilder: (context, index) => _PlaceItem(
                                    title: mapModel.results![index]!.name
                                        .toString(),
                                    subtitle: mapModel
                                        .results![index]!.formattedAddress
                                        .toString(),
                                    lat: mapModel.results![index]!.geometry!
                                        .location!.lat!
                                        .toDouble(),
                                    lng: mapModel.results![index]!.geometry!
                                        .location!.lng!
                                        .toDouble(),
                                    getLocation: getLocation,
                                    addressLabelState: addressLabelState,
                                  ),
                                ),
                ),
              ),
            ),
    );
  }
}

class _PlaceItem extends StatelessWidget {
  const _PlaceItem({
    required this.title,
    required this.subtitle,
    required this.lat,
    required this.lng,
    required this.getLocation,
    required this.addressLabelState,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double lat;
  final double lng;

  /// Method which getting the location
  final dynamic Function(LatLng) getLocation;
  final dynamic addressLabelState;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textScaleFactor: 1.0,
        style: TextStyle(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        textScaleFactor: 1.0,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black38
              : Colors.grey[300],
        ),
      ),
      onTap: () {
        addressLabelState();
        getLocation(LatLng(lat, lng));
        Navigator.pop(context);
      },
    );
  }
}
