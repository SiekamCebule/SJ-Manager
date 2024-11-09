import 'package:sj_manager/algorithms/subteam_appointments/partial/partial_appointments_algorithm.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/psyche/personalities.dart';
import 'package:sj_manager/utils/random/random.dart';

class DefaultPartialAppointmentsAlgorithm implements PartialAppointmentsAlgorithm {
  const DefaultPartialAppointmentsAlgorithm();

  @override
  Iterable<Jumper> chooseBestJumpers({
    required Iterable<Jumper> source,
    required Map<Jumper, double> form,
    required int limit,
  }) {
    final baseSeed = DateTime.now().millisecondsSinceEpoch;
    final seed = {
      for (var i = 0; i < source.length; i++) source.elementAt(i): baseSeed + i,
    };
    double calculateRating(Jumper jumper) {
      final personalityBonus = switch (jumper.personality) {
        Personalities.compromised => 3,
        Personalities.selfCritical => 3,
        Personalities.resigned => 4,
        Personalities.nostalgic => 4,
        Personalities.insecure => 4.5,
        Personalities.yearning => 5,
        Personalities.stubborn => 5,
        Personalities.arrogant => 6,
        Personalities.resourceful => 8,
        Personalities.balanced => 9.5,
        Personalities.optimistic => 11,
        Personalities.open => 12,
        Personalities.rational => 12,
        Personalities.devoted => 15,
        Personalities.spiritualJoy => 15,
        Personalities.spiritualPeace => 15,
        Personalities.enlightened => 15,
      };

      final randomBonus = linearRandomDouble(-2, 2, seed: seed[jumper]!);

      final byTakeoff = (jumper.skills.takeoffQuality / 1);
      final byFlight = (jumper.skills.flightQuality / 1);
      final byPersonality = (personalityBonus / 3);
      final byForm = (form[jumper]! / 4);
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
