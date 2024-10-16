import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/item_image_not_found_placeholder.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/item_image_help_dialog.dart';

class SimulationJumperImage extends StatelessWidget {
  const SimulationJumperImage({
    super.key,
    required this.jumper,
    this.customImage,
    this.aspectRatio,
  });

  final Jumper jumper;
  final ImageProvider? customImage;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    Widget errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
      return ItemImageNotFoundPlaceholder(
        width: UiItemEditorsConstants.jumperImagePlaceholderWidth,
        height: UiItemEditorsConstants.jumperImageHeight,
        helpDialog: ItemImageHelpDialog(
          content: translate(context).jumperImageHelpContent,
        ),
      );
    }

    final image = customImage == null
        ? DbItemImage<Jumper>(
            item: jumper,
            setup: context.read(),
            errorBuilder: errorBuilder,
          )
        : Image(
            image: customImage!,
            errorBuilder: errorBuilder,
          );
    return aspectRatio != null
        ? AspectRatio(
            aspectRatio: aspectRatio!,
            child: image,
          )
        : image;
  }
}
