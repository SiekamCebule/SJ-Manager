import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/hill_image/hill_image_generating_setup.dart';

class HillImage extends StatelessWidget {
  const HillImage({
    super.key,
    required this.hill,
    required this.setup,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  final Hill hill;
  final HillImageGeneratingSetup setup;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final filePath = hillImagePath(setup, hill);
    return Image.file(
      File(filePath ?? ''),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
