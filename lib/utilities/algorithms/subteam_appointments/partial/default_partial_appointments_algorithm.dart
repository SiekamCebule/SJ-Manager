import 'package:sj_manager/utilities/algorithms/subteam_appointments/partial/partial_appointments_algorithm.dart';
import 'package:sj_manager/data/models/database/psyche/level_of_consciousness.dart';
import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/utilities/utils/random/random.dart';

class DefaultPartialAppointmentsAlgorithm implements PartialAppointmentsAlgorithm {
  const DefaultPartialAppointmentsAlgorithm();

  @override
  Iterable<SimulationJumper> chooseBestJumpers({
    required Iterable<SimulationJumper> source,
    required int limit,
  }) {
    final baseSeed = DateTime.now().millisecondsSinceEpoch;
    final seed = {
      for (var i = 0; i < source.length; i++) source.elementAt(i): baseSeed + i,
    };
    double calculateRating(SimulationJumper jumper) {
      final consciouenssBonus = switch (jumper.levelOfConsciousness.label) {
        LevelOfConsciousnessLabels.shame => 3,
        LevelOfConsciousnessLabels.guilt => 3,
        LevelOfConsciousnessLabels.apathy => 4,
        LevelOfConsciousnessLabels.grief => 4,
        LevelOfConsciousnessLabels.fear => 4.5,
        LevelOfConsciousnessLabels.desire => 5,
        LevelOfConsciousnessLabels.anger => 5,
        LevelOfConsciousnessLabels.pride => 6,
        LevelOfConsciousnessLabels.courage => 8,
        LevelOfConsciousnessLabels.neutrality => 9.5,
        LevelOfConsciousnessLabels.willingness => 11,
        LevelOfConsciousnessLabels.acceptance => 12,
        LevelOfConsciousnessLabels.reason => 12,
        LevelOfConsciousnessLabels.love => 15,
        LevelOfConsciousnessLabels.joy => 15,
        LevelOfConsciousnessLabels.peace => 15,
        LevelOfConsciousnessLabels.enlightenment => 15,
      };

      final randomBonus = linearRandomDouble(-2, 2, seed: seed[jumper]!);

      final byTakeoff = (jumper.takeoffQuality / 1);
      final byFlight = (jumper.flightQuality / 1);
      final byPersonality = (consciouenssBonus / 3);
      final byForm = (jumper.form / 4);
      final byRandom = (randomBonus / 1);

      final rating = byTakeoff + byFlight + byPersonality + byForm + byRandom;

      print('--- Rating Calculation for Jumper: ${jumper.nameAndSurname()} ---');
      print('Takeoff: $byTakeoff');
      print('Flight: $byFlight');
      print('Personality: $byPersonality');
      print('Form: $byForm');
      print('Random: $byRandom');
      print('Sum: $rating');
      print('-------------------------------------------');

      return rating;
    }

    final sortedByRating = List.of(source)
      ..sort(
          (first, second) => calculateRating(second).compareTo(calculateRating(first)));
    return sortedByRating.take(limit);
  }
}
