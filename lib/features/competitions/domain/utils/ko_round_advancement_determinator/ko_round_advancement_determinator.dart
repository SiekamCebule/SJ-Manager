import 'package:equatable/equatable.dart';

abstract class KoRoundAdvancementDeterminator<T> with EquatableMixin {
  const KoRoundAdvancementDeterminator();

  List<T> determineAdvancement(dynamic context);

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
