part of '../../database_editor_page.dart';

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> with SingleTickerProviderStateMixin {
  late final AnimationController _bodyAnimationController;

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
    final selectionState = context.read<DatabaseEditorSelectionCubit>().state;
    final filtersState = context.watch<DatabaseEditorFiltersCubit>().state;
    final shouldShowAddFab = selectionState.selection.length <= 1;
    final shouldShowRemoveFab = selectionState.selection.isNotEmpty;

    const fabsGap = Gap(UiDatabaseEditorConstants.verticalSpaceBetweenFabs);

    return Scaffold(
      appBar: const _AppBar(),
      bottomNavigationBar: const _BottomAppBar(),
      body: Row(
        children: [
          fabsGap,
          AnimatedVisibility(
            duration: Durations.short3,
            curve: Curves.easeIn,
            visible: !filtersState.validFilterExists,
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
  }

  Future<void> _onChangeTab(int index) async {
    final tabIndex = context.watch<DatabaseEditorItemsTypeCubit>().state.type.index;
    if (tabIndex != index) {
      context.read<DatabaseEditorItemsTypeCubit>().setByIndex(index);
      await _animateBodyFromZero();
    }
  }

  Future<void> _animateBodyFromZero() async {
    await _bodyAnimationController.forward(from: 0.0);
  }
}
