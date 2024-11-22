part of '../../database_editor_page.dart';

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
  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.watch<DatabaseEditorSelectionCubit>();
    final editorShouldBeVisible = selectionCubit.state.selection.length == 1;
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
  }
}
