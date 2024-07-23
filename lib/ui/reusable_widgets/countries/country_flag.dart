import 'package:flutter/material.dart';
import 'package:sj_manager/models/db/country.dart';
import 'package:sj_manager/repositories/country_flags.dart/country_flags_repo.dart';
import 'package:sj_manager/utils/context_maybe_read.dart';

class CountryFlag extends StatelessWidget {
  const CountryFlag({
    super.key,
    required this.country,
    required this.width,
  });

  final Country country;
  final double width;

  @override
  Widget build(BuildContext context) {
    final flagsRepo = context.maybeRead<CountryFlagsRepo>();
    final countryFlagsRepoExists = flagsRepo != null;
    return countryFlagsRepoExists
        ? Image(
            image: flagsRepo.imageData(country),
            width: width,
            fit: BoxFit.fitWidth,
          )
        : AspectRatio(
            aspectRatio: 4 / 3,
            child: SizedBox(
              width: width,
              child: Placeholder(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          );
  }
}
