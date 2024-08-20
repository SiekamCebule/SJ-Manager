import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/running/competition_status.dart';

abstract class CompetitionStatusState with EquatableMixin {
  const CompetitionStatusState({
    required this.status,
    required this.roundIndex,
  });

  final CompetitionStatus status;
  final int roundIndex;

  CompetitionStatusState copyWith({
    CompetitionStatus? status,
    int? roundIndex,
  });

  @override
  List<Object?> get props => [
        status,
        roundIndex,
      ];
}

class IndividualCompetitionStatusState extends CompetitionStatusState {
  const IndividualCompetitionStatusState({
    required super.status,
    required super.roundIndex,
  });

  @override
  IndividualCompetitionStatusState copyWith({
    CompetitionStatus? status,
    int? roundIndex,
  }) {
    return IndividualCompetitionStatusState(
      status: status ?? this.status,
      roundIndex: roundIndex ?? this.roundIndex,
    );
  }
}

class TeamCompetitionStatusState extends CompetitionStatusState {
  const TeamCompetitionStatusState({
    required super.status,
    required super.roundIndex,
    required this.groupIndex,
  });

  final int groupIndex;

  @override
  List<Object?> get props => [
        super.props,
        groupIndex,
      ];

  TeamCompetitionStatusState concreteCopyWith({
    CompetitionStatus? status,
    int? roundIndex,
    int? groupIndex,
  }) {
    return TeamCompetitionStatusState(
      status: status ?? this.status,
      roundIndex: roundIndex ?? this.roundIndex,
      groupIndex: groupIndex ?? this.groupIndex,
    );
  }

  @override
  CompetitionStatusState copyWith({CompetitionStatus? status, int? roundIndex}) {
    throw UnimplementedError();
  }
}
