import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';

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
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 'pl', label: translate(context).polish),
            DropdownMenuEntry(value: 'en', label: translate(context).english),
            DropdownMenuEntry(value: 'de', label: translate(context).german),
            DropdownMenuEntry(value: 'fr', label: translate(context).french),
          ],
        ),
      ],
    );
  }
}
