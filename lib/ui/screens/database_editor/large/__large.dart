part of '../database_editor_screen.dart';

extension type _SelectedTabIndex(int index) {}

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> with SingleTickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;

  late final DbFiltersRepo _filtersRepo;
  late final SelectedIndexesRepo _selectedIndexesRepo;

  late final CopiedLocalDbCubit _copiedDbCubit;
  late final ChangeStatusCubit _dbChangeStatusCubit;
  late final DatabaseItemsTypeCubit _itemsTypeCubit;
  late final LocalDbFilteredItemsCubit _filteredItemsCubit;

  late CountriesRepo _countriesForMales;
  late CountriesRepo _countriesForFemales;
  late CountriesRepo _countriesForBothSexes;
  late CountriesRepo _currentCountries;

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

      _countriesForMales = CountriesRepo(
          initial: countriesHavingTeam(
        countryTeamsBySex(
          teamsByStars(_copiedDbCubit.state!.get<Team>().last.toList().cast()),
          Sex.male,
        ),
      ));
      _countriesForFemales = CountriesRepo(
          initial: countriesHavingTeam(
        countryTeamsBySex(
          teamsByStars(_copiedDbCubit.state!.get<Team>().last.toList().cast()),
          Sex.female,
        ),
      ));
      _countriesForBothSexes = CountriesRepo(
          initial: {
        ..._countriesForMales.last,
        ..._countriesForFemales.last,
      }.toList());
      _updateCountries();
    });

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (!_closed && _dbChangeStatusCubit.state) {
        String? action = await _showSaveChangesDialog();
        final shouldClose = await _shouldCloseAfterDialog(action);
        if (action == 'yes') {
          if (!mounted) return true;
          await _copiedDbCubit.saveChangesToOriginalRepos(context);
        }
        if (!_closed && shouldClose) {
          _closed = shouldClose;
        }
        return shouldClose;
      } else {
        return true;
      }
    });
    super.initState();
  }

  void _initializeRepos() {
    _filtersRepo = DbFiltersRepo(initial: {
      MaleJumper: BehaviorSubject.seeded([]),
      FemaleJumper: BehaviorSubject.seeded([]),
      Hill: BehaviorSubject.seeded([]),
    });
    _selectedIndexesRepo = SelectedIndexesRepo();
  }

  Future<void> _initializeCubits() async {
    _dbChangeStatusCubit = ChangeStatusCubit();
    _itemsTypeCubit = DatabaseItemsTypeCubit();
    _copiedDbCubit = CopiedLocalDbCubit(originalDb: context.read());
    await _copiedDbCubit.setUp();
    _filteredItemsCubit = LocalDbFilteredItemsCubit(
      filtersRepo: _filtersRepo,
      itemsRepos: _copiedDbCubit.state!,
    );
  }

  @override
  void dispose() {
    _bodyAnimationController.dispose();
    _copiedDbCubit.close();
    _copiedDbCubit.dispose();
    _dbChangeStatusCubit.close();
    _itemsTypeCubit.close();
    _selectedIndexesRepo.close();
    _filtersRepo.close();
    _countriesForMales.dispose();
    _countriesForFemales.dispose();
    _countriesForBothSexes.dispose();
    FlutterWindowClose.setWindowShouldCloseHandler(null);
    super.dispose();
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
                  RepositoryProvider.value(value: _filtersRepo),
                  RepositoryProvider.value(value: _selectedIndexesRepo),
                  RepositoryProvider(
                    create: (context) => ValueRepo(initial: _currentTabIndex),
                  )
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: _copiedDbCubit),
                    BlocProvider.value(value: _dbChangeStatusCubit),
                    BlocProvider.value(value: _itemsTypeCubit),
                    BlocProvider.value(value: _filteredItemsCubit),
                  ],
                  child: Builder(builder: (context) {
                    context.watch<CopiedLocalDbCubit>();
                    context.watch<ChangeStatusCubit>();
                    context.watch<DatabaseItemsTypeCubit>();
                    context.watch<LocalDbFilteredItemsCubit>();
                    return RepositoryProvider.value(
                      value: _currentCountries,
                      child: PopScope(
                        canPop: false,
                        onPopInvoked: (didPop) async {
                          if (didPop || _closed) {
                            return;
                          } else if (!_dbChangeStatusCubit.state) {
                            Navigator.pop(context);
                            return;
                          }
                          String? action = await _showSaveChangesDialog();
                          bool shouldClose = await _shouldCloseAfterDialog(action);
                          if (action == 'yes') {
                            if (!context.mounted) return;
                            await _copiedDbCubit.saveChangesToOriginalRepos(context);
                          }
                          if (shouldClose) {
                            _closed = true;
                            if (!context.mounted) return;
                            router.pop(context);
                          }
                        },
                        child: StreamBuilder<Object>(
                            stream: StreamGroup.merge([
                              _filtersRepo.streamByTypeArgument(_itemsTypeCubit.state),
                              _selectedIndexesRepo.selectedIndexes,
                            ]),
                            builder: (context, snapshot) {
                              final selectedIndexes = _selectedIndexesRepo.state;
                              final shouldShowFabs = !_filtersRepo.hasValidFilter;
                              final shouldShowAddFab = selectedIndexes.length <= 1;
                              final shouldShowRemoveFab = selectedIndexes.isNotEmpty;

                              const fabsGap =
                                  Gap(UiDatabaseEditorConstants.verticalSpaceBetweenFabs);

                              return Scaffold(
                                appBar: const _AppBar(),
                                bottomNavigationBar: const _BottomAppBar(),
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
                                                    text: translate(context)
                                                        .maleCompetitiors,
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
                                                    icon: const Icon(
                                                        Symbols.calendar_month),
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
                      ),
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
      _selectedIndexesRepo.clearSelection();
      _filtersRepo.setByGenericAndArgumentType(type: _itemsTypeCubit.state, filters: []);
      _itemsTypeCubit.select(index);
      _currentTabIndex = _SelectedTabIndex(index);
      _updateCountries();
      await _animateBodyFromZero();
    }
  }

  void _updateCountries() {
    _currentCountries = switch (_currentTabIndex) {
      0 => _countriesForMales,
      1 => _countriesForFemales,
      2 || 3 || 4 || 5 => _countriesForBothSexes,
      _ => throw StateError('Invalid tab index'),
    };
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
