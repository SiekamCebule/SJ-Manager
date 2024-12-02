import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

abstract interface class IndividualCompetitionScoreCreator
    implements CompetitionScoreCreator<SimulationJumper> {}
