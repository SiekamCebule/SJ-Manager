import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_api.dart';
import 'package:sj_manager/repositories/database_editing/db_io_parameters_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/ui/navigation/routes.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';

final router = FluroRouter();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  _AppState() {
    configureRoutes(router);
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      await context.read<CountriesApi>().loadFromSource();
      await _loadDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: BlocProvider.of<ThemeCubit>(context).state,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
    );
  }

  Future<void> _loadDatabase() async {
    await _loadItems<MaleJumper>();
    await _loadItems<FemaleJumper>();
    await _loadItems<Hill>();
  }

  Future<void> _loadItems<T>() async {
    if (!mounted) return;
    final parameters = context.read<DbIoParametersRepo<T>>();
    final loadedMales = await loadItemsListFromJsonFile(
        file: parameters.storageFile, fromJson: parameters.fromJson);
    if (!mounted) return;
    context.read<DbItemsRepository<T>>().setItems(loadedMales);
  }
}
