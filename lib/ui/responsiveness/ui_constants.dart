import 'package:flutter/material.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

abstract class UiConstants {
  static const defaultAppColorScheme = AppColorScheme.blue;
  static const defaultAppThemeBrightness = Brightness.dark;

  static const double spaceBetweenButtonsInMainMenu = 5;
  static const mainMenuButtonBorderRadius = Radius.circular(0);
  static const double mainMenuSmallerButtonIconSize = 40;
  static const double horizontalSpaceBetweenMainMenuButtonItems = 20;
  static const double verticalSpaceBetweenMainMenuButtonItems = 10;
  static const double mainMenuContinueButtonSimulationInfoVerticalGap = 15;
  static const double mainMenuContinueButtonSimulationInfoIconSize = 45;

  static const appTitleShakeInterval = Duration(seconds: 15);
  static const appTitleShakeDuration = Duration(milliseconds: 1500);

  static const double verticalSpaceBetweenDatabaseItemEditorFields = 15;

  static const double backgroundImageTransparency = 0.1;
}
