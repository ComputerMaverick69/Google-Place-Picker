import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:place_picker/helpers/localization/get_response_phrases_model.dart';
import 'package:place_picker/helpers/localization/locale.dart';
import 'package:place_picker/helpers/localization/response_phrases_model.dart';
import 'package:place_picker/helpers/size_config.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    required this.searchController,
    required this.getPlaces,
    required this.apiKey,
    required this.addressLabelState,
    required this.mapLocale,
    Key? key,
  }) : super(key: key);

  /// The [searchController] for the search text field.
  final TextEditingController searchController;

  /// The api key for google maps services.
  final String apiKey;

  /// The method which get places by search.
  final Function(
    String apiKey,
    String keyword,
  ) getPlaces;

  /// The method which hide the address label.
  final dynamic addressLabelState;
  final MapLocale mapLocale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width30, vertical: SizeConfig.height10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.radius10),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: SizeConfig.width10, sigmaY: SizeConfig.height10),
          child: Container(
            height: SizeConfig.height60,
            decoration: BoxDecoration(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.white.withOpacity(0.25)
                      : Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(SizeConfig.radius10),
            ),
            child: TextField(
              controller: searchController,
              style: TextStyle(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  getPlaces(apiKey, value);
                  debugPrint(value);
                }
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                suffixIcon: _ActionButton(
                    searchController: searchController,
                    getPlaces: getPlaces,
                    apiKey: apiKey,
                    addressLabelState: addressLabelState),
                hintText: getResponsePhrase(
                    ResponsePhrasesModel.searchForPlace, mapLocale.locale),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.radius15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.searchController,
    required this.getPlaces,
    required this.apiKey,
    required this.addressLabelState,
    Key? key,
  }) : super(key: key);

  /// The [searchController] for the search text field.
  final TextEditingController searchController;

  /// The api key for google maps services.
  final String apiKey;

  /// The method which get places by search.
  final Function(
    String apiKey,
    String keyword,
  ) getPlaces;

  /// The method which hide the address label.
  final dynamic addressLabelState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (searchController.text.isNotEmpty) {
              getPlaces(
                apiKey,
                searchController.text,
              );
              debugPrint(searchController.text);
            }
          },
          child: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: SizeConfig.width5,
        ),
        InkWell(
          onTap: () {
            if (searchController.text.isNotEmpty) {
              searchController.clear();
            } else {
              addressLabelState();
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.cancel_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: SizeConfig.width5,
        ),
      ],
    );
  }
}
