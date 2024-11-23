import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/judges_creator/judges_creator.dart';

class CompetitionJudgingCubit extends Cubit<CompetitionJudgingState> {
  CompetitionJudgingCubit({
    required this.judgesCreator,
  }) : super(const CompetitionJudgingNoJudges());

  final JudgesCreator judgesCreator;

  void judgeJumpStyle({
    required JudgesCreatingContext context,
    required Duration Function(int judgeIndex)? delayJudgeShowing,
  }) {
    final judges = judgesCreator.compute(context);

    emit(
      CompetitionJudgingHasData(
        judges: judges,
        availableIndexes: delayJudgeShowing != null
            ? const {}
            : List.generate(
                judges.length,
                (idx) => idx,
              ).toSet(),
      ),
    );

    if (delayJudgeShowing != null) {
      for (var judgeIndex = 0; judgeIndex < judges.length; judgeIndex++) {
        final delay = delayJudgeShowing(judgeIndex);
        Future.delayed(delay, () {
          final castedState = state as CompetitionJudgingHasData;
          emit(castedState.withAddedAvailableIndex(judgeIndex));
        });
      }
    }
  }
}

abstract class CompetitionJudgingState {
  const CompetitionJudgingState();
}

class CompetitionJudgingNoJudges extends CompetitionJudgingState {
  const CompetitionJudgingNoJudges();
}

class CompetitionJudgingHasData extends CompetitionJudgingState with EquatableMixin {
  const CompetitionJudgingHasData({
    required this.judges,
    required this.availableIndexes,
  });

  final List<double> judges;
  final Set<int> availableIndexes;

  CompetitionJudgingHasData withAddedAvailableIndex(int index) {
    final newAvailableIndexes = Set.of(availableIndexes);
    newAvailableIndexes.add(index);
    return copyWith(availableIndexes: newAvailableIndexes);
  }

  CompetitionJudgingHasData copyWith({
    List<double>? judges,
    Set<int>? availableIndexes,
  }) {
    return CompetitionJudgingHasData(
      judges: judges ?? this.judges,
      availableIndexes: availableIndexes ?? this.availableIndexes,
    );
  }

  @override
  List<Object?> get props => [
        judges,
        availableIndexes,
      ];
}
