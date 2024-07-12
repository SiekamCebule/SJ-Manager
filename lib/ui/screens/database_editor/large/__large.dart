part of '../database_editor_screen.dart';

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> with SingleTickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;

  late final LocalDbReposRepo _originalDb;
  late final DbFiltersRepo _filtersRepo;
  late final SelectedIndexesRepo _selectedIndexesRepo;

  late final CopiedLocalDbCubit _copiedDbCubit;
  late final ChangeStatusCubit _dbChangeStatusCubit;
  late final DatabaseItemsTypeCubit _itemsTypeCubit;
  late final LocalDbFilteredItemsCubit _filteredItemsCubit;

  final _initialized = ValueNotifier<bool>(false);
  var _closed = false;
  var _currentTabIndex = 0;

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
    _originalDb = LocalDbReposRepo(
      maleJumpersRepo: context.read<DbItemsRepo<MaleJumper>>(),
      femaleJumpersRepo: context.read<DbItemsRepo<FemaleJumper>>(),
      hillsRepo: context.read<DbItemsRepo<Hill>>(),
    );
    _filtersRepo = DbFiltersRepo();
    _selectedIndexesRepo = SelectedIndexesRepo();
  }

  Future<void> _initializeCubits() async {
    _dbChangeStatusCubit = ChangeStatusCubit();
    _itemsTypeCubit = DatabaseItemsTypeCubit();
    _copiedDbCubit = CopiedLocalDbCubit(originalRepositories: _originalDb);
    await _copiedDbCubit.setUp();
    _filteredItemsCubit = LocalDbFilteredItemsCubit(
      filtersRepo: _filtersRepo,
      itemsRepo: _copiedDbCubit.state!,
    );
  }

  @override
  void dispose() {
    _bodyAnimationController.dispose();
    _copiedDbCubit.close();
    _dbChangeStatusCubit.close();
    _itemsTypeCubit.close();
    _selectedIndexesRepo.close();
    _filtersRepo.close();
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
      'cancel' => false,
      'no' => true,
      'yes' => true,
      _ => throw StateError('Invalid action ID'),
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
                  RepositoryProvider.value(value: _originalDb),
                  RepositoryProvider.value(value: _filtersRepo),
                  RepositoryProvider.value(value: _selectedIndexesRepo),
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
                    return PopScope(
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
                            _filtersRepo.byType(_itemsTypeCubit.state),
                            _selectedIndexesRepo.selectedIndexes,
                          ]),
                          builder: (context, snapshot) {
                            final selectedIndexes = _selectedIndexesRepo.state;
                            final shouldShowFabs = !_filtersRepo.hasValidFilter;
                            const fabsGap =
                                Gap(UiDatabaseEditorConstants.verticalSpaceBetweenFabs);

                            return Scaffold(
                              appBar: const _AppBar(),
                              bottomNavigationBar: const _BottomAppBar(),
                              body: Row(
                                children: [
                                  fabsGap,
                                  AnimatedOpacity(
                                    duration: Durations.short3,
                                    opacity: shouldShowFabs ? 1 : 0,
                                    curve: Curves.easeIn,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        fabsGap,
                                        AnimatedOpacity(
                                          duration: Durations.short3,
                                          curve: Curves.easeIn,
                                          opacity: selectedIndexes.length <= 1 ? 1 : 0,
                                          child: const _AddFab(),
                                        ),
                                        fabsGap,
                                        AnimatedOpacity(
                                          duration: Durations.short3,
                                          curve: Curves.easeIn,
                                          opacity: selectedIndexes.isNotEmpty ? 1 : 0,
                                          child: const _RemoveFab(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(10),
                                  DefaultTabController(
                                    length: 3,
                                    child: Expanded(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            TabBar(
                                              tabs: const [
                                                Tab(
                                                  text: 'Zawodnicy',
                                                  icon: Icon(Symbols.male),
                                                ),
                                                Tab(
                                                  text: 'Zawodniczki',
                                                  icon: Icon(Symbols.female),
                                                ),
                                                Tab(
                                                  text: 'Skocznie',
                                                  icon: ImageIcon(hillIcon),
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
    _itemsTypeCubit.select(DatabaseItemType.fromIndex(index));
    _selectedIndexesRepo.clearSelection();
    if (index != _currentTabIndex) {
      await _animateBodyFromZero();
      _currentTabIndex = index;
    }
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
