class KoGroup<E> {
  const KoGroup({required this.entities});

  final List<E> entities;

  int get size => entities.length;
}
