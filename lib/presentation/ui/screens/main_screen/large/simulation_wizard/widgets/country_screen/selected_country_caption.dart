import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/core/country/country.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';

class SelectedCountryCaption extends StatelessWidget {
  const SelectedCountryCaption({
    super.key,
    required this.country,
    this.stars,
  });

  final Country country;
  final int? stars;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          country.name(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(10),
        CountryFlag(
          country: country,
          width: 30,
        ),
        const Gap(10),
        if (stars != null)
          ...List.generate(stars!, (_) {
            return Icon(
              Symbols.star,
              color: Theme.of(context).colorScheme.secondary,
              fill: 1,
            );
          }),
      ],
    );
  }
}
