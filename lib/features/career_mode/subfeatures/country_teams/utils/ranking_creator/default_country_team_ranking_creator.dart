import 'package:sj_manager/features/career_mode/subfeatures/country_teams/utils/ranking_creator/country_team_ranking_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class DefaultCountryTeamRankingCreator implements CountryTeamRankingCreator {
  @override
  List<SimulationJumper> create({
    required Iterable<SimulationJumper> source,
  }) {
    final ratings = {
      for (final jumper in source) jumper: _calculateRating(jumper),
    };
    final sorted = List.of(source)
      ..sort((first, second) {
        return ratings[second]!.compareTo(ratings[first]!);
      });
    return sorted;
  }

  double _calculateRating(SimulationJumper jumper) {
    return (jumper.takeoffQuality / 1) +
        (jumper.flightQuality / 1) +
        (jumper.landingQuality / 10) +
        (jumper.jumpsConsistency / 1.5) +
        (jumper.form * 2);
  }
}

/*
takeoff quality: 15
flight quality: 15
landing quality: 15 / 10
jumps consistency: 14 / 1.5
form: 10 * 2
*/
