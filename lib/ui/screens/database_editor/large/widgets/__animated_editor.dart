part of '../../database_editor_screen.dart';

class _AnimatedEditor extends StatefulWidget {
  const _AnimatedEditor({
    required this.editorKey,
  });

  final GlobalKey<_AppropriateItemEditorState> editorKey;

  @override
  State<_AnimatedEditor> createState() => _AnimatedEditorState();
}

class _AnimatedEditorState extends State<_AnimatedEditor> {
  final _editorStreamBuilderKey = GlobalKey();

  @override
  void initState() {
    scheduleMicrotask(() async {
      context
          .read<_TutorialRunner>()
          .addWidgetKey(step: _TutorialStep.editor, key: _editorStreamBuilderKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();

    return StreamBuilder(
      key: _editorStreamBuilderKey,
      stream: selectedIndexesRepo.stream,
      builder: (context, snapshot) {
        final editorShouldBeVisible = selectedIndexesRepo.last.length == 1;
        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedVisibility(
              key: const Key('animatedEditorNonEmpty'),
              duration: Durations.medium1,
              curve: Curves.easeIn,
              visible: editorShouldBeVisible,
              child: _ItemEditorNonEmptyStateBody(editorKey: widget.editorKey),
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
