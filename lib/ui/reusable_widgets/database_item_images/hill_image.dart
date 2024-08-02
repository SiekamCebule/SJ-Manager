import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';

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
  final DbItemImageGeneratingSetup<Hill> setup;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final filePath = dbItemImagePath(setup, hill);
    return Image.file(
      File(filePath ?? ''),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
