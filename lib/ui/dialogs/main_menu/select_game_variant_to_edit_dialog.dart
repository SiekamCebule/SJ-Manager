import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';

class SelectGameVariantToEditDialog extends StatefulWidget {
  const SelectGameVariantToEditDialog({
    super.key,
    required this.gameVariants,
  });

  final List<GameVariant> gameVariants;

  @override
  State<SelectGameVariantToEditDialog> createState() =>
      _SelectGameVariantToEditDialogState();
}

class _SelectGameVariantToEditDialogState extends State<SelectGameVariantToEditDialog> {
  GameVariant? _selectedGameVariant;

  @override
  Widget build(BuildContext context) {
    const double bodyWidth = 200;
    const double bodyHeight = 200;

    const emptyBody = SizedBox(
      width: bodyWidth,
      height: bodyHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Symbols.search_off),
          Gap(8),
          Text('Brak wariantów gry'),
          Gap(3),
          Text('Dziwne...'),
        ],
      ),
    );
    final nonEmptyBody = SizedBox(
      width: bodyWidth,
      height: bodyHeight,
      child: ListView.builder(
        itemCount: widget.gameVariants.length,
        itemBuilder: (context, index) {
          final gameVariant = widget.gameVariants[index];
          return ListTile(
            key: ValueKey(index),
            leading: const Icon(Symbols.circle),
            title: Text(gameVariant.name.translate(context)),
            subtitle: Text('ID: ${gameVariant.id}'),
            selected: _selectedGameVariant == gameVariant,
            onTap: () {
              setState(() {
                if (_selectedGameVariant == null) {
                  _selectedGameVariant = gameVariant;
                } else {
                  _selectedGameVariant = null;
                }
              });
            },
          );
        },
      ),
    );

    return AlertDialog(
      title: const Text('Który wariant gry chcesz edytować?'),
      content: widget.gameVariants.isNotEmpty ? nonEmptyBody : emptyBody,
      actions: [
        TextButton(
          child: const Text('Anuluj'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          onPressed: _selectedGameVariant != null
              ? () {
                  Navigator.of(context).pop(_selectedGameVariant!);
                }
              : null,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
