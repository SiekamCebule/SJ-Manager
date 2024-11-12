import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';

class CountryTeamRankingCreator {
  const CountryTeamRankingCreator({
    required this.jumpers,
  });

  final List<SimulationJumper> jumpers;

  List<SimulationJumper> create() {
    final ratings = {
      for (final jumper in jumpers) jumper: _calculateRating(jumper),
    };
    final sorted = List.of(jumpers)
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
