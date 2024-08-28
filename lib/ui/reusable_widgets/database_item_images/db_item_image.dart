import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/ui/dialogs/svg_is_not_supported_dialog.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/utils/string.dart';

class DbItemImage<T> extends StatefulWidget {
  const DbItemImage({
    super.key,
    required this.item,
    required this.setup,
    this.width,
    this.height,
    this.fit,
    required this.errorBuilder,
  });

  final T item;
  final DbItemImageGeneratingSetup<T>? setup;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?) errorBuilder;

  @override
  State<DbItemImage<T>> createState() => _DbItemImageState<T>();
}

class _DbItemImageState<T> extends State<DbItemImage<T>> {
  bool _svgDialogIsOpened = false;

  @override
  Widget build(BuildContext context) {
    if (widget.setup == null) {
      return widget.errorBuilder(context, Object(), null);
    }
    final filePath = dbItemImagePath(widget.setup!, widget.item);
    return Image.file(
      File(filePath ?? ''),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        if (filePath?.lastNChars(4) == '.svg') {
          if (!_svgDialogIsOpened) {
            scheduleMicrotask(() async {
              _svgDialogIsOpened = true;
              await showDialog(
                context: context,
                builder: (context) {
                  return const SvgIsNotSupportedDialog();
                },
              );
            });
          }
        }
        return widget.errorBuilder(context, error, stackTrace);
      },
    );
  }
}
