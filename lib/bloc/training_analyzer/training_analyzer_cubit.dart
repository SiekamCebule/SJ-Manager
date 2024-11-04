import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

import 'package:sj_manager/bloc/training_analyzer/training_test_runner.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/training_analyzer/actions.dart';
import 'package:sj_manager/models/training_analyzer/chart_data_category.dart';
import 'package:sj_manager/models/training_analyzer/training_analyzer_result.dart';
import 'package:sj_manager/models/training_analyzer/training_segment.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness.dart';
import 'package:sj_manager/algorithms/training_engine/jumper_training_engine_settings.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/training_analyzer_utils.dart';

class TrainingAnalyzerCubit extends Cubit<TrainingAnalyzerNotSimulated> {
  TrainingAnalyzerCubit()
      : super(TrainingAnalyzerNotSimulated(
            dataCategories: TrainingAnalyzerDataCategory.values.toSet()));

  void simulate(
      {required PlarformSpecificPathsCache pathsCache,
      Set<TrainingAnalyzerActions> additionalActions = const {}}) {
    late final Json configJson;
    try {
      final configFile =
          userDataFile(pathsCache, path.join('training_analyzer', 'config.json'));
      configJson = jsonDecode(configFile.readAsStringSync()) as Json;
    } catch (e) {
      debugPrint(
          'Błąd podczas wczytywania konfiguracji (config.json). Oryginalna treść błędu: $e');
      rethrow;
    }
    final engineSettingsJson = configJson['engineSettings'] as Json;
    final dynamicParamsJson = configJson['dynamicParams'] as Json;
    final skillsJson = configJson['jumperSkills'] as Json;
    final segmentsJson = (configJson['trainingSegments'] as List).cast<Json>();

    final engineSettings = JumperTrainingEngineSettings.fromJson(engineSettingsJson);
    final jumperSkills = JumperSkills.fromJson(skillsJson);

    final dynamicParams = JumperDynamicParams(
      trainingConfig: null,
      form: (dynamicParamsJson['form'] as num).toDouble(),
      jumpsConsistency: (dynamicParamsJson['jumpsConsistency'] as num).toDouble(),
      morale: (dynamicParamsJson['morale'] as num).toDouble(),
      fatigue: (dynamicParamsJson['fatigue'] as num).toDouble(),
      levelOfConsciousness: LevelOfConsciousness.fromMapOfConsciousness(
        LevelOfConsciousnessLabels.values.singleWhere(
          (lbl) => lbl.name == dynamicParamsJson['levelOfConsciousness'],
        ),
      ),
    );

    final trainingSegments = segmentsJson.map((segmentJson) => TrainingSegment(
          start: segmentJson['start'],
          end: segmentJson['end'],
          trainingConfig: JumperTrainingConfig(
            balance: (segmentJson['trainingConfig']['balance'] as Map).map(
              (categoryName, value) => MapEntry(
                JumperTrainingCategory.values
                    .singleWhere((value) => value.name == categoryName),
                (value as num).toDouble(),
              ),
            ),
          ),
        ));

    final runner = TrainingTestRunner(
      segments: trainingSegments.toList(),
      dynamicParams: dynamicParams,
      jumperSkills: jumperSkills,
      engineSettings: engineSettings,
      daysToSimulate: configJson['daysToSimulate'],
    );

    final result = runner.run();

    if (additionalActions.contains(TrainingAnalyzerActions.saveFormattedTxt)) {
      final buffer = StringBuffer();
      for (var day = 1; day <= result.dayResults.length; day++) {
        final dayResult = result.dayResults[day - 1];
        buffer.writeln(
            'Dzień $day: ${formatJumperTrainingResultResultForAnalyzer(dayResult.trainingResult)}');
      }
      final resultsFile = userDataFile(
          pathsCache, path.join('training_analyzer', 'formatted_results.txt'));
      resultsFile.writeAsStringSync(buffer.toString());
    }
    if (additionalActions.contains(TrainingAnalyzerActions.saveCsv)) {
      final resultsFile =
          userDataFile(pathsCache, path.join('training_analyzer', 'results.csv'));
      final csv = TrainingAnalyzerDaySimulationResult.listToCsv(result.dayResults,
          delimiter: ';');
      resultsFile.writeAsStringSync(csv);
    }
    if (additionalActions.contains(TrainingAnalyzerActions.saveAttributeStats)) {
      _writeAttributeStats(
        result.dayResults
            .map((result) => result.trainingResult.skills.takeoffQuality)
            .toList(),
        userDataFile(pathsCache, path.join('training_analyzer', 'takeoff_stats.txt')),
      );
      _writeAttributeStats(
        result.dayResults
            .map((result) => result.trainingResult.skills.flightQuality)
            .toList(),
        userDataFile(pathsCache, path.join('training_analyzer', 'flight_stats.txt')),
      );
      _writeAttributeStats(
        result.dayResults
            .map((result) => result.trainingResult.skills.landingQuality)
            .toList(),
        userDataFile(pathsCache, path.join('training_analyzer', 'landing_stats.txt')),
      );
      _writeAttributeStats(
        result.dayResults.map((result) => result.trainingResult.form).toList(),
        userDataFile(pathsCache, path.join('training_analyzer', 'form_stats.txt')),
      );
    }

    emit(
      TrainingAnalyzerSimulated(
        result: result,
        dataCategories: state.dataCategories,
      ),
    );
  }

  void _writeAttributeStats(List<double> values, File file) {
    final buffer = StringBuffer();

    var deltas = <double>[];
    for (int i = 0; i < values.length - 1; i++) {
      deltas.add(values[i + 1] - values[i]);
    }
    deltas.sort((a, b) => b.abs().compareTo(a.abs()));

    final deltasMaxRange = 25.clamp(0, values.length);
    buffer.writeln('TOP $deltasMaxRange zmian wartości:');
    for (var i = 0; i < deltasMaxRange; i++) {
      final delta = deltas[i];
      var furtherText = delta != 0 ? delta.abs().toStringAsFixed(2) : '';
      buffer.writeln('${i + 1}.   $furtherText');
    }

    final sortedForm = List.of(values)..sort((first, second) => second.compareTo(first));
    final highFormMaxRange = 25.clamp(0, values.length);
    buffer.writeln('\n\nTOP $highFormMaxRange najwyższych wartości');
    for (var i = 0; i < highFormMaxRange; i++) {
      final delta = sortedForm[i];
      var furtherText = delta != 0 ? delta.abs().toStringAsFixed(2) : '';
      buffer.writeln('${i + 1}.   $furtherText');
    }

    sortedForm.sort((first, second) => first.compareTo(second));
    final lowFormMaxRange = 25.clamp(0, values.length);
    buffer.writeln('\n\nTOP $lowFormMaxRange najniższych wartości');
    for (var i = 0; i < lowFormMaxRange; i++) {
      final delta = sortedForm[i];
      var furtherText = delta != 0 ? delta.abs().toStringAsFixed(2) : '';
      buffer.writeln('${i + 1}.   $furtherText');
    }

    file.writeAsStringSync(buffer.toString());
  }

  void setCategories(Set<TrainingAnalyzerDataCategory> categories) {
    if (state.runtimeType == TrainingAnalyzerNotSimulated) {
      emit(state.copyWith(dataCategories: categories));
    } else if (state.runtimeType == TrainingAnalyzerSimulated) {
      emit((state as TrainingAnalyzerSimulated).copyWith(
        dataCategories: categories,
      ));
    }
  }
}

class TrainingAnalyzerNotSimulated with EquatableMixin {
  const TrainingAnalyzerNotSimulated({
    required this.dataCategories,
  });

  final Set<TrainingAnalyzerDataCategory> dataCategories;

  @override
  List<Object?> get props => [
        dataCategories,
      ];

  TrainingAnalyzerNotSimulated copyWith({
    Set<TrainingAnalyzerDataCategory>? dataCategories,
  }) {
    return TrainingAnalyzerNotSimulated(
      dataCategories: dataCategories ?? this.dataCategories,
    );
  }
}

class TrainingAnalyzerSimulated extends TrainingAnalyzerNotSimulated {
  const TrainingAnalyzerSimulated({
    required this.result,
    required super.dataCategories,
  });

  final TrainingAnalyzerResult result;

  @override
  List<Object?> get props => [
        result,
        super.props,
      ];

  @override
  TrainingAnalyzerSimulated copyWith({
    TrainingAnalyzerResult? result,
    Set<TrainingAnalyzerDataCategory>? dataCategories,
  }) {
    return TrainingAnalyzerSimulated(
      result: result ?? this.result,
      dataCategories: dataCategories ?? this.dataCategories,
    );
  }
}
