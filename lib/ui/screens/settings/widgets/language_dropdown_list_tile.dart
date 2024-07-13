import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/providers/locale_notifier.dart';

class LanguageDropdownListTile extends StatelessWidget {
  const LanguageDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: ListTile(
            title: Text(
              translate(context).language,
            ),
            leading: const Icon(Symbols.language),
          ),
        ),
        DropdownMenu(
          initialSelection: context.read<LocaleCubit>().languageCode,
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 'pl', label: translate(context).polish),
            DropdownMenuEntry(value: 'en', label: translate(context).english),
            DropdownMenuEntry(value: 'de', label: translate(context).german),
            DropdownMenuEntry(value: 'fr', label: translate(context).french),
          ],
          onSelected: (selected) {
            context.read<LocaleCubit>().update(Locale(selected!));
          },
        ),
      ],
    );
  }
}
