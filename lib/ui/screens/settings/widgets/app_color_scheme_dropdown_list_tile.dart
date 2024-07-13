import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';
import 'package:sj_manager/ui/theme/app_color_scheme_repo.dart';

class AppColorSchemeDropdownListTile extends StatelessWidget {
  const AppColorSchemeDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: UiSettingsConstants.settingListTileWidth,
          child: ListTile(
            title: Text(
              translate(context).colorScheme,
            ),
            leading: const Icon(Symbols.palette),
          ),
        ),
        DropdownMenu(
          initialSelection: context.watch<AppColorSchemeRepo>().state,
          dropdownMenuEntries: const [
            DropdownMenuEntry(value: AppColorScheme.blue, label: 'Niebieski'),
            DropdownMenuEntry(value: AppColorScheme.yellow, label: 'Żółty'),
            DropdownMenuEntry(value: AppColorScheme.red, label: 'Czerwony'),
          ],
          onSelected: (selected) {
            context.read<AppColorSchemeRepo>().update(selected!);
          },
        ),
      ],
    );
  }
}
