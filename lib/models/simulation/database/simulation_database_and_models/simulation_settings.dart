class SimulationSettingsRepo {
  const SimulationSettingsRepo({
    required this.archiveEndedSeasonsResults,
    required this.unhideJumperSkills,
    required this.unhideJumperDynamicParameters,
  });

  final bool archiveEndedSeasonsResults;
  final bool unhideJumperSkills;
  final bool unhideJumperDynamicParameters;

  SimulationSettingsRepo copyWith({
    bool? archiveEndedSeasonsResults,
    bool? unhideJumperSkills,
    bool? unhideJumperDynamicParameters,
  }) {
    return SimulationSettingsRepo(
      archiveEndedSeasonsResults:
          archiveEndedSeasonsResults ?? this.archiveEndedSeasonsResults,
      unhideJumperSkills: unhideJumperSkills ?? this.unhideJumperSkills,
      unhideJumperDynamicParameters:
          unhideJumperDynamicParameters ?? this.unhideJumperDynamicParameters,
    );
  }
}
