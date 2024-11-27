import 'package:equatable/equatable.dart';

class JumperTrainingResult with EquatableMixin {
  const JumperTrainingResult({
    required this.takeoffDelta,
    required this.flightDelta,
    required this.landingDelta,
    required this.formDelta,
    required this.consistencyDelta,
    required this.fatigueDelta,
  });

  final double takeoffDelta;
  final double flightDelta;
  final double landingDelta;
  final double formDelta;
  final double consistencyDelta;
  final double fatigueDelta;

  @override
  List<Object?> get props => [
        takeoffDelta,
        flightDelta,
        landingDelta,
        formDelta,
        consistencyDelta,
        fatigueDelta,
      ];
}
