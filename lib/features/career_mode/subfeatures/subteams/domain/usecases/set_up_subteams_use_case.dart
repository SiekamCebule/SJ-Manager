import 'package:sj_manager/core/career_mode/career_mode_utils/subteam_appointments/partial/default_partial_appointments_algorithm.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/repository/country_teams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/repository/subteams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class SetUpSubteamsUseCase {
  SetUpSubteamsUseCase({
    required this.jumpersRepository,
    required this.actionsRepository,
    required this.managerDataRepository,
    required this.countryTeamsRepository,
    required this.subteamsRepository,
  });

  final SimulationJumpersRepository jumpersRepository;
  final SimulationActionsRepository actionsRepository;
  final SimulationManagerDataRepository managerDataRepository;
  final CountryTeamsRepository countryTeamsRepository;
  final SubteamsRepository subteamsRepository;

  Future<void> call() async {
    final managerData = await managerDataRepository.get();
    final countryTeams = await countryTeamsRepository.getAll();
    final jumpers = await jumpersRepository.getAll();

    if (managerData.mode == SimulationMode.classicCoach) {
    } else {
      for (final countryTeam in countryTeams) {
        final subteams =
            await _chooseSubteams(countryTeam: countryTeam, simulationJumpers: jumpers);
        subteams.forEach((subteamType, jumpers) async {
          final subteam = Subteam(
            parentTeam: countryTeam,
            type: subteamType,
            jumpers: jumpers,
          );
          await subteamsRepository.setSubteam(subteam: subteam);
        });
      }
    }
    await actionsRepository.complete(SimulationActionType.settingUpSubteams);
  }

  Future<Map<SubteamType, Iterable<SimulationJumper>>> _chooseSubteams({
    required CountryTeam countryTeam,
    required Iterable<SimulationJumper> simulationJumpers,
  }) async {
    var availableJumpers = simulationJumpers.where(
      (jumper) => jumper.country == countryTeam.country,
    );
    final subteamJumpers = <SubteamType, Iterable<SimulationJumper>>{};

    for (final subteam in countryTeam.subteams) {
      if (availableJumpers.isEmpty) {
        return subteamJumpers;
      }
      final limit = countryTeam.limitInSubteam[subteam.type]!;
      const algorithm = DefaultPartialAppointmentsAlgorithm();
      final chosenJumpers = algorithm.chooseBestJumpers(
        source: availableJumpers,
        limit: limit,
      );
      subteamJumpers[subteam.type] = chosenJumpers;
      availableJumpers = availableJumpers.toSet().difference(chosenJumpers.toSet());
    }

    return subteamJumpers;
  }
}
