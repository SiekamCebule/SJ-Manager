import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sj_manager/setup/set_up_app.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';

class App extends StatefulWidget {
  const App({super.key, required this.home});

  final Widget home;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  _AppState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AppConfigurator>().setUp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: BlocProvider.of<ThemeCubit>(context).state,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: widget.home,
    );
  }
}
