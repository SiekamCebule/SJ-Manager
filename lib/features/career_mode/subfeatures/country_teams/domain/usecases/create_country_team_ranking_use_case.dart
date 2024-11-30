import 'package:sj_manager/features/career_mode/subfeatures/country_teams/utils/ranking_creator/country_team_ranking_creator.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/repository/country_teams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class CreateCountryTeamRankingUseCase {
  CreateCountryTeamRankingUseCase({
    required this.countryTeamsRepository,
    required this.jumpersRepository,
    required this.rankingCreator,
  });

  final CountryTeamsRepository countryTeamsRepository;
  final SimulationJumpersRepository jumpersRepository;
  final CountryTeamRankingCreator rankingCreator;

  Future<Iterable<SimulationJumper>> call(CountryTeam countryTeam) async {
    final jumpers = (await jumpersRepository.getAll())
        .where((jumper) => jumper.countryTeam == countryTeam);
    return rankingCreator.create(source: jumpers);
  }
}
