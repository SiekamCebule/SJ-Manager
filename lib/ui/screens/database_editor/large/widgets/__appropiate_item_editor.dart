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
  final _hillEditorKey = GlobalKey<HillEditorState>();

  @override
  Widget build(BuildContext context) {
    return switch (widget.itemType) {
      DatabaseItemType.maleJumper || DatabaseItemType.femaleJumper => JumperEditor(
          key: _jumperEditorKey,
          onChange: widget.onChange,
        ),
      DatabaseItemType.hill => HillEditor(
          key: _hillEditorKey,
          onChange: widget.onChange,
        ),
    };
  }

  void fill(dynamic item) {
    switch (widget.itemType) {
      case DatabaseItemType.maleJumper:
      case DatabaseItemType.femaleJumper:
        _jumperEditorKey.currentState?.setUp(item);
      case DatabaseItemType.hill:
        _hillEditorKey.currentState?.setUp(item);
    }
  }
}
