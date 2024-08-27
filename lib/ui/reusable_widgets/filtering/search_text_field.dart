import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Function(String changed) onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      leading: const Icon(Symbols.search),
      hintText: translate(context).searchDot3,
      elevation: const WidgetStatePropertyAll(0),
      onChanged: onChanged,
    );
  }
}
