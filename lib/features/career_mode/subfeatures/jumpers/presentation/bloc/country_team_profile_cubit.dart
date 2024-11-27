import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/usecases/create_country_team_ranking_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/usecases/get_all_country_subteams_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/usecases/get_country_team_jumpers_use_case.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';

class CountryTeamProfileCubit extends Cubit<CountryTeamProfileState> {
  CountryTeamProfileCubit({
    required this.getCountryTeamJumpers,
    required this.createRanking,
    required this.getAllCountrySubteams,
  }) : super(const CountryTeamProfileInitial());

  final GetCountryTeamJumpersUseCase getCountryTeamJumpers;
  final CreateCountryTeamRankingUseCase createRanking;
  final GetAllCountrySubteamsUseCase getAllCountrySubteams;

  Future<void> setUp({
    required CountryTeam countryTeam,
  }) async {
    emit(
      CountryTeamProfileDefault(
        countryTeam: countryTeam,
        jumpers: await getCountryTeamJumpers(countryTeam),
        ranking: await createRanking(countryTeam),
        subteams: await getAllCountrySubteams(countryTeam),
      ),
    );
  }
}

abstract class CountryTeamProfileState extends Equatable {
  const CountryTeamProfileState();

  @override
  List<Object?> get props => [];
}

class CountryTeamProfileInitial extends CountryTeamProfileState {
  const CountryTeamProfileInitial();
}

class CountryTeamProfileDefault extends CountryTeamProfileState {
  const CountryTeamProfileDefault({
    required this.countryTeam,
    required this.jumpers,
    required this.ranking,
    required this.subteams,
  });

  final CountryTeam countryTeam;
  final Iterable<SimulationJumper> jumpers;
  final Iterable<SimulationJumper> ranking;
  final Iterable<Subteam> subteams;

  @override
  List<Object?> get props => [
        countryTeam,
        jumpers,
      ];
}
