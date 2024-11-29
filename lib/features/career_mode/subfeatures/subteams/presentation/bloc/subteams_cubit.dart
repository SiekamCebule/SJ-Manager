import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/usecases/get_all_subteams_use_case.dart';

class SubteamsCubit extends Cubit<SubteamsState> {
  SubteamsCubit({
    required this.getAllSubteams,
  }) : super(const SubteamsInitial());

  final GetAllSubteamsUseCase getAllSubteams;

  Future<void> initialize() async {
    emit(SubteamsDefault(
      subteams: await getAllSubteams(),
    ));
  }
}

abstract class SubteamsState extends Equatable {
  const SubteamsState();
}

class SubteamsInitial extends SubteamsState {
  const SubteamsInitial();

  @override
  List<Object?> get props => [];
}

class SubteamsDefault extends SubteamsState {
  const SubteamsDefault({
    required this.subteams,
  });

  final Iterable<Subteam> subteams;

  @override
  List<Object?> get props => [
        subteams,
      ];
}
