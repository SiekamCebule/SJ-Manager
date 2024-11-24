import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/subteam_type.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/ui/screens/simulation/utils/jumper_ratings_translations.dart';

class SubteamsSettingUpPersonalCoachDialog extends StatelessWidget {
  const SubteamsSettingUpPersonalCoachDialog({
    super.key,
    required this.jumpers,
    required this.subteamType,
  });

  final List<Jumper> jumpers;
  final Map<Jumper, SubteamType> subteamType;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AlertDialog(
        title: const Text('Przydzielono zawodników do kadr'),
        content: SizedBox(
          height: constraints.maxHeight,
          width: 500,
          child: Column(
            children: [
              const Gap(10),
              Expanded(
                child: ListView(
                  children: [
                    for (final jumper in jumpers) ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: JumperSimpleListTile(
                              jumper: jumper,
                              subtitle: JumperSimpleListTileSubtitle.none,
                              leading: JumperSimpleListTileLeading.jumperImage,
                            ),
                          ),
                          const Gap(75),
                          Text(
                            translateJumperSubteamType(
                              context: context,
                              subteamType: subteamType[jumper]!,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Gap(10),
                          CountryFlag(
                            country: jumper.country,
                            height: 18,
                          ),
                        ],
                      ),
                      const Gap(10),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: const [
          SjmDialogOkPopButton(),
        ],
      );
    });
  }
}
