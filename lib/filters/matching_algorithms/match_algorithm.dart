import 'package:equatable/equatable.dart';

abstract class ItemMatchAlgorithm<T> extends Equatable {
  const ItemMatchAlgorithm();

  bool matches(T item);
}
