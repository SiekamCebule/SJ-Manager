part of 'local_db_repos_cubit.dart';

class LocalDbReposState extends Equatable {
  const LocalDbReposState({
    required this.prepared,
    required this.editableRepositories,
  });

  final bool prepared;
  final LocalDbReposRepository? editableRepositories;

  LocalDbReposState copyWith({
    bool? prepared,
    LocalDbReposRepository? editableRepositories,
  }) {
    return LocalDbReposState(
      prepared: prepared ?? this.prepared,
      editableRepositories: editableRepositories ?? this.editableRepositories,
    );
  }

  @override
  List<Object> get props => [
        prepared,
        editableRepositories?.maleJumpersRepo.items ?? [],
        editableRepositories?.femaleJumpersRepo ?? [],
      ];
}
