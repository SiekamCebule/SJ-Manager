import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/domain/repository_interfaces/settings/user_settings_repo.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/theme/app_schemes.dart';

class AppColorSchemeDropdown extends StatelessWidget {
  const AppColorSchemeDropdown({super.key});

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
        MyDropdownField(
          initial: context.read<UserSettingsRepo>().appColorScheme,
          entries: [
            DropdownMenuEntry(value: AppColorScheme.blue, label: translate(context).blue),
            DropdownMenuEntry(
                value: AppColorScheme.yellow, label: translate(context).yellow),
            DropdownMenuEntry(value: AppColorScheme.red, label: translate(context).red),
          ],
          onChange: (scheme) {
            context.read<UserSettingsRepo>().setAppColorScheme(scheme!);
          },
          width: 150,
        ),
      ],
    );
  }
}
