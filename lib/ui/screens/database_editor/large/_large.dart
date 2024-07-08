part of '../database_editor_screen.dart';

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> with SingleTickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;

  late final LocalDbReposRepository _localDbOriginalRepos;
  late final FiltersRepository _localDbFiltersRepo;
  late final SelectedIndexesRepository _localDbSelectedIndexesRepo;

  late final LocalDbReposCubit _localDbReposCubit;
  late final LocalDbIsChangedCubit _localDbIsChangedCubit;
  late final DatabaseItemsTypeCubit _localDbItemsTypeCubit;
  late final LocalDbFilteredItemsCubit _localDbFilteredItemsCubit;

  var _closed = false;
  var _currentTabIndex = 0;

  @override
  void initState() {
    _bodyAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value: 1.0,
    );

    _initializeRepos();
    _initializeCubits();

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (!_closed && _localDbIsChangedCubit.state) {
        String? action = await _showSaveChangesDialog();
        final shouldClose = await _shouldCloseAfterDialog(action);
        if (action == 'yes') {
          await _localDbReposCubit.endEditing();
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
    _localDbOriginalRepos = LocalDbReposRepository(
      maleJumpersRepo: context.read<DatabaseItemsRepository<MaleJumper>>(),
      femaleJumpersRepo: context.read<DatabaseItemsRepository<FemaleJumper>>(),
    );
    _localDbFiltersRepo = FiltersRepository();
    _localDbSelectedIndexesRepo = SelectedIndexesRepository();
  }

  Future<void> _initializeCubits() async {
    _localDbIsChangedCubit = LocalDbIsChangedCubit();
    _localDbItemsTypeCubit = DatabaseItemsTypeCubit();
    _localDbReposCubit = LocalDbReposCubit(originalRepositories: _localDbOriginalRepos);
    await _localDbReposCubit.setUp();
    _localDbFilteredItemsCubit = LocalDbFilteredItemsCubit(
      filtersRepo: _localDbFiltersRepo,
      editableItemsRepo: _localDbReposCubit.state.editableRepositories!,
    );
  }

  @override
  void dispose() {
    _bodyAnimationController.dispose();
    _localDbReposCubit.close();
    _localDbIsChangedCubit.close();
    _localDbItemsTypeCubit.close();
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
    return BlocSelector<LocalDbReposCubit, LocalDbReposState, bool>(
      selector: (state) => state.prepared,
      builder: (context, prepared) {
        final mainBody = MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: _localDbOriginalRepos),
            RepositoryProvider.value(value: _localDbFiltersRepo),
            RepositoryProvider.value(value: _localDbSelectedIndexesRepo),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _localDbReposCubit),
              BlocProvider.value(value: _localDbIsChangedCubit),
              BlocProvider.value(value: _localDbItemsTypeCubit),
              BlocProvider.value(value: _localDbFilteredItemsCubit),
            ],
            child: Builder(builder: (context) {
              context.watch<LocalDbReposCubit>();
              context.watch<LocalDbIsChangedCubit>();
              context.watch<DatabaseItemsTypeCubit>();
              context.watch<LocalDbFilteredItemsCubit>();
              return PopScope(
                canPop: false,
                onPopInvoked: (didPop) async {
                  if (didPop || _closed) {
                    return;
                  } else if (!_localDbIsChangedCubit.state) {
                    Navigator.pop(context);
                    return;
                  }
                  String? action = await _showSaveChangesDialog();
                  bool shouldClose = await _shouldCloseAfterDialog(action);
                  if (action == 'yes') {
                    await _localDbReposCubit.endEditing();
                  }
                  if (shouldClose) {
                    _closed = true;
                    if (!context.mounted) return;
                    router.pop(context);
                  }
                },
                child: Builder(builder: (context) {
                  final itemsType = _localDbItemsTypeCubit.state;
                  final selectedIndexes = _localDbSelectedIndexesRepo.state;
                  final filteredItems = _localDbFilteredItemsCubit.state;
                  final editableItemsForCurrentType =
                      _localDbReposCubit.state.editableRepositories!.byType(itemsType);
                  final defaultItems = context.watch<DefaultItemsRepository>();

                  final shouldShowFabs = _localDbFiltersRepo.byType(itemsType).isEmpty;

                  return Scaffold(
                    appBar: const _AppBar(),
                    bottomNavigationBar: const _BottomAppBar(),
                    body: Row(
                      children: [
                        const Gap(10),
                        AnimatedOpacity(
                          duration: Durations.short3,
                          opacity: shouldShowFabs ? 1 : 0,
                          curve: Curves.easeIn,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Gap(10),
                              AnimatedOpacity(
                                duration: Durations.short3,
                                curve: Curves.easeIn,
                                opacity: selectedIndexes.length <= 1 ? 1 : 0,
                                child: FloatingActionButton(
                                  heroTag: 'FABadd',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primaryContainer,
                                  onPressed: () async {
                                    bool selectedExists = selectedIndexes.length == 1;
                                    final lastIndex =
                                        filteredItems.byType(itemsType).length;
                                    late int addIndex;
                                    if (selectedExists) {
                                      addIndex = selectedIndexes.single + 1;
                                    } else {
                                      addIndex = lastIndex;
                                    }
                                    editableItemsForCurrentType
                                        .add(defaultItems.byDatabaseItemType(itemsType));

                                    if (selectedExists) {
                                      _localDbSelectedIndexesRepo.setSelection(
                                          addIndex - 1, false);
                                    }
                                    _localDbSelectedIndexesRepo.setSelection(
                                        addIndex, true);
                                  },
                                  tooltip: 'Dodaj',
                                  child: const Icon(Symbols.add),
                                ),
                              ),
                              const Gap(10),
                              AnimatedOpacity(
                                duration: Durations.short3,
                                curve: Curves.easeIn,
                                opacity: selectedIndexes.isNotEmpty ? 1 : 0,
                                child: FloatingActionButton(
                                  heroTag: 'FABremove',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiaryContainer,
                                  onPressed: () async {
                                    var subtraction = 0;
                                    for (var removeIndex in selectedIndexes) {
                                      removeIndex -= subtraction;
                                      editableItemsForCurrentType.removeAt(removeIndex);
                                      subtraction += 1;
                                    }
                                    if (selectedIndexes.length > 1) {
                                      _localDbSelectedIndexesRepo.clearSelection();
                                    } else {
                                      _localDbSelectedIndexesRepo.setSelection(
                                          selectedIndexes.single, true);
                                    }
                                  },
                                  tooltip: 'Usuń',
                                  child: const Icon(Symbols.remove),
                                ),
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
                                    onTap: (index) async {
                                      _localDbItemsTypeCubit
                                          .select(DatabaseItemType.fromIndex(index));
                                      if (index != _currentTabIndex) {
                                        await _animateBodyFromZero();
                                        _currentTabIndex = index;
                                      }
                                    },
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
        );
        const progressIndicator = Center(
          child: SizedBox.square(
            dimension: 150,
            child: CircularProgressIndicator(),
          ),
        );
        return AnimatedSwitcher(
          duration: Durations.long2,
          switchInCurve: Curves.easeInExpo,
          switchOutCurve: Curves.decelerate,
          child: prepared
              ? mainBody
              : const Scaffold(
                  body: Center(
                    child: progressIndicator,
                  ),
                ),
        );
      },
    );
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
