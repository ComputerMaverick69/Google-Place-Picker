import 'package:flutter/material.dart';
import 'package:place_picker/helpers/size_config.dart';
import 'with_shadow_container.dart';

class CloseMapButton extends StatelessWidget {
  /// Closing Map widget
  const CloseMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: SafeArea(
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.radius10),
            child: withShadowDecoration(
              CircleAvatar(
                radius: SizeConfig.radius20,
                backgroundColor: Colors.transparent,
                // backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light
                //     ? Colors.white
                //     : Colors.black,
                child: Icon(
                  Icons.cancel_outlined,
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
