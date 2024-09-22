import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumps_consistency.dart';
import 'package:sj_manager/models/user_db/jumper/landing_style.dart';
import 'package:sj_manager/models/user_db/jumps/simple_jump.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/utils/db_items.dart';
import 'package:sj_manager/utils/team_preview_creator/team_preview_creator.dart';

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
  Jumper? bestJumper(CountryTeam team) {
    final jumpers = _jumpersBySex(team.sex);
    final jumpersFromCountry = jumpers.fromCountryByCode(team.country.code);
    if (jumpersFromCountry.isEmpty) return null;
    final jumperRatings = {
      for (var jumper in jumpersFromCountry) jumper: _calculateRating(jumper),
    };
    return _atPositionFromRatings(jumperRatings, position: 1);
  }

  @override
  Jumper? risingStar(CountryTeam team) {
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

  Iterable<Jumper> _jumpersBySex(Sex sex) {
    return sex == Sex.male
        ? gameVariant.jumpers.whereType<MaleJumper>()
        : gameVariant.jumpers.whereType<FemaleJumper>();
  }

  double _calculateRatingForRisingStar(Jumper jumper) {
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

  double _calculateRating(Jumper jumper) {
    final skills = jumper.skills;
    final byQualityOnSmallerHills = skills.qualityOnSmallerHills * 1.0;
    final byQualityOnLargerHills = skills.qualityOnLargerHills * 1.0;
    final multiplierByConsistency = switch (skills.jumpsConsistency) {
      JumpsConsistency.veryConsistent => 1.03,
      JumpsConsistency.consistent => 1.02,
      JumpsConsistency.quiteConsistent => 1.01,
      JumpsConsistency.average => 1.0,
      JumpsConsistency.slightlyInconsistent => 0.99,
      JumpsConsistency.inconsistent => 0.98,
      JumpsConsistency.veryInconsistent => 0.97,
    };
    final multiplierByLandingStyle = switch (skills.landingStyle) {
      LandingStyle.veryGraceful => 1.06,
      LandingStyle.graceful => 1.04,
      LandingStyle.quiteGraceful => 1.02,
      LandingStyle.average => 1.00,
      LandingStyle.slightlyUgly => 0.98,
      LandingStyle.ugly => 0.96,
      LandingStyle.veryUgly => 0.94,
    };
    final rating = (byQualityOnSmallerHills + byQualityOnLargerHills) *
        multiplierByConsistency *
        multiplierByLandingStyle;
    return rating;
  }

  Jumper _atPositionFromRatings(Map<Jumper, double> jumperRatings,
      {required int position}) {
    if (position < 1 || position > jumperRatings.length) {
      throw ArgumentError('Position out of range');
    }
    List<MapEntry<Jumper, double>> sortedEntries = jumperRatings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries[position - 1].key;
  }
}
