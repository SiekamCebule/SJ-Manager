part of '../database_editor_screen.dart';

extension type _SelectedTabIndex(int index) {}

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> with SingleTickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;

  late final DbFiltersRepo _filters;
  late final SelectedIndexesRepo _selectedIndexes;
  late final EventSeriesSetupIdsRepo _eventSeriesSetupIds;

  late final LocalDatabaseCopyCubit _localDbCopy;
  late final ChangeStatusCubit _dbChangeStatus;
  late final DatabaseItemsCubit _items;
  late final DatabaseEditorCountriesCubit _countries;

  final _initialized = ValueNotifier<bool>(false);
  var _closed = false;
  var _currentTabIndex = _SelectedTabIndex(0);

  @override
  void initState() {
    _bodyAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value: 1.0,
    );

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
    _localDbCopy = LocalDatabaseCopyCubit(originalDb: context.read());
    await _localDbCopy.setUp();
    _items = DatabaseItemsCubit(
      filtersRepo: _filters,
      itemsRepos: _localDbCopy.state!,
    );
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
    _cleanResources();
    _bodyAnimationController.dispose();
    FlutterWindowClose.setWindowShouldCloseHandler(null);
    super.dispose();
  }

  void _cleanResources() {
    print('clean resources');
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
                  RepositoryProvider(
                    create: (context) => ValueRepo(initial: _currentTabIndex),
                  ),
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
                      child: StreamBuilder<Object>(
                          stream: StreamGroup.merge([
                            _selectedIndexes.selectedIndexes,
                          ]),
                          builder: (context, snapshot) {
                            final selectedIndexes = _selectedIndexes.state;
                            final shouldShowFabs = !_filters.hasValidFilter;
                            final shouldShowAddFab = selectedIndexes.length <= 1;
                            final shouldShowRemoveFab = selectedIndexes.isNotEmpty;
                            final itemsType = _items.state.itemsType;
                            final shouldShowBottomAppBar = itemsType == MaleJumper ||
                                itemsType == FemaleJumper ||
                                itemsType == Hill;

                            const fabsGap =
                                Gap(UiDatabaseEditorConstants.verticalSpaceBetweenFabs);

                            return Scaffold(
                              appBar: const _AppBar(),
                              bottomNavigationBar:
                                  shouldShowBottomAppBar ? const _BottomAppBar() : null,
                              body: Row(
                                children: [
                                  fabsGap,
                                  AnimatedVisibility(
                                    duration: Durations.short3,
                                    curve: Curves.easeIn,
                                    visible: shouldShowFabs,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        fabsGap,
                                        AnimatedVisibility(
                                          duration: Durations.short3,
                                          curve: Curves.easeIn,
                                          visible: shouldShowAddFab,
                                          child: const _AddFab(),
                                        ),
                                        fabsGap,
                                        AnimatedVisibility(
                                          duration: Durations.short3,
                                          curve: Curves.easeIn,
                                          visible: shouldShowRemoveFab,
                                          child: const _RemoveFab(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(UiDatabaseEditorConstants.gapBetweenFabs),
                                  DefaultTabController(
                                    length: 6,
                                    child: Expanded(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            TabBar(
                                              tabs: [
                                                Tab(
                                                  text:
                                                      translate(context).maleCompetitiors,
                                                  icon: const Icon(Symbols.male),
                                                ),
                                                Tab(
                                                  text: translate(context)
                                                      .femaleCompetitors,
                                                  icon: const Icon(Symbols.female),
                                                ),
                                                Tab(
                                                  text: translate(context).hills,
                                                  icon: const ImageIcon(hillIcon),
                                                ),
                                                Tab(
                                                  text: 'Cykle zawodów',
                                                  icon: const Icon(Symbols.trophy),
                                                ),
                                                Tab(
                                                  text: 'Kalendarze',
                                                  icon:
                                                      const Icon(Symbols.calendar_month),
                                                ),
                                                Tab(
                                                  text: 'Konkursy',
                                                  icon: const Icon(Symbols.contract),
                                                ),
                                              ],
                                              onTap: _onChangeTab,
                                            ),
                                            Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  final opacity = CurvedAnimation(
                                                    parent: _bodyAnimationController,
                                                    curve: Curves.easeIn,
                                                  );
                                                  return FadeTransition(
                                                    opacity: opacity,
                                                    child: const _Body(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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

  Future<void> _onChangeTab(int index) async {
    if (_currentTabIndex.index != index) {
      _selectedIndexes.clearSelection();
      _filters.clear();
      _items.selectByIndex(index);
      _currentTabIndex = _SelectedTabIndex(index);
      await _animateBodyFromZero();
    }
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
