import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/get_jumper_training_balance_for_all_categories_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/get_jumper_training_balance_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/set_jumper_training_balance_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_config/set_jumper_training_config_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class JumperTrainingCubit extends Cubit<JumperTrainingState> {
  JumperTrainingCubit({
    required this.getBalanceForAllCategories,
    required this.getBalance,
    required this.setBalance,
    required this.setTrainingConfig,
  }) : super(const JumperTrainingInitial());

  final GetJumperTrainingBalanceForAllCategoriesUseCase getBalanceForAllCategories;
  final GetJumperTrainingBalanceUseCase getBalance;
  final SetJumperTrainingBalanceUseCase setBalance;
  final SetJumperTrainingConfigUseCase setTrainingConfig;

  Future<void> toggleJumper(SimulationJumper jumper) async {
    if (state is JumperTrainingInitialized) {
      emit(const JumperTrainingInitial());
    } else {
      emit(
        JumperTrainingInitialized(
          jumper: jumper,
          balance: await getBalanceForAllCategories(jumper: jumper),
        ),
      );
    }
  }

  Future<void> changeTrainingConfig(JumperTrainingConfig trainingConfig) async {
    final state = this.state;
    if (state is! JumperTrainingInitialized) {
      throw StateError('Cannot change training config when no jumper is chosen');
    }
    await setTrainingConfig(
      jumper: state.jumper,
      trainingConfig: trainingConfig,
    );
    emit(
      state.copyWith(
        balance: await getBalanceForAllCategories(jumper: state.jumper),
      ),
    );
  }
}

abstract class JumperTrainingState extends Equatable {
  const JumperTrainingState();
}

class JumperTrainingInitial extends JumperTrainingState {
  const JumperTrainingInitial();

  @override
  List<Object?> get props => [];
}

class JumperTrainingInitialized extends JumperTrainingState {
  const JumperTrainingInitialized({
    required this.jumper,
    required this.balance,
  });

  final SimulationJumper jumper;
  final Map<JumperTrainingCategory, double> balance;

  @override
  List<Object?> get props => [balance];

  JumperTrainingInitialized copyWith({
    SimulationJumper? jumper,
    Map<JumperTrainingCategory, double>? balance,
  }) {
    return JumperTrainingInitialized(
      jumper: jumper ?? this.jumper,
      balance: balance ?? this.balance,
    );
  }
}
