import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sj_manager/setup/db_items_list_loader.dart';
import 'package:sj_manager/setup/app_configurator.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
    required this.child,
    required this.shouldSetUpRouting,
    required this.shouldSetUpUserData,
    required this.shouldLoadDatabase,
    required this.createLoaders,
  });

  final Widget child;
  final bool shouldSetUpRouting;
  final bool shouldSetUpUserData;
  final bool shouldLoadDatabase;
  final List<DbItemsListLoader> Function(BuildContext context) createLoaders;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    scheduleMicrotask(() async {
      AppConfigurator(
        shouldSetUpRouting: widget.shouldSetUpRouting,
        shouldSetUpUserData: widget.shouldSetUpUserData,
        shouldLoadDatabase: widget.shouldLoadDatabase,
        loaders: widget.createLoaders(context),
      ).setUp(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
