class CountryByCodeNotFoundError {
  CountryByCodeNotFoundError({
    required this.countryCode,
  });

  final String countryCode;

  @override
  String toString() {
    return 'Unable to find a country with the code of \'$countryCode\'';
  }
}
