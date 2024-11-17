import 'package:equatable/equatable.dart';

class TeamCompetitionGroupRules with EquatableMixin {
  const TeamCompetitionGroupRules({
    required this.sortStartList,
  });

  final bool sortStartList;

  @override
  List<Object?> get props => [
        sortStartList,
      ];
}
