import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

class AppTheme extends Equatable {
  const AppTheme({
    required this.brightness,
    required this.colorScheme,
  });

  final Brightness brightness;
  final AppColorScheme colorScheme;

  @override
  List<Object?> get props => [
        brightness,
        colorScheme,
      ];
}
