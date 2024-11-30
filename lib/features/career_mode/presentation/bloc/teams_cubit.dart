import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/usecases/get_all_country_teams_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/usecases/get_subteams_by_country_team_map_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit({
    required this.getCountryTeamsUseCase,
    required this.getSubteamsByCountryTeamMapUseCase,
  }) : super(const TeamsInitial());

  final GetAllCountryTeamsUseCase getCountryTeamsUseCase;
  final GetSubteamsByCountryTeamMapUseCase getSubteamsByCountryTeamMapUseCase;

  Future<void> initialize() async {
    emit(
      TeamsDefault(
        countryTeams: await getCountryTeamsUseCase(),
        subteams: await getSubteamsByCountryTeamMapUseCase(),
      ),
    );
  }

  // setUpSubteams()
}

abstract class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object?> get props => [];
}

class TeamsInitial extends TeamsState {
  const TeamsInitial();
}

class TeamsDefault extends TeamsState {
  const TeamsDefault({
    required this.countryTeams,
    required this.subteams,
  });

  final Iterable<CountryTeam> countryTeams;
  final Map<CountryTeam, Iterable<Subteam>> subteams;

  @override
  List<Object?> get props => [
        countryTeams,
        subteams,
      ];
}
