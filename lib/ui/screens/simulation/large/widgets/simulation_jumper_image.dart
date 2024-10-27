import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image.dart';

class SimulationJumperImage extends StatelessWidget {
  const SimulationJumperImage({
    super.key,
    required this.jumper,
    this.customImage,
    this.width,
    this.height,
  }) : assert((width != null || height != null) && !(width != null && height != null));

  final Jumper jumper;
  final ImageProvider? customImage;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final imageFit = width != null ? BoxFit.fitWidth : BoxFit.fitHeight;

    late final Widget child;
    if (customImage != null) {
      child = Image(
        image: customImage!,
        width: width,
        height: height,
        fit: imageFit,
      );
    } else {
      child = DbItemImage<Jumper>(
        item: jumper,
        setup: context.read(),
        width: width,
        height: height,
        fit: imageFit,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: width,
          height: height,
          child: Placeholder(
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
      );
    }

    return child;
  }
}
