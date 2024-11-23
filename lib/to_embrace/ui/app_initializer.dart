import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';
import 'package:sj_manager/features/game_variants/presentation/bloc/game_variant_cubit.dart';
import 'package:sj_manager/features/simulations/presentation/bloc/available_simulations_cubit.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/config/routing/routes.dart';
import 'package:path/path.dart' as path;

class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
    required this.child,
    required this.shouldSetUpRouting,
    required this.shouldSetUpUserData,
    required this.shouldLoadSimulations,
    required this.shouldLoadGameVariants,
  });

  final Widget child;
  final bool shouldSetUpRouting;
  final bool shouldSetUpUserData;
  final bool shouldLoadSimulations;
  final bool shouldLoadGameVariants;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    scheduleMicrotask(() async {
      if (widget.shouldSetUpRouting) {
        _setUpRouting();
      }
      if (widget.shouldSetUpUserData) {
        _setUpUserData();
        // TODO
      }
      if (widget.shouldLoadSimulations) {
        _loadSimulations();
      }
      if (widget.shouldLoadGameVariants) {
        _loadGameVariants();
      }
      _precacheImages();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _setUpRouting() {
    if (!routerIsInitialized) {
      configureRoutes(router);
      routerIsInitialized = true;
    }
  }

  Future<void> _setUpUserData() async {
    final userDataDir = userDataDirectory(context.read(), '');
    await userDataDir.create(recursive: true);

    if (!mounted) return;
    final simulationsFile =
        userDataFile(context.read(), path.join('simulations', 'simulations.json'));
    if (!await simulationsFile.exists()) {
      await simulationsFile.create(recursive: true);
      simulationsFile.writeAsString('[]');
    }
  }

  Future<void> _loadSimulations() async {
    await context.read<AvailableSimulationsCubit>().initialize();
  }

  Future<void> _loadGameVariants() async {
    await context.read<GameVariantCubit>().initialize();
  }

  void _precacheImages() {
    precacheImage(
      const AssetImage('assets/img/placeholders/male_placeholder.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/img/placeholders/female_placeholder.png'),
      context,
    );
  }
}
