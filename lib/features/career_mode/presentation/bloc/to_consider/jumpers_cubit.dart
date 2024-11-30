import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/usecases/get_all_female_jumpers_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/usecases/get_all_jumpers_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/usecases/get_all_male_jumpers_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class JumpersCubit extends Cubit<JumpersState> {
  JumpersCubit({
    required this.getAllJumpers,
    required this.getAllMaleJumpers,
    required this.getAllFemaleJumpers,
  }) : super(const JumpersInitial());

  final GetAllJumpersUseCase getAllJumpers;
  final GetAllMaleJumpersUseCase getAllMaleJumpers;
  final GetAllFemaleJumpersUseCase getAllFemaleJumpers;

  Future<void> initialize() async {
    emit(JumpersDefault(
      jumpers: await getAllJumpers(),
      maleJumpers: await getAllMaleJumpers(),
      femaleJumpers: await getAllFemaleJumpers(),
    ));
    await getAllJumpers();
  }

  // Future<void> addJumper() async {}
}

abstract class JumpersState extends Equatable {
  const JumpersState();

  @override
  List<Object?> get props => [];
}

class JumpersInitial extends JumpersState {
  const JumpersInitial();
}

class JumpersDefault extends JumpersState {
  const JumpersDefault({
    required this.jumpers,
    required this.maleJumpers,
    required this.femaleJumpers,
  });

  final Iterable<SimulationJumper> jumpers;
  final Iterable<SimulationJumper> maleJumpers;
  final Iterable<SimulationJumper> femaleJumpers;

  @override
  List<Object?> get props => [
        jumpers,
        maleJumpers,
        femaleJumpers,
      ];
}
