import 'package:sj_manager/core/career_mode/career_mode_utils/start_form/default_start_form_algorithm.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training/training_engine/jumper_training_result.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database_helper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/stats/jumper_stats.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/training/jumper_training_config.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/subteam.dart';

class SimulationDatabaseUseCases {
  SimulationDatabaseUseCases({
    required this.database,
  }) {
    dbHelper = SimulationDatabaseHelper(database: database);
  }

  late SimulationDatabaseHelper dbHelper;
  final SimulationDatabase database;

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
    database.idsRepository.removeById(id: subteamNewId);
    database.idsRepository.register(subteam, id: subteamNewId);
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

    final attributeHistory = jumper.stats.progressableAttributeHistory;

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
    jumper.stats = stats;
    database.notify();
  }

  void setMonthlyReport({
    required SimulationJumper jumper,
    required TrainingReport? report,
  }) {
    jumper.reports.monthlyTrainingReport = report;
    database.notify();
  }

  void setWeeklyReport({
    required SimulationJumper jumper,
    required TrainingReport? report,
  }) {
    jumper.reports.weeklyTrainingReport = report;
    database.notify();
  }

  void setLevelReport({
    required SimulationJumper jumper,
    required JumperLevelReport? report,
  }) {
    jumper.reports.levelReport = report;
    database.notify();
  }
}
