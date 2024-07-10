import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.onChanged,
  });

  final Function(String changed) onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      leading: const Icon(Symbols.search),
      hintText: 'Wyszukaj...',
      elevation: const WidgetStatePropertyAll(0),
      onChanged: onChanged,
    );
  }
}
