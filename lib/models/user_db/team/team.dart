import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';

abstract class Team with EquatableMixin {
  const Team({
    required this.facts,
  });

  final TeamFacts facts;

  @override
  List<Object?> get props => [facts];
}
