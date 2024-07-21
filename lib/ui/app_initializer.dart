import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/setup/set_up_app.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key, required this.child});

  final Widget child;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  _AppInitializerState() {
    scheduleMicrotask(() async {
      await context.read<AppConfigurator>().setUp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
