import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/app_settings/presentation/bloc/app_settings_cubit.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/to_embrace/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/general_ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

class AppColorSchemeDropdown extends StatelessWidget {
  const AppColorSchemeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = (context.watch<AppSettingsCubit>().state as AppSettingsInitialized);

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
          initial: settings.colorScheme,
          entries: [
            DropdownMenuEntry(value: AppColorScheme.blue, label: translate(context).blue),
            DropdownMenuEntry(
                value: AppColorScheme.yellow, label: translate(context).yellow),
            DropdownMenuEntry(value: AppColorScheme.red, label: translate(context).red),
          ],
          onChange: (scheme) async {
            await context.read<AppSettingsCubit>().setColorScheme(scheme!);
          },
          width: 150,
        ),
      ],
    );
  }
}
