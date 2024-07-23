import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/jumper_image/jumper_image_generating_setup.dart';

class JumperImage extends StatelessWidget {
  const JumperImage({
    super.key,
    required this.jumper,
    required this.setup,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  final Jumper jumper;
  final JumperImageGeneratingSetup setup;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final filePath = jumperImagePath(setup, jumper);
    return Image.file(
      File(filePath ?? ''),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
