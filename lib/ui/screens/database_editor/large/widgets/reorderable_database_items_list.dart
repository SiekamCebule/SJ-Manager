import 'package:flutter/material.dart';

class ReorderableDatabaseItemsList extends StatelessWidget {
  const ReorderableDatabaseItemsList({
    super.key,
    required this.onReorder,
    required this.length,
    required this.itemBuilder,
  });

  final Function(int oldIndex, int newIndex) onReorder;
  final int length;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      cacheExtent: 1200,
      onReorder: onReorder,
      itemCount: length,
      itemBuilder: itemBuilder,
    );
  }
}
