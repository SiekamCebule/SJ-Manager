import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class CountryTeam extends SimulationTeam with EquatableMixin {
  CountryTeam({
    required this.sex,
    required this.country,
    required this.subteams,
  });

  final Sex sex;
  final Country country;
  Iterable<Subteam> subteams;
  // TODO RECORD, STATS

  Iterable<SimulationJumper> get jumpers {
    return subteams.expand((subteams) => subteams.jumpers);
  }

  Subteam? getSubtem(SubteamType type) =>
      subteams.singleWhereOrNull((subteam) => subteam.type == type);

  @override
  List<Object?> get props => [
        sex,
        country,
        subteams,
      ];
}
