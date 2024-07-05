import 'package:flutter/material.dart';
import 'package:sj_manager/models/country.dart';

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
    return Image.asset(
      'assets/country_flags/${country.code}.png',
      width: height,
      fit: BoxFit.fitHeight,
    );
  }
}
