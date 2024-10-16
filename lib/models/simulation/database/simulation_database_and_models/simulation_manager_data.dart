// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';

class SimulationManagerData with EquatableMixin {
  const SimulationManagerData({
    required this.mode,
    required this.userSubteam,
    required this.personalCoachJumpers,
    required this.trainingPoints,
  });

  final SimulationMode mode;

  // For classic coach
  final Subteam? userSubteam;

  // For personal coach
  final List<Jumper>? personalCoachJumpers;

  // For training purposes
  final int trainingPoints;

  @override
  List<Object?> get props => [
        mode,
        userSubteam,
        personalCoachJumpers,
        trainingPoints,
      ];

  SimulationManagerData copyWith({
    SimulationMode? mode,
    Subteam? userSubteam,
    List<Jumper>? personalCoachJumpers,
    int? trainingPoints,
  }) {
    return SimulationManagerData(
      mode: mode ?? this.mode,
      userSubteam: userSubteam ?? this.userSubteam,
      personalCoachJumpers: personalCoachJumpers ?? this.personalCoachJumpers,
      trainingPoints: trainingPoints ?? this.trainingPoints,
    );
  }
}
