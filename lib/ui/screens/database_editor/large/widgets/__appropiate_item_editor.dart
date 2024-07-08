part of '../../database_editor_screen.dart';

class _AppropiateItemEditor extends StatefulWidget {
  const _AppropiateItemEditor({
    super.key,
    required this.itemType,
    required this.onChange,
  });

  final DatabaseItemType itemType;
  final Function(Object?) onChange;

  @override
  State<_AppropiateItemEditor> createState() => _AppropiateItemEditorState();
}

class _AppropiateItemEditorState extends State<_AppropiateItemEditor> {
  final _jumperEditorKey = GlobalKey<JumperEditorState>();

  @override
  Widget build(BuildContext context) {
    return switch (widget.itemType) {
      DatabaseItemType.maleJumper || DatabaseItemType.femaleJumper => JumperEditor(
          key: _jumperEditorKey,
          onChange: widget.onChange,
        )
    };
  }

  void fill(dynamic item) {
    _jumperEditorKey.currentState?.fillFields(item);
  }
}
