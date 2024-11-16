import 'package:sj_manager/data/models/game_variants/game_variant.dart';
import 'package:sj_manager/data/models/database/hill/hill.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/data/models/database/jumps/simple_jump.dart';
import 'package:sj_manager/data/models/database/sex.dart';
import 'package:sj_manager/data/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/utilities/utils/db_items.dart';
import 'package:sj_manager/utilities/utils/team_preview_creator/team_preview_creator.dart';

class DefaultCountryTeamPreviewCreator extends TeamPreviewCreator<CountryTeam> {
  const DefaultCountryTeamPreviewCreator({
    required this.gameVariant,
    required this.currentDate,
  });

  final GameVariant gameVariant;
  final DateTime currentDate;

  @override
  Hill? largestHill(CountryTeam team) {
    final fromCountry = gameVariant.hills.fromCountryByCode(team.country.code);
    if (fromCountry.isEmpty) return null;
    return fromCountry.reduce((previous, current) {
      return previous.hs > current.hs ? previous : current;
    });
  }

  @override
  int? stars(CountryTeam team) {
    return team.facts.stars;
  }

  @override
  SimpleJump? record(CountryTeam team) {
    return team.facts.record;
  }

  @override
  JumperDbRecord? bestJumper(CountryTeam team) {
    final jumpers = _jumpersBySex(team.sex);
    final jumpersFromCountry = jumpers.fromCountryByCode(team.country.code);
    if (jumpersFromCountry.isEmpty) return null;
    final jumperRatings = {
      for (var jumper in jumpersFromCountry) jumper: _calculateRating(jumper),
    };
    return _atPositionFromRatings(jumperRatings, position: 1);
  }

  @override
  JumperDbRecord? risingStar(CountryTeam team) {
    final jumpers = _jumpersBySex(team.sex);
    final jumpersFromCountry = jumpers.fromCountryByCode(team.country.code);
    if (jumpersFromCountry.isEmpty) return null;

    final jumperRatings = {
      for (var jumper in jumpersFromCountry)
        jumper: _calculateRatingForRisingStar(jumper),
    };
    final best = bestJumper(team);
    final bestForRisingStar = _atPositionFromRatings(jumperRatings, position: 1);
    if (jumperRatings.values.every((rating) => rating == 0) ||
        (best == bestForRisingStar && jumperRatings.length == 1)) {
      return null;
    } else if (best == bestForRisingStar) {
      return _atPositionFromRatings(jumperRatings, position: 2);
    } else {
      return bestForRisingStar;
    }
  }

  Iterable<JumperDbRecord> _jumpersBySex(Sex sex) {
    return sex == Sex.male
        ? gameVariant.jumpers.whereType<MaleJumperDbRecord>()
        : gameVariant.jumpers.whereType<FemaleJumperDbRecord>();
  }

  double _calculateRatingForRisingStar(JumperDbRecord jumper) {
    final base = _calculateRating(jumper);
    final age = jumper.age(date: currentDate);
    final multiplierByAge = _multiplierByAge(age);
    print('$jumper multiplier by age ($age): $multiplierByAge');
    final rating = base * multiplierByAge;
    print('$jumper: rating: $rating');
    return rating;
  }

  double _multiplierByAge(int age) {
    return switch (age) {
      12 => 1.0,
      13 => 1.0,
      14 => 1.0,
      15 => 1.0,
      16 => 1.05,
      17 => 1.05,
      18 => 1.1,
      19 => 1.1,
      20 => 1.05,
      21 => 0.95,
      22 => 0.9,
      23 => 0.8,
      _ => 0.0
    };
  }

  double _calculateRating(JumperDbRecord jumper) {
    final skills = jumper.skills;
    final byTakeoffQuality = skills.takeoffQuality * 1.0;
    final byFlightQuality = skills.takeoffQuality * 1.0;
    final byLandingQuality = skills.landingQuality * 0.1;
    final rating = byTakeoffQuality + byFlightQuality + byLandingQuality;
    return rating;
  }

  JumperDbRecord _atPositionFromRatings(Map<JumperDbRecord, double> jumperRatings,
      {required int position}) {
    if (position < 1 || position > jumperRatings.length) {
      throw ArgumentError('Position out of range');
    }
    List<MapEntry<JumperDbRecord, double>> sortedEntries = jumperRatings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries[position - 1].key;
  }
}
