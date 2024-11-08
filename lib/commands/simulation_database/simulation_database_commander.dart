import 'package:sj_manager/algorithms/training_engine/jumper_training_result.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/personal_coach_team.dart';

class SimulationDatabaseCommander {
  const SimulationDatabaseCommander({
    required this.database,
  });

  final SimulationDatabase database;

  SimulationDatabase replaceJumper({
    required Jumper oldJumper,
    required Jumper newJumper,
  }) {
    var database = this.database;
    final changedJumpers = List.of(database.jumpers.last);
    changedJumpers[database.jumpers.last.indexOf(oldJumper)] = newJumper;
    database.jumpers.set(changedJumpers); // Maybe it doesn't work correctly

    database.idsRepo.update(
      id: database.idsRepo.idOf(oldJumper),
      newItem: newJumper,
    );

    database.jumperReports[newJumper] = database.jumperReports.remove(oldJumper)!;
    database.jumperDynamicParams[newJumper] =
        database.jumperDynamicParams.remove(oldJumper)!;
    database.jumperStats[newJumper] = database.jumperStats.remove(oldJumper)!;

    return database.copyWith();
  }

  SimulationDatabase changeJumperTraining({
    required Jumper jumper,
    required JumperTrainingConfig? config,
    bool forceNullTrainingConfig = false,
  }) {
    final changedDynamicParams = database.jumperDynamicParams;
    changedDynamicParams[jumper] = database.jumperDynamicParams[jumper]!.copyWith(
      trainingConfig: forceNullTrainingConfig ? null : config,
    );
    return database.copyWith(
      jumperDynamicParams: changedDynamicParams,
    );
  }

  SimulationDatabase setUpTrainings() {
    var database = this.database;
    for (final jumper in database.jumpers.last) {
      database =
          changeJumperTraining(jumper: jumper, config: initialJumperTrainingConfig);
    }
    database.actionsRepo.complete(SimulationActionType.settingUpTraining);
    return database;
  }

  SimulationDatabase setPartnerships({
    required List<Jumper> partnerships,
  }) {
    final oldUserTeam = database.managerData.personalCoachTeam!;
    final jumperIds = partnerships.map((jumper) => database.idsRepo.idOf(jumper));
    final newUserTeam = PersonalCoachTeam(jumperIds: jumperIds.toList().cast());
    final id = database.idsRepo.removeByItem(item: oldUserTeam);
    database.idsRepo.register(newUserTeam, id: id);
    final changedManagerData = database.managerData.copyWith(
      personalCoachTeam: newUserTeam,
    );
    final changedTeamReports = Map.of(database.teamReports);
    changedTeamReports[newUserTeam] = changedTeamReports.remove(oldUserTeam)!;
    final changedDynamicParams = Map.of(database.jumperDynamicParams);

    for (final jumper in partnerships) {
      if (changedDynamicParams.containsKey(jumper)) continue;
      changedDynamicParams[jumper] = changedDynamicParams[jumper]!.copyWith(
        trainingConfig: initialJumperTrainingConfig,
      );
    }

    return database.copyWith(
      managerData: changedManagerData,
      teamReports: changedTeamReports,
      jumperDynamicParams: changedDynamicParams,
    );
  }

  SimulationDatabase registerJumperTraining({
    required Jumper jumper,
    required JumperTrainingResult result,
    required DateTime date,
  }) {
    var database = this.database;
    final newJumper = jumper.copyWith(skills: result.skills);
    database = replaceJumper(
      oldJumper: jumper,
      newJumper: newJumper,
    );
    final stats = Map.of(database.jumperStats);
    final attributeHistory = Map.of(stats[newJumper]!.progressableAttributeHistory);
    attributeHistory[TrainingProgressCategory.takeoff]!
        .register(result.skills.takeoffQuality, date: date);
    attributeHistory[TrainingProgressCategory.flight]!
        .register(result.skills.flightQuality, date: date);
    attributeHistory[TrainingProgressCategory.landing]!
        .register(result.skills.landingQuality, date: date);
    attributeHistory[TrainingProgressCategory.form]!.register(result.form, date: date);
    attributeHistory[TrainingProgressCategory.consistency]!
        .register(result.jumpsConsistency, date: date);

    stats[newJumper] =
        stats[newJumper]!.copyWith(progressableAttributeHistory: attributeHistory);
    final dynamicParams = Map.of(database.jumperDynamicParams);
    dynamicParams[newJumper] = dynamicParams[newJumper]!.copyWith(
      form: result.form,
      jumpsConsistency: result.jumpsConsistency,
      fatigue: result.fatigue,
    );
    return database.copyWith(
      jumperDynamicParams: dynamicParams,
      jumperStats: stats,
    );
  }

  SimulationDatabase setMonthlyReport({
    required Jumper jumper,
    required TrainingReport? report,
  }) {
    final changedJumperReports = Map.of(database.jumperReports);
    changedJumperReports[jumper] =
        changedJumperReports[jumper]!.copyWith(monthlyTrainingReport: report);
    return database.copyWith(
      jumperReports: changedJumperReports,
    );
  }

  SimulationDatabase setWeeklyReport({
    required Jumper jumper,
    required TrainingReport? report,
  }) {
    final changedJumperReports = Map.of(database.jumperReports);
    changedJumperReports[jumper] =
        changedJumperReports[jumper]!.copyWith(weeklyTrainingReport: report);
    return database.copyWith(
      jumperReports: changedJumperReports,
    );
  }
}
