import 'package:flutter/material.dart';
import 'package:sj_manager/data/models/simulation/jumper/reports/jumper_level_description.dart';
import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/utils/jumper_ratings_translations.dart';

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
