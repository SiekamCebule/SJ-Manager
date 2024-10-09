import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/ui/database_item_editors/default_competition_rules_preset_editor/default_competition_rules_editor.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

class DefaultCompetitionRulesPresetEditor extends StatefulWidget {
  const DefaultCompetitionRulesPresetEditor({
    super.key,
    required this.initial,
    required this.onChange,
    required this.onAdvancedEditorChosen,
  });

  final DefaultCompetitionRulesPreset initial;
  final Function(DefaultCompetitionRulesPreset current) onChange;
  final VoidCallback onAdvancedEditorChosen;

  @override
  State<DefaultCompetitionRulesPresetEditor> createState() =>
      _DefaultCompetitionRulesPresetEditorState();
}

class _DefaultCompetitionRulesPresetEditorState
    extends State<DefaultCompetitionRulesPresetEditor> {
  final _rulesEditorKey = GlobalKey<DefaultCompetitionRulesEditorState>();
  late final TextEditingController _nameController;

  DefaultCompetitionRules? _rules;

  @override
  void initState() {
    _nameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _fillFields(widget.initial);
      });
      _rules = _rulesEditorKey.currentState!.currentCached!;
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap,
            MyTextField(
              controller: _nameController,
              onChange: _onChange,
              labelText: translate(context).name,
            ),
            gap,
            Expanded(
              child: DefaultCompetitionRulesEditor(
                key: _rulesEditorKey,
                initial: widget.initial.rules,
                addGapsOnFarSides: false,
                scrollable: false,
                onChange: (currentRules) {
                  _rules = currentRules;
                  _onChange();
                },
                onAdvancedEditorChosen: () {
                  // TODO: Implement this
                  throw UnimplementedError();
                },
              ),
            ),
            gap,
          ],
        ),
      ),
    );
  }

  void _onChange() {
    widget.onChange(_constructAndCache());
  }

  DefaultCompetitionRulesPreset _constructAndCache() {
    final preset = DefaultCompetitionRulesPreset(
      name: _nameController.text,
      rules: _rules!,
    );
    return preset;
  }

  void setUp(DefaultCompetitionRulesPreset preset) {
    setState(() {
      _fillFields(preset);
      FocusScope.of(context).unfocus();
    });
  }

  void _fillFields(DefaultCompetitionRulesPreset preset) {
    _nameController.text = preset.name;
    _rulesEditorKey.currentState!.setUp(preset.rules);
  }
}
