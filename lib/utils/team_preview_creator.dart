import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/jumper/jumps_consistency.dart';
import 'package:sj_manager/models/db/jumper/landing_style.dart';
import 'package:sj_manager/models/db/jumps/simple_jump.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/models/db/sex.dart';
import 'package:sj_manager/models/db/team/country_team.dart';
import 'package:sj_manager/models/db/team/team.dart';
import 'package:sj_manager/utils/db_items.dart';

abstract class TeamPreviewCreator<T extends Team> {
  const TeamPreviewCreator();

  int? stars(T team);
  SimpleJump? record(T team);
  Jumper? bestJumper(T team);
  Jumper? risingStar(T team);
  Hill? largestHill(T team);
}

class DefaultCountryTeamPreviewCreator extends TeamPreviewCreator<CountryTeam> {
  const DefaultCountryTeamPreviewCreator({
    required this.database,
  });

  final LocalDbRepo database;

  @override
  Hill? largestHill(CountryTeam team) {
    final fromCountry = database.hills.last.fromCountryByCode(team.country.code);
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
    final jumpers =
        team.sex == Sex.male ? database.maleJumpers.last : database.femaleJumpers.last;
    final jumpersFromCountry = jumpers.fromCountryByCode(team.country.code);
    if (jumpersFromCountry.isEmpty) return null;
    final jumperRatings = {
      for (var jumper in jumpersFromCountry) jumper: _calculateRating(jumper),
    };
    return _bestJumper(jumperRatings);
  }

  @override
  Jumper? risingStar(CountryTeam team) {
    final jumpers =
        team.sex == Sex.male ? database.maleJumpers.last : database.femaleJumpers.last;
    final jumpersFromCountry = jumpers.fromCountryByCode(team.country.code);
    if (jumpersFromCountry.isEmpty) return null;
    final jumperRatings = {
      for (var jumper in jumpersFromCountry)
        jumper: _calculateRatingForRisingStar(jumper),
    };
    return _bestJumper(jumperRatings);
  }

  double _calculateRatingForRisingStar(Jumper jumper) {
    final base = _calculateRating(jumper);
    final age = jumper.age;
    const k = 27;
    final multiplierByAge = (age == 17) ? 1.0 : (1.0 / (1.0 + (age - 18).abs() / k));
    print('multiplier by age ($age): $multiplierByAge');
    return base * multiplierByAge;
  }

  double _calculateRating(Jumper jumper) {
    final skills = jumper.skills;
    final byQualityOnSmallerHills = skills.qualityOnSmallerHills * 1.0;
    final byQualityOnLargerHills = skills.qualityOnLargerHills * 1.0;
    final multiplierByConsistency = switch (skills.jumpsConsistency) {
      JumpsConsistency.veryConsistent => 1.08,
      JumpsConsistency.consistent => 1.04,
      JumpsConsistency.average => 1.0,
      JumpsConsistency.inconsistent => 0.96,
      JumpsConsistency.veryInconsistent => 0.92,
    };
    final multiplierByLandingStyle = switch (skills.landingStyle) {
      LandingStyle.perfect => 1.06,
      LandingStyle.veryGraceful => 1.04,
      LandingStyle.graceful => 1.02,
      LandingStyle.average => 1.00,
      LandingStyle.ugly => 0.98,
      LandingStyle.veryUgly => 0.96,
      LandingStyle.terrible => 0.94,
    };
    final rating = (byQualityOnSmallerHills + byQualityOnLargerHills) *
        multiplierByConsistency *
        multiplierByLandingStyle;
    return rating;
  }

  Jumper _bestJumper(Map<Jumper, double> jumperRatings) {
    return jumperRatings.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
