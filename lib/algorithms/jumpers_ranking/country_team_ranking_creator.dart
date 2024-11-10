import 'package:sj_manager/models/simulation/flow/jumper_dynamic_params.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class CountryTeamRankingCreator {
  const CountryTeamRankingCreator({
    required this.jumpers,
    required this.dynamicParams,
  });

  final List<Jumper> jumpers;
  final Map<Jumper, JumperDynamicParams> dynamicParams;

  List<Jumper> create() {
    final ratings = {
      for (final jumper in jumpers) jumper: _calculateRating(jumper),
    };
    final sorted = List.of(jumpers)
      ..sort((first, second) {
        return ratings[second]!.compareTo(ratings[first]!);
      });
    return sorted;
  }

  double _calculateRating(Jumper jumper) {
    return (jumper.skills.takeoffQuality / 1) +
        (jumper.skills.flightQuality / 1) +
        (jumper.skills.landingQuality / 10) +
        (dynamicParams[jumper]!.jumpsConsistency / 1.5) +
        (dynamicParams[jumper]!.form * 2);
  }
}

/*
takeoff quality: 15
flight quality: 15
landing quality: 15 / 10
jumps consistency: 14 / 1.5
form: 10 * 2
*/
