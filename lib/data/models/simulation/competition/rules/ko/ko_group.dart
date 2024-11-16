import 'package:equatable/equatable.dart';

class KoGroup<E> with EquatableMixin {
  const KoGroup({required this.entities});

  final List<E> entities;

  int get size => entities.length;

  @override
  List<Object?> get props => [
        entities,
      ];
}
