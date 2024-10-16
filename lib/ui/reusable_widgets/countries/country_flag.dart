import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/utils/context_maybe_read.dart';

class CountryFlag extends StatelessWidget {
  const CountryFlag({
    super.key,
    required this.country,
    this.customImage,
    this.width,
    this.height,
    this.circularBorderRadius = UiGlobalConstants.defaultCountryFlagBorderRadius,
  }) : assert((width != null || height != null) && !(width != null && height != null));

  final Country country;
  final ImageProvider? customImage;
  final double? width;
  final double? height;
  final double circularBorderRadius;

  @override
  Widget build(BuildContext context) {
    final flagsRepo = context.maybeRead<CountryFlagsRepo>();
    final countryFlagsRepoExists = flagsRepo != null;

    final imageFit = width != null ? BoxFit.fitWidth : BoxFit.fitHeight;

    late final Widget child;
    if (customImage != null) {
      child = Image(
        image: customImage!,
        width: width,
        height: height,
        fit: imageFit,
      );
    } else {
      child = countryFlagsRepoExists
          ? Image(
              image: flagsRepo.imageData(country),
              width: width,
              height: height,
              fit: imageFit,
            )
          : SizedBox(
              width: width,
              height: height,
              child: AspectRatio(
                aspectRatio: UiSpecificItemConstants.countryFlagAspectRatio,
                child: Placeholder(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(circularBorderRadius),
      child: child,
    );
  }
}
