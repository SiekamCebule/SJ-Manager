part of '../../database_editor_screen.dart';

class _AnimatedEditor extends StatelessWidget {
  const _AnimatedEditor({
    this.editorKey,
  });

  final GlobalKey<_AppropriateItemEditorState>? editorKey;

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsTypeCubit>().state;

    final copiedLocalDbCubit = context.read<CopiedLocalDbCubit>();
    final copiedLocalDbRepos = copiedLocalDbCubit.state!;
    final editableItemsRepoByType = copiedLocalDbRepos.getEditable(itemsType);

    final filtersRepo = context.read<DbFiltersRepo>();
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
    final dbIsChangedCubit = context.read<ChangeStatusCubit>();

    return StreamBuilder(
      stream: MergeStream([
        selectedIndexesRepo.selectedIndexes,
        editableItemsRepoByType.items,
        filtersRepo.streamByTypeArgument(itemsType),
      ]),
      builder: (context, snapshot) {
        final editorShouldBeVisible = selectedIndexesRepo.state.length == 1;
        return AnimatedVisibility(
          duration: Durations.medium1,
          curve: Curves.easeIn,
          visible: editorShouldBeVisible,
          child: _AppropriateItemEditor(
            key: editorKey,
            itemType: itemsType,
            onChange: (changedItem) async {
              if (changedItem is DefaultCompetitionRulesPreset) {
                print(
                    '_AnimatedEditor: changedItem as rules preset, ko rules: ${changedItem.competitionRules.rounds.first.koRules}');
              }
              if (selectedIndexesRepo.state.length == 1 && changedItem != null) {
                final index = selectedIndexesRepo.state.single;
                editableItemsRepoByType.replace(oldIndex: index, newItem: changedItem);
                dbIsChangedCubit.markAsChanged();
              }
            },
          ),
        );
      },
    );
  }
}
