import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sj_manager/ui/providers/locale_cubit.dart';
import 'package:sj_manager/ui/theme/app_theme_data_creator.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.home,
  });

  final Widget home;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeDataCreator().create(context.watch<ThemeCubit>().state);
    return MaterialApp(
      theme: theme,
      locale: context.watch<LocaleCubit>().state,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}
