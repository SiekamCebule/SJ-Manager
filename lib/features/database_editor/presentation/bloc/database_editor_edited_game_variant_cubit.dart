import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/database_editor/domain/use_cases/game_variant/construct_edited_game_variant_use_case.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

class DatabaseEditorEditedGameVariantCubit
    extends Cubit<DatabaseEditorEditedGameVariantState> {
  DatabaseEditorEditedGameVariantCubit({
    required this.constructEditedVariant,
  }) : super(const DatabaseEditorEditedGameVariantNotAvailable());

  final ConstructEditedGameVariantUseCase constructEditedVariant;

  Future<void> construct() async {
    final gameVariant = await constructEditedVariant();
    emit(DatabaseEditorEditedGameVariantAvailable(editedVariant: gameVariant));
  }
}

abstract class DatabaseEditorEditedGameVariantState extends Equatable {
  const DatabaseEditorEditedGameVariantState();
}

class DatabaseEditorEditedGameVariantNotAvailable
    extends DatabaseEditorEditedGameVariantState {
  const DatabaseEditorEditedGameVariantNotAvailable();

  @override
  List<Object?> get props => [];
}

class DatabaseEditorEditedGameVariantAvailable
    extends DatabaseEditorEditedGameVariantState {
  const DatabaseEditorEditedGameVariantAvailable({
    required this.editedVariant,
  });

  final GameVariant editedVariant;

  @override
  List<Object?> get props => [
        editedVariant,
      ];
}
