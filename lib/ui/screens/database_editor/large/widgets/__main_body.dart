part of '../../database_editor_screen.dart';

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> with SingleTickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;
  var _currentTabIndex = _SelectedTabIndex(0);

  @override
  void initState() {
    _bodyAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value: 1.0,
    );
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
                    length: 2,
                    child: Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(
                                  text: translate(context).maleCompetitiors,
                                  icon: const Icon(Symbols.male),
                                ),
                                Tab(
                                  text: translate(context).femaleCompetitors,
                                  icon: const Icon(Symbols.female),
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
      context.read<DatabaseItemsCubit>().selectTab(index);
      _currentTabIndex = _SelectedTabIndex(index);
      await _animateBodyFromZero();
    }
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
