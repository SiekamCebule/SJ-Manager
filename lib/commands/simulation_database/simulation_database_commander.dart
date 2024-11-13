import 'package:sj_manager/algorithms/start_form/default_start_form_algorithm.dart';
import 'package:sj_manager/algorithms/training_engine/jumper_training_result.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/models/simulation/jumper/stats/jumper_stats.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/database/team/subteam.dart';

class SimulationDatabaseCommander {
  SimulationDatabaseCommander({
    required this.database,
  }) {
    dbHelper = SimulationDatabaseHelper(database: database);
  }

  late SimulationDatabaseHelper dbHelper;
  final SimulationDatabase database;

  /*SimulationDatabase setIdsRepo({
    required ItemsIdsRepo idsRepo,
  }) {
    return database.copyWith(
      idsRepo: ItemsIdsRepo.copyFrom(idsRepo),
    );
  }*/

  void changeJumperTraining({
    required SimulationJumper jumper,
    required JumperTrainingConfig? config,
    bool forceNullTrainingConfig = false,
  }) {
    jumper.trainingConfig = config;
    database.notify();
  }

  void setUpTrainings() {
    var database = this.database;
    for (final jumper in database.jumpers) {
      changeJumperTraining(jumper: jumper, config: initialJumperTrainingConfig);
      jumper.form = DefaultStartFormAlgorithm(baseForm: jumper.form).computeStartForm();
      print('jumper\'s form: ${jumper.form}');
    }
    database.actionsRepo.complete(SimulationActionType.settingUpTraining);
    database.notify();
  }

  void setPartnerships({
    required List<SimulationJumper> partnerships,
  }) {
    database.managerData.personalCoachTeam?.jumpers = partnerships;
    database.notify();
  }

  void clearSubteams() {
    database.subteamJumpers = {};
    database.notify();
  }

  void setSubteam({
    required Subteam subteam,
    required Iterable<SimulationJumper> jumpers,
    required String subteamNewId,
  }) {
    database.idsRepo.removeById(id: subteamNewId);
    database.idsRepo.register(subteam, id: subteamNewId);
    final jumperIds = jumpers.map(dbHelper.id);
    database.subteamJumpers[subteam] = jumperIds.toList();
    database.notify();
  }

  void registerJumperTraining({
    required SimulationJumper jumper,
    required JumperTrainingResult result,
    required DateTime date,
  }) {
    var database = this.database;
    jumper.takeoffQuality = result.takeoffQuality;
    jumper.flightQuality = result.flightQuality;
    jumper.landingQuality = result.landingQuality;
    jumper.form = result.form;
    jumper.jumpsConsistency = result.jumpsConsistency;
    jumper.fatigue = result.fatigue;

    final attributeHistory = dbHelper.jumperStats(jumper)!.progressableAttributeHistory;

    attributeHistory[TrainingProgressCategory.takeoff]!
        .register(result.takeoffQuality, date: date);
    attributeHistory[TrainingProgressCategory.flight]!
        .register(result.flightQuality, date: date);
    attributeHistory[TrainingProgressCategory.landing]!
        .register(result.landingQuality, date: date);
    attributeHistory[TrainingProgressCategory.form]!.register(result.form, date: date);
    attributeHistory[TrainingProgressCategory.consistency]!
        .register(result.jumpsConsistency, date: date);
    database.notify();
  }

  void setStats({
    required SimulationJumper jumper,
    required JumperStats stats,
  }) {
    database.jumperStats[dbHelper.id(jumper)] = stats;
    database.notify();
  }

  void setMonthlyReport({
    required SimulationJumper jumper,
    required TrainingReport? report,
  }) {
    database.jumperReports[dbHelper.id(jumper)]!.monthlyTrainingReport = report;
    database.notify();
  }

  void setWeeklyReport({
    required SimulationJumper jumper,
    required TrainingReport? report,
  }) {
    database.jumperReports[dbHelper.id(jumper)]!.weeklyTrainingReport = report;
    database.notify();
  }
}
