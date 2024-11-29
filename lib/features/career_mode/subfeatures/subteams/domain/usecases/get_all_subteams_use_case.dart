import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/repository/subteams_repository.dart';

class GetAllSubteamsUseCase {
  const GetAllSubteamsUseCase({
    required this.subteamsRepository,
  });

  final SubteamsRepository subteamsRepository;

  Future<Iterable<Subteam>> call() async {
    return await subteamsRepository.getAll();
  }
}
