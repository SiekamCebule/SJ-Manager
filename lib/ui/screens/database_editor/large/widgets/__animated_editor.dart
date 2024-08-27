part of '../../database_editor_screen.dart';

class _AnimatedEditor extends StatelessWidget {
  const _AnimatedEditor({
    required this.editorKey,
  });

  final GlobalKey<_AppropriateItemEditorState> editorKey;

  @override
  Widget build(BuildContext context) {
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();

    return StreamBuilder(
      stream: selectedIndexesRepo.selectedIndexes,
      builder: (context, snapshot) {
        final editorShouldBeVisible = selectedIndexesRepo.state.length == 1;
        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedVisibility(
              duration: Durations.medium1,
              curve: Curves.easeIn,
              visible: editorShouldBeVisible,
              child: _ItemEditorNonEmptyStateBody(editorKey: editorKey),
            ),
            AnimatedVisibility(
              duration: Durations.medium1,
              curve: Curves.easeIn,
              visible: !editorShouldBeVisible,
              child: const _ItemEditorEmptyStateBody(),
            ),
          ],
        );
      },
    );
  }
}
