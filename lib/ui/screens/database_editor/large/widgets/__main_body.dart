part of '../../database_editor_screen.dart';

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> with SingleTickerProviderStateMixin {
  final _fabsColumnKey = GlobalKey();
  final _tabsRowKey = GlobalKey();

  late final AnimationController _bodyAnimationController;
  var _currentTabIndex = _SelectedTabIndex(0);

  @override
  void initState() {
    _bodyAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value: 1.0,
    );
    scheduleMicrotask(() async {
      final tutorialRunner = context.read<_TutorialRunner>();
      tutorialRunner.addWidgetKey(step: _TutorialStep.fabs, key: _fabsColumnKey);
      tutorialRunner.addWidgetKey(step: _TutorialStep.tabs, key: _tabsRowKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _bodyAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndexes = context.read<SelectedIndexesRepo>();
    final filters = context.read<DbFiltersRepo>();
    final items = context.watch<DatabaseItemsCubit>();
    return Provider.value(
      value: ValueRepo(initial: _currentTabIndex),
      child: StreamBuilder<Object>(
          stream: StreamGroup.merge([
            selectedIndexes.stream,
          ]),
          builder: (context, snapshot) {
            final shouldShowFabs = !filters.hasValidFilter;
            final shouldShowAddFab = selectedIndexes.last.length <= 1;
            final shouldShowRemoveFab = selectedIndexes.last.isNotEmpty;
            final itemsType = items.state.itemsType;
            final shouldShowBottomAppBar =
                itemsType == MaleJumper || itemsType == FemaleJumper || itemsType == Hill;

            const fabsGap = Gap(UiDatabaseEditorConstants.verticalSpaceBetweenFabs);

            return Scaffold(
              appBar: const _AppBar(),
              bottomNavigationBar: shouldShowBottomAppBar ? const _BottomAppBar() : null,
              body: Row(
                children: [
                  fabsGap,
                  AnimatedVisibility(
                    duration: Durations.short3,
                    curve: Curves.easeIn,
                    visible: shouldShowFabs,
                    child: Column(
                      key: _fabsColumnKey,
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
                              key: _tabsRowKey,
                              tabs: [
                                Tab(
                                  text: translate(context).maleCompetitiors,
                                  icon: const Icon(Symbols.male),
                                ),
                                Tab(
                                  text: translate(context).femaleCompetitors,
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
                                  icon: const Icon(Symbols.calendar_month),
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
                                    child: const _ItemsAndEditorRow(),
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
  }

  Future<void> _onChangeTab(int index) async {
    if (_currentTabIndex.index != index) {
      context.read<SelectedIndexesRepo>().clearSelection();
      context.read<DbFiltersRepo>().clear();
      context.read<DatabaseItemsCubit>().selectByIndex(index);
      _currentTabIndex = _SelectedTabIndex(index);
      await _animateBodyFromZero();
    }
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
