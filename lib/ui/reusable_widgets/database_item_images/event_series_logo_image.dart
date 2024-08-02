import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_image_asset.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';

class EventSeriesLogoImage extends StatelessWidget {
  const EventSeriesLogoImage({
    super.key,
    required this.logoImage,
    required this.setup,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  final EventSeriesLogoImageWrapper logoImage;
  final DbItemImageGeneratingSetup<EventSeriesLogoImageWrapper> setup;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final filePath = dbItemImagePath(setup, logoImage);
    return Image.file(
      File(filePath ?? ''),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
