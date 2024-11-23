import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sj_manager/features/app_settings/presentation/bloc/app_settings_cubit.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_theme.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_theme_data_creator.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.home,
  });

  final Widget home;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state as AppSettingsInitialized;
    final theme = AppThemeDataCreator().create(
      AppTheme(brightness: Brightness.dark, colorScheme: settings.colorScheme),
    );
    return MaterialApp(
      navigatorKey: mainNavigatorKey,
      theme: theme,
      locale: Locale(settings.languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}
