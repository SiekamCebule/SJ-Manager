abstract class EntityRelatedAlgorithmContext<E> {
  const EntityRelatedAlgorithmContext({
    required this.entity,
  });

  final E entity;

  // TODO: final SimulationDatabase database, etc.
  // TODO: final SimulationDatabaseUtils utils, etc.
}
