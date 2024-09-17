import 'package:flutter/material.dart';
import 'package:sj_manager/models/game_variants/default_game_variants/variants_registry.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/dialogs/loading_items/loading_items_failed_dialog.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class GameVariantsLoader implements DbItemsListLoader {
  const GameVariantsLoader({
    required this.context,
  });

  final BuildContext context;

  @override
  Future<void> load() async {
    try {
      final variants = await constructDefaultGameVariants(context: context);
      if (!context.mounted) return;
      context.read<ItemsRepo<GameVariant>>().set(variants);
    } catch (error, stackTrace) {
      showSjmDialog(
        context: context,
        child: LoadingItemsFailedDialog(
          titleText: 'Błąd podczas ładowania wariantów gry',
          filePath: null,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
