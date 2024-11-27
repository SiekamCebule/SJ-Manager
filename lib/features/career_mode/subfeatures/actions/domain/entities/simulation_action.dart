import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';

class SimulationAction with EquatableMixin {
  SimulationAction({
    required this.type,
    required this.deadline,
    required this.isCompleted,
  });

  final SimulationActionType type;
  DateTime? deadline;
  bool isCompleted;

  SimulationAction copyWith({
    SimulationActionType? type,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return SimulationAction(
      type: type ?? this.type,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        type,
        deadline,
      ];
}
