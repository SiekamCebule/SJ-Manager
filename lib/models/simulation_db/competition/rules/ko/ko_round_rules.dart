import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_group.dart';

class KoRoundRules<T> with EquatableMixin {
  const KoRoundRules({
    required this.determineAdvancement,
    required this.createKoGroups,
  });

  final List<T> Function(List<T> entities) determineAdvancement;
  final List<KoGroup<T>> Function(List<T> entities) createKoGroups;

  @override
  List<Object?> get props => [];
}
