import 'dart:math';

import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/jumps/simple_jump_record.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/utils/db_items.dart';
import 'package:sj_manager/utils/iterable_random_access.dart';

base mixin MaleCountryPreviewCreator on CountryPreviewCreator {}
base mixin FemaleCountryPreviewCreator on CountryPreviewCreator {}

abstract base class CountryPreviewCreator {
  const CountryPreviewCreator();

  int? stars(String countryCode);
  SimpleJumpRecord? nationalRecord(String countryCode);
  Jumper? bestJumper(String countryCode);
  Jumper? risingStar(String countryCode);
  Hill? largestHill(String countryCode);
}

abstract base class DefaultCountryPreviewCreatorBase extends CountryPreviewCreator {
  const DefaultCountryPreviewCreatorBase({
    required this.database,
  });

  final LocalDbRepo database;

  @override
  Hill? largestHill(String countryCode) {
    final fromCountry = database.hills.lastItems.fromCountryByCode(countryCode);
    if (fromCountry.isEmpty) return null;
    return fromCountry.reduce((previous, current) {
      return previous.hs > current.hs ? previous : current;
    });
  }
}

final class DefaultMaleCountryPreviewCreator extends DefaultCountryPreviewCreatorBase
    with MaleCountryPreviewCreator {
  DefaultMaleCountryPreviewCreator({
    required super.database,
  });

  @override
  int? stars(String countryCode) {
    return database.maleCountryFacts.lastItems.byCountryCode(countryCode)?.stars;
  }

  @override
  SimpleJumpRecord? nationalRecord(String countryCode) {
    return database.maleCountryFacts.lastItems.byCountryCode(countryCode)?.personalBest;
  }

  @override
  Jumper? bestJumper(String countryCode) {
    // TODO: Some algorithm
    final fromCountry = database.maleJumpers.lastItems.fromCountryByCode(countryCode);
    if (fromCountry.isEmpty) return null;
    return fromCountry.randomElement();
  }

  @override
  Jumper? risingStar(String countryCode) {
    // TODO: Some algorithm
    final fromCountry = database.maleJumpers.lastItems.fromCountryByCode(countryCode);
    if (fromCountry.isEmpty) return null;
    return database.maleJumpers.lastItems.fromCountryByCode(countryCode).first;
  }
}

final class DefaultFemaleCountryPreviewCreator extends DefaultCountryPreviewCreatorBase
    with FemaleCountryPreviewCreator {
  DefaultFemaleCountryPreviewCreator({
    required super.database,
  });

  @override
  int? stars(String countryCode) {
    return database.femaleCountryFacts.lastItems.byCountryCode(countryCode)?.stars;
  }

  @override
  SimpleJumpRecord? nationalRecord(String countryCode) {
    return database.femaleCountryFacts.lastItems.byCountryCode(countryCode)?.personalBest;
  }

  @override
  Jumper? bestJumper(String countryCode) {
    // TODO: Some algorithm
    final fromCountry = database.femaleJumpers.lastItems.fromCountryByCode(countryCode);
    if (Random().nextInt(5) == 1 || fromCountry.isEmpty) return null;
    return fromCountry.randomElement();
  }

  @override
  Jumper? risingStar(String countryCode) {
    // TODO: Some algorithm
    final fromCountry = database.femaleJumpers.lastItems.fromCountryByCode(countryCode);
    if (Random().nextInt(3) == 1 || fromCountry.isEmpty) return null;
    return fromCountry.first;
  }
}
