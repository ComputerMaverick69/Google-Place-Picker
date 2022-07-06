import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place_picker/helpers/localization/locale.dart';
import 'package:google_place_picker/models/map_view_model.dart';
import 'search_list.dart';
import 'search_text_field.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    required this.addressLabelState,
    required this.getLocation,
    required this.apiKey,
    required this.loader,
    required this.mapLocale,
    Key? key,
  }) : super(key: key);

  final dynamic addressLabelState;

  /// Method which getting the location
  final dynamic Function(LatLng) getLocation;
  final String apiKey;
  final Widget loader;
  final MapLocale mapLocale;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isError = false;
  bool getSearched = false;
  MapModel mapModel = MapModel(results: []);

  @override
  dispose() {
    searchController.dispose();
    mapModel = MapModel(results: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SearchTextField(
          addressLabelState: widget.addressLabelState,
          searchController: searchController,
          mapLocale: widget.mapLocale,
          apiKey: widget.apiKey,
          getPlaces: getPlaces,
        ),
        SearchList(
          getSearched: getSearched,
          isSearching: isSearching,
          mapLocale: widget.mapLocale,
          isError: isError,
          mapModel: mapModel,
          getLocation: widget.getLocation,
          addressLabelState: widget.addressLabelState,
          loader: widget.loader,
        ),
      ],
    );
  }

  getPlaces(
    String apiKey,
    String keyword,
  ) async {
    setState(() {
      isSearching = true;
      getSearched = true;
    });
    try {
      Response response = await Dio().get(
        // 'https://maps.googleapis.com/maps/api/place/textsearch/json',
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json',
        queryParameters: {
          'fields':
              'formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry',
          'input': keyword,
          'inputtype': 'textquery',
          'key': apiKey,
          'language': widget.mapLocale.locale,
        },
      );
      mapModel = MapModel.fromJson(response.data);

      setState(() {
        isSearching = false;
      });
    } catch (e) {
      debugPrint('Error : $e');
      setState(() {
        isError = true;
      });
    }
  }
}
