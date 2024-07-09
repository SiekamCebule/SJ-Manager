import 'package:flutter/material.dart';

class DatabaseItemsList extends StatelessWidget {
  const DatabaseItemsList({
    super.key,
    this.onReorder,
    required this.length,
    required this.itemBuilder,
    required this.reorderable,
  });

  final bool reorderable;
  final Function(int oldIndex, int newIndex)? onReorder;
  final int length;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return reorderable
        ? ReorderableListView.builder(
            onReorder: onReorder!,
            itemCount: length,
            itemBuilder: itemBuilder,
          )
        : ListView.builder(
            itemBuilder: itemBuilder,
            itemCount: length,
          );
  }
}
