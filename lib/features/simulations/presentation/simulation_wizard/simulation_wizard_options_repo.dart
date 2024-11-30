import 'package:flutter/widgets.dart';
import 'package:sj_manager/core/core_classes/game_variant_start_date.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

class SimulationWizardOptions with ChangeNotifier {
  SimulationWizardOptions();

  SimulationMode? _mode;
  GameVariantStartDate? _startDate;
  GameVariant? _gameVariant;
  CountryTeamDbRecord? _team;
  SubteamType? _subteamType;
  bool? _archiveEndedSeasonResults;
  bool? _showJumperSkills;
  bool? _showJumperDynamicParameters;
  String? _simulationId;
  String? _simulationName;

  SimulationMode? get mode => _mode;
  set mode(SimulationMode? value) {
    if (_mode != value) {
      _mode = value;
      notifyListeners();
    }
  }

  GameVariantStartDate? get startDate => _startDate;
  set startDate(GameVariantStartDate? value) {
    if (_startDate != value) {
      _startDate = value;
      notifyListeners();
    }
  }

  GameVariant? get gameVariant => _gameVariant;
  set gameVariant(GameVariant? value) {
    if (_gameVariant != value) {
      _gameVariant = value;
      notifyListeners();
    }
  }

  CountryTeamDbRecord? get team => _team;
  set team(CountryTeamDbRecord? value) {
    if (_team != value) {
      _team = value;
      notifyListeners();
    }
  }

  SubteamType? get subteamType => _subteamType;
  set subteamType(SubteamType? value) {
    if (_subteamType != value) {
      _subteamType = value;
      notifyListeners();
    }
  }

  bool? get archiveEndedSeasonResults => _archiveEndedSeasonResults;
  set archiveEndedSeasonResults(bool? value) {
    if (_archiveEndedSeasonResults != value) {
      _archiveEndedSeasonResults = value;
      notifyListeners();
    }
  }

  bool? get showJumperSkills => _showJumperSkills;
  set showJumperSkills(bool? value) {
    if (_showJumperSkills != value) {
      _showJumperSkills = value;
      notifyListeners();
    }
  }

  bool? get showJumperDynamicParameters => _showJumperDynamicParameters;
  set showJumperDynamicParameters(bool? value) {
    if (_showJumperDynamicParameters != value) {
      _showJumperDynamicParameters = value;
      notifyListeners();
    }
  }

  String? get simulationId => _simulationId;
  set simulationId(String? value) {
    if (_simulationId != value) {
      _simulationId = value;
      notifyListeners();
    }
  }

  String? get simulationName => _simulationName;
  set simulationName(String? value) {
    if (_simulationName != value) {
      _simulationName = value;
      notifyListeners();
    }
  }
}
