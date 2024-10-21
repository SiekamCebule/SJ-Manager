import 'package:equatable/equatable.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class TeamReports with EquatableMixin {
  const TeamReports({
    required this.generalMoraleRating,
    required this.generalJumpsRating,
    required this.generalTrainingRating,
  });

  final SimpleRating? generalMoraleRating;
  final SimpleRating? generalJumpsRating;
  final SimpleRating? generalTrainingRating;

  static TeamReports fromJson(Json json) {
    return TeamReports(
      generalMoraleRating: json['generalMoraleRating'] != null
          ? SimpleRating.fromJson(json['generalMoraleRating'])
          : null,
      generalJumpsRating: json['generalJumpsRating'] != null
          ? SimpleRating.fromJson(json['generalJumpsRating'])
          : null,
      generalTrainingRating: json['generalTrainingRating'] != null
          ? SimpleRating.fromJson(json['generalTrainingRating'])
          : null,
    );
  }

  Json toJson() {
    return {
      'generalMoraleRating': generalMoraleRating?.name,
      'generalJumpsRating': generalJumpsRating?.name,
      'generalTrainingRating': generalTrainingRating?.name,
    };
  }

  @override
  List<Object?> get props => [
        generalMoraleRating,
        generalJumpsRating,
        generalTrainingRating,
      ];
}
