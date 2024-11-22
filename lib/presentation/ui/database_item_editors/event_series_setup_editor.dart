import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/data/models/errors/translation_not_found.dart';
import 'package:sj_manager/l10n/event_series_setup_translations.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_image_asset.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/data/repositories/items_repos_registry.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_text_form_field.dart';
import 'package:sj_manager/presentation/ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/db_item_image.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/dialogs/event_series_setup_id_help_dialog.dart';
import 'package:sj_manager/presentation/ui/providers/locale_cubit.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/reusable/text_formatters.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/database_item_images/item_image_not_found_placeholder.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/features/database_editor/presentation/pages/large/dialogs/item_image_help_dialog.dart';
import 'package:sj_manager/utilities/utils/context_maybe_read.dart';
import 'package:sj_manager/utilities/utils/platform.dart';

class EventSeriesSetupEditor extends StatefulWidget {
  const EventSeriesSetupEditor({
    super.key,
    required this.onChange,
  });

  final Function(EventSeriesSetup current) onChange;

  @override
  State<EventSeriesSetupEditor> createState() => EventSeriesSetupEditorState();
}

class EventSeriesSetupEditorState extends State<EventSeriesSetupEditor> {
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priorityController;
  late final TextEditingController _relativeMoneyPrizeController;
  late final TextEditingController _calendarController;

  var _relativeMoneyPrize = EventSeriesRelativeMoneyPrize.average;
  EventSeriesCalendarPreset? _calendarPreset;
  EventSeriesSetup? _cachedSetup;
  late final ScrollController _scrollController;

  final _priorityFieldKey = GlobalKey<MyNumeralTextFieldState>();
  final _idFormFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _scrollController = ScrollController();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priorityController = TextEditingController();
    _relativeMoneyPrizeController = TextEditingController();
    _calendarController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priorityController.dispose();
    _relativeMoneyPrizeController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventSeriesCalendarPresets =
        context.read<ItemsReposRegistry>().get<EventSeriesCalendarPreset>().last;

    return LayoutBuilder(builder: (context, constraints) {
      const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
      final shouldShowLogo = _cachedSetup != null &&
          context.maybeRead<DbItemImageGeneratingSetup<EventSeriesLogoImageWrapper>>() !=
              null;
      return Scrollbar(
        thumbVisibility: platformIsDesktop,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              gap,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextField(
                          key: const Key('name'),
                          controller: _nameController,
                          onChange: () {
                            _validateAndSubmit();
                          },
                          labelText: translate(context).name,
                        ),
                        gap,
                        MyTextField(
                          key: const Key('description'),
                          controller: _descriptionController,
                          onChange: () {
                            _validateAndSubmit();
                          },
                          labelText: translate(context).description,
                        ),
                        gap,
                        Row(
                          children: [
                            Expanded(
                              child: MyTextFormField(
                                key: const Key('id'),
                                textFormFieldKey: _idFormFieldKey,
                                controller: _idController,
                                onChange: () {
                                  _validateAndSubmit();
                                },
                                errorMaxLines: 3,
                                labelText: translate(context).identifier,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return translate(context)
                                        .chooseUniqueIdForEventSeries;
                                  }
                                  return null;
                                },
                                //onSaved: (value) => widget.onChange(_constructAndCache()),
                              ),
                            ),
                            const Gap(
                                UiFieldWidgetsConstants.gapBetweenFieldAndHelpButton),
                            HelpIconButton(onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 700),
                                    child: const EventSeriesSetupIdHelpDialog(),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        gap,
                        MyNumeralTextField(
                          key: _priorityFieldKey,
                          controller: _priorityController,
                          onChange: () {
                            _validateAndSubmit();
                          },
                          formatters: doubleTextInputFormatters,
                          labelText: 'Priorytet',
                          min: 1,
                          max: 10,
                          step: 1,
                          onHelpButtonTap: () {
                            showSimpleHelpDialog(
                              context: context,
                              title: 'Priorytet',
                              content:
                                  'Im niższa cyfra, tym zawody są ważniejsze. Najważniejszy cykl w symulacji powinien mieć numer 1, tak jak imprezy mistrzowskie. Zaplecze jako 2, zaplecze zaplecza 3, i tak dalej...',
                            );
                          },
                        ),
                        gap,
                        MyDropdownField(
                          controller: _relativeMoneyPrizeController,
                          onChange: (value) {
                            _relativeMoneyPrize = value!;
                            _validateAndSubmit();
                          },
                          entries: EventSeriesRelativeMoneyPrize.values.map((prize) {
                            return DropdownMenuEntry(
                                value: prize,
                                label: translatedRelativeMoneyPrize(context, prize));
                          }).toList(),
                          width: constraints.maxWidth,
                          initial: _relativeMoneyPrize,
                          label: Text(translate(context).relativeMoneyPrize),
                          onHelpButtonTap: () {
                            showSimpleHelpDialog(
                              context: context,
                              title: 'Nagroda pieniężna',
                              content:
                                  'Na nagrody pieniężne w cyklu w dużym stopniu wpływa priorytet. Tutaj możemy to jeszcze wyregulować. Przykładowo w Raw Air nagrody te są większe niż w TCS, który ma za to większy prestiż',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap(UiItemEditorsConstants.itemImageHorizontalMargin),
                  if (shouldShowLogo)
                    Flexible(
                      flex: 4,
                      child: DbItemImage<EventSeriesLogoImageWrapper>(
                        key: const Key('image'),
                        item:
                            EventSeriesLogoImageWrapper(eventSeriesSetup: _cachedSetup!),
                        setup: context.read(),
                        height: UiItemEditorsConstants.hillImageHeight,
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => ItemImageNotFoundPlaceholder(
                          width: UiItemEditorsConstants.hillImagePlaceholderWidth,
                          height: UiItemEditorsConstants.hillImageHeight,
                          helpDialog: ItemImageHelpDialog(
                            content: translate(context).eventSeriesLogoHelpContent,
                          ),
                        ),
                      ),
                    ),
                  if (shouldShowLogo)
                    const Gap(UiItemEditorsConstants.itemImageHorizontalMargin),
                ],
              ),
              gap,
              MyDropdownField<EventSeriesCalendarPreset>(
                width: constraints.maxWidth,
                label: const Text('Domyślny kalendarz'),
                onChange: (preset) {
                  setState(() {
                    _calendarPreset = preset;
                  });
                  _validateAndSubmit();
                },
                entries: [
                  ...eventSeriesCalendarPresets.map((preset) {
                    return DropdownMenuEntry(value: preset, label: preset.name);
                  }),
                ],
                onHelpButtonTap: () {
                  showSimpleHelpDialog(
                      context: context,
                      title: 'Domyślny kalendarz',
                      content:
                          'Zostanie on automatycznie przypisany do cyklu podczas rozpoczynania rozgrywki');
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _validateAndSubmit() {
    final idIsOk = _idFormFieldKey.currentState!.validate();
    if (idIsOk) {
      widget.onChange(_constructAndCache());
    }
  }

  EventSeriesSetup _constructAndCache() {
    final languageCode = context.read<LocaleCubit>().languageCode;
    var changedTranslatedName = _nameController.text;
    if (changedTranslatedName.isEmpty) {
      changedTranslatedName = translate(context).unnamed;
    }
    var changedTranslatedDescription = _descriptionController.text;
    var name = _cachedSetup!.multilingualName
        .copyWith(languageCode: languageCode, value: changedTranslatedName);
    var description = _cachedSetup!.multilingualDescription
        ?.copyWith(languageCode: languageCode, value: changedTranslatedDescription);
    final setup = EventSeriesSetup(
      id: _idController.text,
      multilingualName: name,
      multilingualDescription: description,
      relativeMoneyPrize: _relativeMoneyPrize,
      priority: int.tryParse(_priorityController.text) ?? 1,
      calendarPreset: _calendarPreset,
    );
    return setup;
  }

  void setUp(EventSeriesSetup setup) {
    setState(() {
      _cachedSetup = setup;
      _fillFields(setup);
      FocusScope.of(context).unfocus();
    });
  }

  void _fillFields(EventSeriesSetup setup) {
    try {
      _nameController.text = setup.name(context);
    } on TranslationNotFoundError {
      _nameController.text = translate(context).unnamed;
    }
    _relativeMoneyPrize = setup.relativeMoneyPrize;
    _relativeMoneyPrizeController.text =
        translatedRelativeMoneyPrize(context, _relativeMoneyPrize);
    _priorityController.text = setup.priority.toString();
    _idController.text = setup.id;
    _idFormFieldKey.currentState!.validate();
  }
}
