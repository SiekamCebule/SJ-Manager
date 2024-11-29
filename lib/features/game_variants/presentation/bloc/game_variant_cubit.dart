import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/domain/usecases/choose_game_variant_use_case.dart';
import 'package:sj_manager/features/game_variants/domain/usecases/construct_game_variants_use_case.dart';
import 'package:sj_manager/features/game_variants/domain/usecases/get_all_game_variants_use_case.dart';
import 'package:sj_manager/features/game_variants/domain/usecases/save_game_variant_use_case.dart';

class GameVariantCubit extends Cubit<GameVariantState> {
  GameVariantCubit({
    required this.constructGameVariants,
    required this.getAllGameVariants,
    required this.chooseGameVariantUseCase,
    required this.saveGameVariant,
  }) : super(GameVariantInitial());

  final ConstructGameVariantsUseCase constructGameVariants;
  final GetAllGameVariantsUseCase getAllGameVariants;
  final ChooseGameVariantUseCase chooseGameVariantUseCase;
  final SaveGameVariantUseCase saveGameVariant;

  var _variants = <GameVariant>[];

  Future<void> initialize() async {
    emit(GameVariantInitializing());
    await constructGameVariants();
    _variants = await getAllGameVariants();
    emit(GameVariantAbleToChoose(variants: _variants));
  }

  Future<void> chooseGameVariant(GameVariant variant) async {
    final chosen = await chooseGameVariantUseCase(variant);
    if (chosen) {
      emit(GameVariantChosen(variant: variant));
    } else {
      emit(const GameVariantError());
    }
  }

  Future<void> endEditingVariant(GameVariant editedVariant) async {
    if (state is GameVariantChosen) {
      final currentVariant = (state as GameVariantChosen).variant;
      emit(GameVariantEndingEditing());
      await saveGameVariant(currentVariant);
      emit(GameVariantAbleToChoose(variants: _variants));
    } else {
      throw StateError('Ended editing the variant when no variant had been chosen');
    }
  }
}

abstract class GameVariantState extends Equatable {
  const GameVariantState();

  @override
  List<Object?> get props => [];
}

class GameVariantInitial extends GameVariantState {}

class GameVariantInitializing extends GameVariantState {}

class GameVariantEndingEditing extends GameVariantState {}

class GameVariantAbleToChoose extends GameVariantState {
  const GameVariantAbleToChoose({
    required this.variants,
  });

  final List<GameVariant> variants;

  @override
  List<Object?> get props => [variants];
}

class GameVariantChosing extends GameVariantState {
  const GameVariantChosing({
    required this.variant,
  });

  final GameVariant variant;

  @override
  List<Object?> get props => [variant];
}

class GameVariantChosen extends GameVariantState {
  const GameVariantChosen({
    required this.variant,
  });

  final GameVariant variant;

  @override
  List<Object?> get props => [variant];
}

class GameVariantError extends GameVariantState {
  const GameVariantError();

  @override
  List<Object?> get props => [];
}
