part of '../database_editor_page.dart';

extension type _SelectedTabIndex(int index) {}

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> with SingleTickerProviderStateMixin {
  var _closed = false;

  @override
  void initState() {
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      final changeStatus = context.read<DatabaseEditorChangeStatusCubit>().state;
      if (!_closed && changeStatus is DatabaseEditorChangeStatusChanged) {
        String? action = await _showSaveChangesDialog();
        final shouldClose = await _shouldCloseAfterDialog(action);
        if (action == 'yes') {
          await _endEditing();
        }
        if (!_closed && shouldClose) {
          _closed = shouldClose;
        }
        if (shouldClose) {
          _cleanResources();
        }
        return shouldClose;
      } else {
        _cleanResources();
        return true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) async {
        final changeStatus = context.read<DatabaseEditorChangeStatusCubit>().state;
        if (didPop || _closed) {
          return;
        } else if (changeStatus is DatabaseEditorChangeStatusNotChanged) {
          _cleanResources();
          Navigator.pop(context);
          return;
        }
        String? action = await _showSaveChangesDialog();
        bool shouldClose = await _shouldCloseAfterDialog(action);
        if (action == 'yes') {
          await _endEditing();
        }
        if (shouldClose) {
          _cleanResources();
          _closed = true;
          if (!context.mounted) return;
          router.pop(context);
        }
      },
      child: const _MainBody(),
    );
    return AnimatedSwitcher(
      duration: Durations.long2,
      switchInCurve: Curves.easeInExpo,
      switchOutCurve: Curves.decelerate,
      child: child,
    );
  }

  @override
  void dispose() {
    if (!_closed) {
      _cleanResources();
    }
    FlutterWindowClose.setWindowShouldCloseHandler(null);

    super.dispose();
  }

  Future<void> _endEditing() async {
    await _constructEditedGameVariant();
    if (!mounted) return;
    final constructedVariant = (context.read<DatabaseEditorEditedGameVariantCubit>().state
            as DatabaseEditorEditedGameVariantAvailable)
        .editedVariant;
    await context.read<GameVariantCubit>().endEditingVariant(constructedVariant);
  }

  Future<void> _constructEditedGameVariant() async {
    await context.read<DatabaseEditorEditedGameVariantCubit>().construct();
  }

  void _cleanResources() {
    debugPrint('_Large(): _cleanResources()');
  }

  Future<String?> _showSaveChangesDialog() async {
    return showSjmDialog<String>(
      barrierDismissible: true,
      context: context,
      child: const DatabaseEditorUnsavedChangesDialog(),
    );
  }

  Future<bool> _shouldCloseAfterDialog(String? action) async {
    return switch (action) {
      'no' => true,
      'yes' => true,
      _ => false,
    };
  }
}
