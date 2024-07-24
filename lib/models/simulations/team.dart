import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/sex.dart';

abstract class Team {
  const Team();
}

class CountryTeam extends Team with EquatableMixin {
  const CountryTeam({
    required this.sex,
    required this.country,
  });

  final Sex sex;
  final Country country;

  CountryTeam copyWith({
    Sex? sex,
    Country? country,
  }) {
    return CountryTeam(
      sex: sex ?? this.sex,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [sex, country];
}
