import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

class AppThemeBrigthnessDropdown extends StatelessWidget {
  const AppThemeBrigthnessDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: UiSettingsConstants.settingListTileWidth,
          child: ListTile(
            title: Text(
              translate(context).themeBrightness,
            ),
            leading: const Icon(Symbols.contrast),
          ),
        ),
        MyDropdownField(
          initial: context.read<UserSettingsRepo>().appThemeBrightness,
          entries: [
            DropdownMenuEntry(
                value: Brightness.dark, label: translate(context).darkTheme),
            DropdownMenuEntry(
                value: Brightness.light, label: translate(context).lightTheme),
          ],
          onChange: (selected) async {
            context.read<UserSettingsRepo>().setAppThemeBrightness(selected!);
          },
          width: 150,
        ),
      ],
    );
  }
}
