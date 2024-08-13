import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/user_algorithms/concrete/classification_score_creator.dart';
import 'package:sj_manager/models/user_algorithms/concrete/competition_score_creator.dart';
import 'package:sj_manager/models/user_algorithms/concrete/jump_score_creator.dart';
import 'package:sj_manager/models/user_algorithms/concrete/significant_judges_chooser.dart';
import 'package:sj_manager/models/user_algorithms/concrete/wind_averager.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:sj_manager/setup/loading_from_file/db_items_list_loader_from_file_high_level_wrapper.dart';
import 'package:sj_manager/setup/loading_user_algorithms/user_algorithms_list_loader_high_level_wrapper.dart';

List<DbItemsListLoader> defaultDbItemsListLoaders(BuildContext context) => [
      DbItemsListLoaderFromFileHighLevelWrapper<Country>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku z krajami',
        loadingFailedDialogTitle: 'Nie udało się wczytać krajów',
        processItems: (source) {
          return source
              .map((country) => country.copyWith(code: country.code.toLowerCase()))
              .toList();
        },
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<Team>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku z zespołami',
        loadingFailedDialogTitle: 'Nie udało się wczytać zespołów',
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<MaleJumper>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku ze skoczkami',
        loadingFailedDialogTitle: 'Nie udało się wczytać skoczków',
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<FemaleJumper>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku ze skoczkiniami',
        loadingFailedDialogTitle: 'Nie udało się wczytać skoczkiń',
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<Hill>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku ze skoczniami',
        loadingFailedDialogTitle: 'Nie udało się wczytać skoczni',
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<EventSeriesSetup>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku z cyklami zawodów',
        loadingFailedDialogTitle: 'Nie udało się wczytać cyklów zawodów',
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<EventSeriesCalendarPreset>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku z kalendarzami',
        loadingFailedDialogTitle: 'Nie udało się wczytać kalendarzy',
      ).toLowLevel(context),
      const DbItemsListLoaderFromFileHighLevelWrapper<CompetitionRulesPreset>(
        fileNotFoundDialogTitle: 'Nie znaleziono pliku z presetami konkursów',
        loadingFailedDialogTitle: 'Nie udało się wczytać cyklów presetów konkursów',
      ).toLowLevel(context),
      const UserAlgorithmsListLoaderHighLevelWrapper<
          UserAlgorithm<ClassificationScoreCreator>>(
        directoryNotFoundDialogTitle:
            'Nie znaleziono folderu z kreatorami wyników klasyfikacji',
        loadingFailedDialogTitle: 'Nie udało się wczytać kreatora wyników klasyfikacji',
      ).toLowLevel(context),
      const UserAlgorithmsListLoaderHighLevelWrapper<
          UserAlgorithm<CompetitionScoreCreator>>(
        directoryNotFoundDialogTitle:
            'Nie znaleziono folderu z kreatorami wyników konkursowych',
        loadingFailedDialogTitle: 'Nie udało się wczytać kreatora wyników konkursowych',
      ).toLowLevel(context),
      const UserAlgorithmsListLoaderHighLevelWrapper<UserAlgorithm<JumpScoreCreator>>(
        directoryNotFoundDialogTitle:
            'Nie znaleziono folderu z kreatorami wyników za skok',
        loadingFailedDialogTitle: 'Nie udało się wczytać kreatora wyników za skok',
      ).toLowLevel(context),
      const UserAlgorithmsListLoaderHighLevelWrapper<
          UserAlgorithm<SignificantJudgesChooser>>(
        directoryNotFoundDialogTitle:
            'Nie znaleziono folderu z selekcjonerami not sędziowskich',
        loadingFailedDialogTitle: 'Nie udało się wczytać selekcjonera not sędziowskich',
      ).toLowLevel(context),
      const UserAlgorithmsListLoaderHighLevelWrapper<UserAlgorithm<WindAverager>>(
        directoryNotFoundDialogTitle: 'Nie znaleziono folderu z uśredniaczami wiatru',
        loadingFailedDialogTitle: 'Nie udało się wczytać uśredniacza wiatru',
      ).toLowLevel(context),
    ];
