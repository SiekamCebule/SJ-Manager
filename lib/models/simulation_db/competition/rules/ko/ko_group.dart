class KoGroup<T> {
  const KoGroup({required this.entities});

  final List<T> entities;

  int get size => entities.length;
}
