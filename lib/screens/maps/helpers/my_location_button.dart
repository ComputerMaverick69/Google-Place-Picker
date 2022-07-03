import 'package:flutter/material.dart';
import 'package:place_picker/helpers/size_config.dart';
import 'with_shadow_container.dart';

class CurrentLocationButton extends StatelessWidget {
  /// Getting current location button
  const CurrentLocationButton({
    required this.getCurrentLocation,
    Key? key,
  }) : super(key: key);

  final dynamic getCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: SafeArea(
        child: InkWell(
          onTap: () => getCurrentLocation(),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.width10),
            child: withShadowDecoration(
              CircleAvatar(
                radius: SizeConfig.radius20,
                backgroundColor: Colors.transparent,
                // backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                child: Icon(
                  Icons.my_location_outlined,
                  size: SizeConfig.width25,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              context,
            ),
          ),
        ),
      ),
    );
  }
}
