import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_group.dart';

class KoRoundRules<T> with EquatableMixin {
  const KoRoundRules({
    required this.advancementDeterminator,
    required this.koGroupsCreator,
  });

  final List<T> Function(List<T> entities) advancementDeterminator;
  final List<KoGroup<T>> Function(List<T> entities) koGroupsCreator;

  @override
  List<Object?> get props => [];
}
