import 'package:equatable/equatable.dart';

abstract class ItemMatchAlgorithm extends Equatable {
  const ItemMatchAlgorithm();

  bool matches();
}
