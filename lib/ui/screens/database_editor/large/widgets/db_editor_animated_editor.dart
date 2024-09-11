part of '../../database_editor_screen.dart';

class DbEditorAnimatedEditor extends StatefulWidget {
  const DbEditorAnimatedEditor({
    super.key,
    required this.nonEmptyStateWidget,
    required this.emptyStateWidget,
  });

  final Widget nonEmptyStateWidget;
  final Widget? emptyStateWidget;

  @override
  State<DbEditorAnimatedEditor> createState() => DbEditorAnimatedEditorState();
}

class DbEditorAnimatedEditorState extends State<DbEditorAnimatedEditor> {
  final _editorStreamBuilderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();

    return StreamBuilder(
      key: _editorStreamBuilderKey,
      stream: selectedIndexesRepo.stream,
      builder: (context, snapshot) {
        final editorShouldBeVisible = selectedIndexesRepo.last.length == 1;
        print('EDITOR SHOULD BE VISIBLE: $editorShouldBeVisible');
        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedVisibility(
              key: const Key('animatedEditorNonEmpty'),
              duration: Durations.medium1,
              curve: Curves.easeIn,
              visible: editorShouldBeVisible,
              child: widget.nonEmptyStateWidget,
            ),
            if (widget.emptyStateWidget != null)
              AnimatedVisibility(
                duration: Durations.medium1,
                curve: Curves.easeIn,
                visible: !editorShouldBeVisible,
                child: widget.emptyStateWidget!,
              ),
          ],
        );
      },
    );
  }
}
