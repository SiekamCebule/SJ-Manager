abstract interface class SimulationCurrentDateRepository {
  Future<void> set(DateTime date);
  Future<DateTime> get();
}
