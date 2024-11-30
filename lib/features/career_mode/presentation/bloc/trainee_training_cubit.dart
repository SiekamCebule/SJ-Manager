import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';

import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/get_jumper_training_balance_for_all_categories_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/set_jumper_training_balance_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/set_jumper_training_config_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class TraineeTrainingCubit extends Cubit<TraineeTrainingState> {
  TraineeTrainingCubit({
    required this.getBalanceForAllCategories,
    required this.setBalanceUseCase,
    required this.setTrainingConfigUseCase,
  }) : super(const TraineeTrainingInitial());

  final GetJumperTrainingBalanceForAllCategoriesUseCase getBalanceForAllCategories;
  final SetJumperTrainingBalanceUseCase setBalanceUseCase;
  final SetJumperTrainingConfigUseCase setTrainingConfigUseCase;

  Future<void> select(SimulationJumper trainee) async {
    if (state is TraineeTrainingChosen) {
      emit(const TraineeTrainingInitial());
    } else {
      emit(
        TraineeTrainingChosen(
          trainee: trainee,
          balance: await getBalanceForAllCategories(jumper: trainee),
        ),
      );
    }
  }

  Future<void> setTrainingConfig({
    required JumperTrainingConfig trainingConfig,
  }) async {
    final state = this.state;
    if (state is! TraineeTrainingChosen) {
      throw StateError(
        'Cannot change training config ($trainingConfig) when no trainee is chosen',
      );
    }
    await setTrainingConfigUseCase(jumper: state.trainee, trainingConfig: trainingConfig);
    emit(state.copyWith(
      balance: await getBalanceForAllCategories(jumper: state.trainee),
    ));
  }

  Future<void> changeTrainingBalance({
    required JumperTrainingCategory category,
    required double balance,
  }) async {
    final state = this.state;
    if (state is! TraineeTrainingChosen) {
      throw StateError(
          'Cannot change training balance ($category, $balance) when no trainee is chosen');
    }
    await setBalanceUseCase(
      jumper: state.trainee,
      category: category,
      balance: balance,
    );
    emit(state.copyWith(
      balance: await getBalanceForAllCategories(jumper: state.trainee),
    ));
  }
}

abstract class TraineeTrainingState extends Equatable {
  const TraineeTrainingState();
}

class TraineeTrainingInitial extends TraineeTrainingState {
  const TraineeTrainingInitial();

  @override
  List<Object?> get props => [];
}

class TraineeTrainingChosen extends TraineeTrainingState {
  const TraineeTrainingChosen({
    required this.trainee,
    required this.balance,
  });

  final SimulationJumper trainee;
  final Map<JumperTrainingCategory, double> balance;

  @override
  List<Object?> get props => [balance];

  TraineeTrainingChosen copyWith({
    SimulationJumper? trainee,
    Map<JumperTrainingCategory, double>? balance,
  }) {
    return TraineeTrainingChosen(
      trainee: trainee ?? this.trainee,
      balance: balance ?? this.balance,
    );
  }
}
