import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';

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
  final DbItemImageGeneratingSetup<Jumper> setup;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final filePath = dbItemImagePath(setup, jumper);
    return Image.file(
      File(filePath ?? ''),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
