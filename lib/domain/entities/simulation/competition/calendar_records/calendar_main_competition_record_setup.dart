import 'package:equatable/equatable.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/default_competition_rules_preset_editor/default_competition_rules_editor.dart';

class CalendarMainCompetitionRecordSetup with EquatableMixin {
  const CalendarMainCompetitionRecordSetup({
    required this.mainCompRules,
    this.trainingsCount = 0,
    this.trainingsRules,
    this.trialRoundRules,
    this.qualificationsRules,
    this.moveQualificationsBeforeTeamCompetition = false,
  }) : assert(
          !(moveQualificationsBeforeTeamCompetition == true && trialRoundRules == null),
        );

  final DefaultCompetitionRulesProvider mainCompRules;
  final int trainingsCount;
  final DefaultCompetitionRulesProvider? trainingsRules;
  final DefaultCompetitionRulesProvider? trialRoundRules;
  final DefaultCompetitionRulesProvider? qualificationsRules;
  final bool moveQualificationsBeforeTeamCompetition;

  CompetitionTypeByEntity get typeByEntity {
    return mainCompRules.competitionRules is DefaultCompetitionRules<JumperDbRecord>
        ? CompetitionTypeByEntity.individual
        : CompetitionTypeByEntity.team;
  }

  @override
  List<Object?> get props => [
        mainCompRules,
        trainingsCount,
        trainingsRules,
        trialRoundRules,
        qualificationsRules,
        moveQualificationsBeforeTeamCompetition,
      ];
}
