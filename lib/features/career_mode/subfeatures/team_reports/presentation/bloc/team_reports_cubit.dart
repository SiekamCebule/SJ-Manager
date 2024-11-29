import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/team_reports/domain/usecases/get_team_reports_map_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/reports/team_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

class TeamReportsCubit extends Cubit<TeamReportsState> {
  TeamReportsCubit({
    required this.getTeamReportsMap,
  }) : super(const TeamReportsInitial());

  final GetTeamReportsMapUseCase getTeamReportsMap;

  Future<void> initialize() async {
    emit(TeamReportsDefault(
      reports: await getTeamReportsMap(),
    ));
  }
}

abstract class TeamReportsState extends Equatable {
  const TeamReportsState();

  @override
  List<Object?> get props => [];
}

class TeamReportsInitial extends TeamReportsState {
  const TeamReportsInitial();
}

class TeamReportsDefault extends TeamReportsState {
  const TeamReportsDefault({
    required this.reports,
  });

  final Map<Team, TeamReports> reports;

  @override
  List<Object?> get props => [];
}
