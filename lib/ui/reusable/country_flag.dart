import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/country_flags.dart/country_flags_api.dart';

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
    final flagsRepo = context.watch<CountryFlagsApi>();
    return Image(
      image: flagsRepo.imageData(country),
      width: height,
      fit: BoxFit.fitHeight,
    );
  }
}
