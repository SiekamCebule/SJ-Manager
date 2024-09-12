part of '../database_editor_screen.dart';

extension type _SelectedTabIndex(int index) {}

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> with SingleTickerProviderStateMixin {
  late final DbFiltersRepo _filters;
  late final SelectedIndexesRepo _selectedIndexes;
  late final EventSeriesSetupIdsRepo _eventSeriesSetupIds;

  late final StreamSubscription _localDbCopyChangesSubscription;
  late final LocalDatabaseCopyCubit _localDbCopy;
  late final ChangeStatusCubit _dbChangeStatus;
  late final DatabaseItemsCubit _items;
  late final DatabaseEditorCountriesCubit _countries;

  final _initialized = ValueNotifier<bool>(false);
  var _closed = false;

  @override
  void initState() {
    scheduleMicrotask(() async {
      _initializeRepos();
      await _initializeCubits();
      _initialized.value = true;
    });

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (!_closed && _dbChangeStatus.state) {
        String? action = await _showSaveChangesDialog();
        final shouldClose = await _shouldCloseAfterDialog(action);
        if (action == 'yes') {
          if (!mounted) return true;
          await _localDbCopy.saveChangesToOriginalRepos(context);
        }
        if (!_closed && shouldClose) {
          _closed = shouldClose;
        }
        if (shouldClose) {
          _cleanResources();
        }
        return shouldClose;
      } else {
        _cleanResources();
        return true;
      }
    });
    super.initState();
  }

  void _initializeRepos() {
    _filters = DbFiltersRepo(initial: {
      MaleJumper: BehaviorSubject.seeded([]),
      FemaleJumper: BehaviorSubject.seeded([]),
      Hill: BehaviorSubject.seeded([]),
      EventSeriesSetup: BehaviorSubject.seeded([]),
      EventSeriesCalendarPreset: BehaviorSubject.seeded([]),
      DefaultCompetitionRulesPreset: BehaviorSubject.seeded([]),
    });
    _selectedIndexes = SelectedIndexesRepo();
    _eventSeriesSetupIds = EventSeriesSetupIdsRepo();
  }

  Future<void> _initializeCubits() async {
    _dbChangeStatus = ChangeStatusCubit();
    _localDbCopy = LocalDatabaseCopyCubit(
      originalDb: context.read(),
      idsRepo: context.read(),
    );
    await _localDbCopy.setUp();
    if (!mounted) return;
    _items = DatabaseItemsCubit(
      filtersRepo: _filters,
      itemsRepos: _localDbCopy.state!,
      selectedIndexesRepo: _selectedIndexes,
      idsRepo: context.read(),
      idGenerator: context.read(),
    );
    _localDbCopyChangesSubscription = _localDbCopy.stream.listen((state) {
      _items.updateItemsRepo(state!);
    });
    final teamsRepo =
        TeamsRepo<CountryTeam>(initial: _localDbCopy.originalDb.get<Team>().last.cast());
    _countries = DatabaseEditorCountriesCubit(
      countriesRepo: _localDbCopy.originalDb.get<Country>() as CountriesRepo,
      teamsRepo: teamsRepo,
    );
    _countries.setUp();
  }

  @override
  void dispose() {
    if (!_closed) {
      _cleanResources();
    }
    FlutterWindowClose.setWindowShouldCloseHandler(null);
    super.dispose();
  }

  void _cleanResources() {
    debugPrint('_Large(): _cleanResources()');
    _localDbCopyChangesSubscription.cancel();
    _localDbCopy.close();
    _localDbCopy.dispose();
    _dbChangeStatus.close();
    _countries.dispose();
    _countries.close();
    _selectedIndexes.close();
    _filters.close();
  }

  Future<String?> _showSaveChangesDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => const DatabaseEditorUnsavedChangesDialog(),
    );
  }

  Future<bool> _shouldCloseAfterDialog(String? action) async {
    return switch (action) {
      'no' => true,
      'yes' => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _initialized,
      builder: (context, prepared, child) {
        const progressIndicator = Center(
          child: SizedBox.square(
            dimension: 150,
            child: CircularProgressIndicator(),
          ),
        );
        final child = prepared
            ? MultiRepositoryProvider(
                providers: [
                  RepositoryProvider.value(value: _filters),
                  RepositoryProvider.value(value: _selectedIndexes),
                  RepositoryProvider.value(value: _eventSeriesSetupIds),
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: _localDbCopy),
                    BlocProvider.value(value: _dbChangeStatus),
                    BlocProvider.value(value: _items),
                    BlocProvider.value(value: _countries),
                  ],
                  child: Builder(builder: (context) {
                    context.watch<LocalDatabaseCopyCubit>();
                    context.watch<ChangeStatusCubit>();
                    context.watch<DatabaseItemsCubit>();
                    return PopScope(
                      canPop: false,
                      onPopInvokedWithResult: (didPop, value) async {
                        if (didPop || _closed) {
                          return;
                        } else if (!_dbChangeStatus.state) {
                          _cleanResources();
                          Navigator.pop(context);
                          return;
                        }
                        String? action = await _showSaveChangesDialog();
                        bool shouldClose = await _shouldCloseAfterDialog(action);
                        if (action == 'yes') {
                          if (!context.mounted) return;
                          await _localDbCopy.saveChangesToOriginalRepos(context);
                        }
                        if (shouldClose) {
                          _cleanResources();
                          _closed = true;
                          if (!context.mounted) return;
                          router.pop(context);
                        }
                      },
                      child: const _MainBody(),
                    );
                  }),
                ),
              )
            : progressIndicator;
        return AnimatedSwitcher(
          duration: Durations.long2,
          switchInCurve: Curves.easeInExpo,
          switchOutCurve: Curves.decelerate,
          child: child,
        );
      },
    );
  }
}
