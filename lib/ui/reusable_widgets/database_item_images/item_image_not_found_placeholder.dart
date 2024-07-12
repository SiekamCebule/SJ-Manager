import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/item_image_help_dialog.dart';

class ItemImageNotFoundPlaceholder extends StatelessWidget {
  const ItemImageNotFoundPlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Placeholder(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
                child: Text(
              'Nie znaleziono zdjęcia',
              textAlign: TextAlign.center,
            )),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton.filledTonal(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => const ItemImageHelpDialog(),
                );
              },
              icon: const Icon(Symbols.help),
            ),
          ),
        ],
      ),
    );
  }
}
