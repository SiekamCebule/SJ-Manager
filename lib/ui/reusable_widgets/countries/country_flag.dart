import 'package:flutter/material.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/country_flags.dart/country_flags_repo.dart';
import 'package:sj_manager/utils/context_maybe_read.dart';

class CountryFlag extends StatelessWidget {
  const CountryFlag({
    super.key,
    required this.country,
    required this.height,
  });

  final Country country;
  final double height;

  @override
  Widget build(BuildContext context) {
    final flagsRepo = context.maybeRead<CountryFlagsRepo>();
    final countryFlagsRepoExists = flagsRepo != null;
    return countryFlagsRepoExists
        ? Image(
            image: flagsRepo.imageData(country),
            height: height,
            fit: BoxFit.fitHeight,
          )
        : AspectRatio(
            aspectRatio: 4 / 3,
            child: SizedBox(
              height: height,
              child: Placeholder(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          );
  }
}
