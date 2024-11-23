import 'package:equatable/equatable.dart';

class JumperTrainingResult with EquatableMixin {
  const JumperTrainingResult({
    required this.takeoffQuality,
    required this.flightQuality,
    required this.landingQuality,
    required this.form,
    required this.jumpsConsistency,
    required this.fatigue,
  });

  final double takeoffQuality;
  final double flightQuality;
  final double landingQuality;
  final double form;
  final double jumpsConsistency;
  final double fatigue;

  @override
  List<Object?> get props => [
        form,
        jumpsConsistency,
        fatigue,
      ];
}
