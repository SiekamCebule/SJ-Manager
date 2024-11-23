import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/app_settings/presentation/bloc/app_settings_cubit.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/to_embrace/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/general_ui/responsiveness/ui_constants.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = (context.watch<AppSettingsCubit>().state as AppSettingsInitialized);

    return Row(
      children: [
        SizedBox(
          width: UiSettingsConstants.settingListTileWidth,
          child: ListTile(
            title: Text(
              translate(context).language,
            ),
            leading: const Icon(Symbols.language),
          ),
        ),
        MyDropdownField(
          initial: settings.languageCode,
          entries: [
            DropdownMenuEntry(value: 'pl', label: translate(context).polish),
            DropdownMenuEntry(value: 'en', label: translate(context).english),
            DropdownMenuEntry(value: 'cs', label: translate(context).czech),
          ],
          onChange: (selected) async {
            await context.read<AppSettingsCubit>().setLanguageCode(selected!);
          },
          width: 150,
        ),
      ],
    );
  }
}
