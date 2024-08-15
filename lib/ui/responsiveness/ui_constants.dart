import 'package:flutter/material.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

abstract class UiGlobalConstants {
  static const defaultAppColorScheme = AppColorScheme.blue;
  static const defaultAppThemeBrightness = Brightness.dark;

  static const double backgroundImageTransparency = 0.3;

  static const double smallCountryFlagWidth = 30;
  static const double defaultCountryFlagBorderRadius = 3;
}

abstract class UiMainMenuConstants {
  static const double spaceBetweenButtons = 5;
  static const buttonsBorderRadius = Radius.circular(10);
  static const double smallerButtonIconSize = 40;
  static const double horizontalSpaceBetweenButtonItems = 20;
  static const double verticalSpaceBetweenButtonItems = 10;
  static const double continueButtonSimulationInfoVerticalGap = 15;
  static const double continueButtonSimulationInfoIconSize = 45;

  static const double buttonsTableHeight = 450;
  static const double buttonsTableWidth = 900;

  static const appTitleShakeInterval = Duration(seconds: 15);
  static const appTitleShakeDuration = Duration(milliseconds: 1500);
}

abstract class UiSettingsConstants {
  static const double settingListTileWidth = 250;
  static const double gapBetweenSettingTiles = 10;
}

abstract class UiDatabaseEditorConstants {
  static const double verticalSpaceBetweenFabs = 10;
  static const double horizontalSpaceBetweenListAndEditor = 45;

  static const double gapBetweenFabs = 10;
  static const double gapBetweenAppBarActions = 30;

  static const double gapBetweenFilters = 30;
}

abstract class UiItemEditorsConstants {
  static const double verticalSpaceBetweenFields = 15;
  static const double itemImageHorizontalMargin = 25;
  static const double sexIconSizeInJumperEditor = 40;

  static const double jumperImageHeight = 170;
  static const double jumperImagePlaceholderWidth = 90;

  static const double hillImageHeight = 175;
  static const double hillImagePlaceholderWidth = 175;
}
