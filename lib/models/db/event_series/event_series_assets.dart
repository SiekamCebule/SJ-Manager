import 'package:equatable/equatable.dart';

class EventSeriesAssets with EquatableMixin {
  const EventSeriesAssets({
    this.logoPath,
    this.trophyPath,
    this.introPath,
  });

  final String? logoPath;
  final String? trophyPath;
  final String? introPath;

  EventSeriesAssets copyWith({
    String? logoPath,
    String? trophyPath,
    String? introPath,
  }) {
    return EventSeriesAssets(
      logoPath: logoPath ?? this.logoPath,
      trophyPath: trophyPath ?? this.trophyPath,
      introPath: introPath ?? this.introPath,
    );
  }

  @override
  List<Object?> get props => [
        logoPath,
        trophyPath,
        introPath,
      ];
}
