import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/presentation/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/presentation/ui/providers/locale_cubit.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
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
          initial: context.read<LocaleCubit>().languageCode,
          entries: [
            DropdownMenuEntry(value: 'pl', label: translate(context).polish),
            DropdownMenuEntry(value: 'en', label: translate(context).english),
            DropdownMenuEntry(value: 'cs', label: translate(context).czech),
          ],
          onChange: (selected) async {
            await context.read<LocaleCubit>().update(Locale(selected!));
          },
          width: 150,
        ),
      ],
    );
  }
}
