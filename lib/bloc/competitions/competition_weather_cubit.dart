import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osje_sim/osje_sim.dart';

class CompetitionWeatherCubit extends Cubit<CompetitionWeatherState> {
  CompetitionWeatherCubit() : super(const CompetitionWeatherInitial());

  // TODO: final WindGenerator windGenerator

  void updateWeather(Duration duration) {
    /* TODO: emit(
      CompetitionWeatherHasData(windMeasurement: windMeasurement),
    );*/
  }
}

abstract class CompetitionWeatherState with EquatableMixin {
  const CompetitionWeatherState();

  @override
  List<Object?> get props => [];
}

class CompetitionWeatherHasData extends CompetitionWeatherState {
  const CompetitionWeatherHasData({
    required this.windMeasurement,
  });

  final WindMeasurement windMeasurement;
  // TODO: others, like snow, rain...

  @override
  List<Object?> get props => [
        windMeasurement,
      ];
}

class CompetitionWeatherInitial extends CompetitionWeatherState {
  const CompetitionWeatherInitial();
}
