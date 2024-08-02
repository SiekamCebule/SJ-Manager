import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/user_db/hill/typical_wind_direction.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/l10n/hill_parameters_translations.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_profile_type.dart';
import 'package:sj_manager/models/user_db/hill/jumps_variability.dart';
import 'package:sj_manager/models/user_db/hill/landing_ease.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_numeral_text_field.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/arrow_icon.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable/text_formatters.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/hill_image.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/item_image_not_found_placeholder.dart';
import 'package:sj_manager/ui/reusable_widgets/menu_entries/predefined_reusable_entries.dart';
import 'package:sj_manager/utils/context_maybe_read.dart';
import 'package:sj_manager/utils/math.dart';
import 'package:sj_manager/utils/platform.dart';

class HillEditor extends StatefulWidget {
  const HillEditor({
    super.key,
    required this.onChange,
    this.enableEditingDimensions = true,
    this.enableEditingLocality = true,
    this.enableEditingName = true,
    this.enableEditingCountry = true,
    required this.countriesRepo,
  });

  final Function(Hill? current) onChange;
  final bool enableEditingDimensions;
  final bool enableEditingLocality;
  final bool enableEditingName;
  final bool enableEditingCountry;
  final CountriesRepo countriesRepo;

  @override
  State<HillEditor> createState() => HillEditorState();
}

class HillEditorState extends State<HillEditor> {
  final _countriesDropdownKey = GlobalKey<CountriesDropdownState>();

  late final TextEditingController _localityController;
  late final TextEditingController _nameController;
  late final TextEditingController _kController;
  late final TextEditingController _hsController;
  late final TextEditingController _typicalWindStrengthController;
  late final TextEditingController _pointsForGateController;
  late final TextEditingController _pointsForHeadwindController;
  late final TextEditingController _pointsForTailwindController;

  late final TextEditingController _landingEaseController;
  late final TextEditingController _profileController;
  late final TextEditingController _jumpsVariabilityController;
  late final TextEditingController _typicalWindDirectionController;

  var _landingEase = LandingEase.average;
  var _profile = HillProfileType.balanced;
  var _jumpsVariability = JumpsVariability.average;
  TypicalWindDirection? _typicalWindDirection;
  Country? _country;

  Hill? _cachedHill;

  late final ScrollController _scrollController;

  @override
  void initState() {
    _localityController = TextEditingController();
    _nameController = TextEditingController();
    _kController = TextEditingController();
    _hsController = TextEditingController();
    _typicalWindStrengthController = TextEditingController();
    _pointsForGateController = TextEditingController();
    _pointsForHeadwindController = TextEditingController();
    _pointsForTailwindController = TextEditingController();
    _landingEaseController = TextEditingController();
    _profileController = TextEditingController();
    _jumpsVariabilityController = TextEditingController();
    _typicalWindDirectionController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _localityController.dispose();
    _nameController.dispose();
    _kController.dispose();
    _hsController.dispose();
    _typicalWindStrengthController.dispose();
    _pointsForGateController.dispose();
    _pointsForHeadwindController.dispose();
    _pointsForTailwindController.dispose();
    _landingEaseController.dispose();
    _profileController.dispose();
    _jumpsVariabilityController.dispose();
    _typicalWindDirectionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiItemEditorsConstants.verticalSpaceBetweenFields);
    return LayoutBuilder(builder: (context, constraints) {
      final shouldShowImage = _cachedHill != null &&
          context.maybeRead<DbItemImageGeneratingSetup<Hill>>() != null;
      final shouldShowArrowIcon = _cachedHill?.typicalWindDirection != null;

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
                          enabled: widget.enableEditingName,
                          controller: _nameController,
                          onChange: () {
                            widget.onChange(_constructAndCacheHill());
                          },
                          labelText: translate(context).name,
                        ),
                        gap,
                        MyTextField(
                          key: const Key('locality'),
                          enabled: widget.enableEditingLocality,
                          controller: _localityController,
                          onChange: () {
                            widget.onChange(_constructAndCacheHill());
                          },
                          formatters: const [
                            CapitalizeTextFormatter(),
                          ],
                          labelText: translate(context).locality,
                        ),
                        gap,
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return CountriesDropdown(
                              enabled: widget.enableEditingCountry,
                              width: constraints.maxWidth,
                              key: _countriesDropdownKey,
                              countriesRepo: widget.countriesRepo,
                              onSelected: (maybeCountry) {
                                _country = maybeCountry;
                                widget.onChange(_constructAndCacheHill());
                              },
                            );
                          },
                        ),
                        gap,
                      ],
                    ),
                  ),
                  const Gap(UiItemEditorsConstants.itemImageHorizontalMargin),
                  if (shouldShowImage)
                    Flexible(
                      flex: 4,
                      child: HillImage(
                        key: const Key('image'),
                        hill: _cachedHill!,
                        setup: context.read(),
                        height: UiItemEditorsConstants.hillImageHeight,
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => const ItemImageNotFoundPlaceholder(
                          width: UiItemEditorsConstants.hillImagePlaceholderWidth,
                          height: UiItemEditorsConstants.hillImageHeight,
                        ),
                      ),
                    ),
                  if (shouldShowImage)
                    const Gap(UiItemEditorsConstants.itemImageHorizontalMargin),
                ],
              ),
              MyNumeralTextField(
                key: const Key('k'),
                enabled: widget.enableEditingDimensions,
                controller: _kController,
                onChange: () {
                  widget.onChange(_constructAndCacheHill());
                },
                formatters: doubleTextInputFormatters,
                labelText: translate(context).kPoint,
                step: 1.0,
                min: 0.0,
                max: context.read<DbEditingDefaultsRepo>().maxKAndHs,
              ),
              gap,
              MyNumeralTextField(
                key: const Key('hs'),
                enabled: widget.enableEditingDimensions,
                controller: _hsController,
                onChange: () {
                  widget.onChange(_constructAndCacheHill());
                },
                formatters: doubleTextInputFormatters,
                labelText: translate(context).hsPoint,
                step: 1.0,
                min: 0.0,
                max: context.read<DbEditingDefaultsRepo>().maxKAndHs,
              ),
              gap,
              MyDropdownField(
                key: const Key('landing'),
                controller: _landingEaseController,
                onChange: (selected) {
                  _landingEase = selected!;
                  widget.onChange(_constructAndCacheHill());
                },
                entries: LandingEase.values.map((ease) {
                  return DropdownMenuEntry(
                      value: ease,
                      label: translatedLandingEaseDescription(context, ease));
                }).toList(),
                width: constraints.maxWidth,
                initial: _landingEase,
                label: Text(translate(context).landing),
              ),
              gap,
              MyDropdownField(
                key: const Key('profile'),
                controller: _profileController,
                onChange: (selected) {
                  _profile = selected!;
                  widget.onChange(_constructAndCacheHill());
                },
                entries: HillProfileType.values.map((type) {
                  return DropdownMenuEntry(
                      value: type,
                      label: translatedHillProfileDescription(context, type));
                }).toList(),
                width: constraints.maxWidth,
                initial: _profile,
                label: Text(translate(context).profile),
              ),
              gap,
              MyDropdownField(
                key: const Key('variability'),
                controller: _jumpsVariabilityController,
                onChange: (selected) {
                  _jumpsVariability = selected!;
                  widget.onChange(_constructAndCacheHill());
                },
                entries: JumpsVariability.values.map((variability) {
                  return DropdownMenuEntry(
                      value: variability,
                      label: translatedJumpsVariabilityDescription(context, variability));
                }).toList(),
                width: constraints.maxWidth,
                initial: _jumpsVariability,
                label: Text(translate(context).jumps),
              ),
              gap,
              MyDropdownField(
                key: const Key('typicalDirection'),
                controller: _typicalWindDirectionController,
                onChange: (selected) {
                  _typicalWindDirection = selected;
                  widget.onChange(_constructAndCacheHill());
                },
                entries: [
                  noneMenuEntry(context),
                  ...TypicalWindDirection.values.map((direction) {
                    return DropdownMenuEntry(
                      value: direction,
                      label: translatedTypicalWindDirectionBriefDescription(
                        context,
                        direction,
                      ),
                      trailingIcon: SizedBox.square(
                          dimension: 25, child: arrowIcon(context, direction.degrees)),
                    );
                  })
                ],
                trailingIcon: shouldShowArrowIcon
                    ? SizedBox.square(
                        dimension: 25,
                        child: arrowIcon(
                            context, _cachedHill!.typicalWindDirection!.degrees),
                      )
                    : null,
                width: constraints.maxWidth,
                initial: _typicalWindDirection,
                label: Text(translate(context).typicalWindDirection),
              ),
              gap,
              MyNumeralTextField(
                key: const Key('typicalStrength'),
                controller: _typicalWindStrengthController,
                onChange: () {
                  widget.onChange(_constructAndCacheHill());
                },
                formatters: doubleTextInputFormatters,
                labelText: translate(context).typicalWindStrength,
                suffixText: 'm/s',
                step: 0.5,
                min: 0.0,
                max: context.read<DbEditingDefaultsRepo>().maxHillTypicalWindStrength,
                maxDecimalPlaces: 2,
              ),
              gap,
              MyNumeralTextField(
                key: const Key('pointsForGate'),
                controller: _pointsForGateController,
                onChange: () {
                  widget.onChange(_constructAndCacheHill());
                },
                formatters: doubleTextInputFormatters,
                labelText: translate(context).pointsForGate,
                suffixText: 'pkt.',
                step: 1.0,
                min: 0.0,
                max: context.read<DbEditingDefaultsRepo>().maxHillPoints,
                maxDecimalPlaces: 2,
              ),
              gap,
              MyNumeralTextField(
                key: const Key('pointsForHeadwind'),
                controller: _pointsForHeadwindController,
                onChange: () {
                  widget.onChange(_constructAndCacheHill());
                },
                formatters: doubleTextInputFormatters,
                labelText: translate(context).pointsForHeadwind,
                suffixText: 'pkt.',
                step: 1.0,
                min: 0.0,
                max: context.read<DbEditingDefaultsRepo>().maxHillPoints,
                maxDecimalPlaces: 2,
              ),
              gap,
              Row(
                children: [
                  Expanded(
                    child: MyNumeralTextField(
                      key: const Key('pointsForTailwind'),
                      controller: _pointsForTailwindController,
                      onChange: () {
                        widget.onChange(_constructAndCacheHill());
                      },
                      buttons: [
                        TextButton(
                          onPressed: () {
                            if (_cachedHill != null) {
                              var autoTailwind = _cachedHill!.pointsForHeadwind *
                                  context
                                      .read<DbEditingDefaultsRepo>()
                                      .autoPointsForTailwindMultiplier;
                              autoTailwind = roundToNDecimalPlaces(autoTailwind, 2);
                              _pointsForTailwindController.text = autoTailwind.toString();

                              widget.onChange(
                                  _cachedHill!.copyWith(pointsForTailwind: autoTailwind));
                            }
                          },
                          child: Text(translate(context).automatically),
                        ),
                      ],
                      formatters: doubleTextInputFormatters,
                      labelText: translate(context).pointsForTailwind,
                      suffixText: 'pkt',
                      step: 1.0,
                      min: 0.0,
                      max: context.read<DbEditingDefaultsRepo>().maxHillPoints,
                      maxDecimalPlaces: 2,
                    ),
                  ),
                ],
              ),
              gap,
            ],
          ),
        ),
      );
    });
  }

  Hill _constructAndCacheHill() {
    final hill = Hill(
      name: _nameController.text,
      locality: _localityController.text,
      country: _country!,
      k: double.tryParse(_kController.text) ?? 0,
      hs: double.tryParse(_hsController.text) ?? 0,
      landingEase: _landingEase,
      profileType: _profile,
      jumpsVariability: _jumpsVariability,
      pointsForGate: double.tryParse(_pointsForGateController.text) ?? 0,
      pointsForHeadwind: double.tryParse(_pointsForHeadwindController.text) ?? 0,
      pointsForTailwind: double.tryParse(_pointsForTailwindController.text) ?? 0,
      typicalWindStrength: double.tryParse(_typicalWindStrengthController.text),
      typicalWindDirection: _typicalWindDirection,
    );
    _cachedHill = hill;
    return hill;
  }

  void setUp(Hill hill) {
    setState(() {
      _cachedHill = hill;
    });
    _fillFields(hill);
    FocusScope.of(context).unfocus();
  }

  void _fillFields(Hill hill) {
    _nameController.text = hill.name;
    _localityController.text = hill.locality;
    _kController.text = hill.k.toString();
    _hsController.text = hill.hs.toString();
    _pointsForGateController.text = hill.pointsForGate.toString();
    _pointsForHeadwindController.text = hill.pointsForHeadwind.toString();
    _pointsForTailwindController.text = hill.pointsForTailwind.toString();
    _typicalWindStrengthController.text = hill.typicalWindStrength?.toString() ?? '';

    _landingEase = hill.landingEase;
    _landingEaseController.text = translatedLandingEaseDescription(context, _landingEase);

    _profile = hill.profileType;
    _profileController.text = translatedHillProfileDescription(context, _profile);

    _jumpsVariability = hill.jumpsVariability;
    _jumpsVariabilityController.text =
        translatedJumpsVariabilityDescription(context, _jumpsVariability);

    _typicalWindDirection = hill.typicalWindDirection;
    _typicalWindDirectionController.text = _typicalWindDirection != null
        ? translatedTypicalWindDirectionBriefDescription(context, _typicalWindDirection!)
        : translate(context).none;

    _country = hill.country;
    _countriesDropdownKey.currentState?.setupManually(_country);
  }
}
