import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';

class SimpleScore<T> extends Score<T> {
  const SimpleScore({
    required super.subject,
    required this.points,
  });

  @override
  final double points;

  @override
  List<Object?> get props => [subject, points];

  SimpleScore<T> copyWith({
    T? subject,
    double? points,
  }) {
    return SimpleScore<T>(
      subject: subject ?? this.subject,
      points: points ?? this.points,
    );
  }
}

class ZeroScore<T> extends SimpleScore<T> {
  ZeroScore({
    required super.subject,
  }) : super(points: 0);
}
