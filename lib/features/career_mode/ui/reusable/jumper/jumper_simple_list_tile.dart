import 'package:flutter/material.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/general_ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/features/career_mode/ui/reusable/jumper/simulation_jumper_image.dart';
import 'package:sj_manager/l10n/jumper_ratings_translations.dart';

class JumperSimpleListTile extends StatelessWidget {
  const JumperSimpleListTile({
    super.key,
    required this.jumper,
    required this.subtitle,
    this.levelDescription,
    this.selected = false,
    this.leading = JumperSimpleListTileLeading.jumperImage,
    this.trailing = JumperSimpleListTileTrailing.none,
    this.onTap,
    this.tileColor,
    this.borderRadius,
  }) : assert(!(subtitle == JumperSimpleListTileSubtitle.levelDescription &&
            levelDescription == null));

  final SimulationJumper jumper;
  final JumperSimpleListTileSubtitle subtitle;
  final JumperLevelDescription? levelDescription;
  final bool selected;
  final JumperSimpleListTileLeading leading;
  final JumperSimpleListTileTrailing trailing;
  final VoidCallback? onTap;
  final Color? tileColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget? subtitleWidget = switch (subtitle) {
      JumperSimpleListTileSubtitle.levelDescription => Text(
          translateJumperLevelDescription(
            context: context,
            levelDescription: levelDescription,
          ),
        ),
      JumperSimpleListTileSubtitle.none => null,
    };
    Widget? leadingWidget = switch (leading) {
      JumperSimpleListTileLeading.countryFlag => CountryFlag(
          country: jumper.country,
          width: 35,
        ),
      JumperSimpleListTileLeading.jumperImage => SimulationJumperImage(
          jumper: jumper,
          width: 30,
        ),
      JumperSimpleListTileLeading.none => null,
    };
    Widget? trailingWidget = switch (trailing) {
      JumperSimpleListTileTrailing.countryFlag => CountryFlag(
          country: jumper.country,
          width: 35,
        ),
      JumperSimpleListTileTrailing.jumperImage => SimulationJumperImage(
          jumper: jumper,
          width: 30,
        ),
      JumperSimpleListTileTrailing.none => null,
    };

    return ListTile(
      title: Text(jumper.nameAndSurname()),
      subtitle: subtitleWidget,
      leading: leadingWidget,
      trailing: trailingWidget,
      selected: selected,
      selectedColor: Theme.of(context).colorScheme.primary,
      titleTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      subtitleTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
      tileColor: tileColor,
      shape: borderRadius != null
          ? RoundedRectangleBorder(
              borderRadius: borderRadius!,
            )
          : null,
    );
  }
}

enum JumperSimpleListTileSubtitle {
  levelDescription,
  none,
}

enum JumperSimpleListTileLeading {
  countryFlag,
  jumperImage,
  none,
}

enum JumperSimpleListTileTrailing {
  countryFlag,
  jumperImage,
  none,
}
