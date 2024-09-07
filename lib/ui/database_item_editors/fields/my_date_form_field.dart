import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_form_field.dart';

class MyDateFormField extends StatelessWidget {
  const MyDateFormField({
    super.key,
    this.formKey,
    required this.controller,
    required this.onChange,
    this.validator,
    required this.dateFormat,
    required this.labelText,
    this.leading,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final Key? formKey;
  final TextEditingController controller;
  final Function(DateTime? date) onChange;
  final String? Function(String? dateString)? validator;
  final DateFormat dateFormat;
  final String labelText;
  final Widget? leading;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    return MyTextFormField(
      textFormFieldKey: formKey,
      controller: controller,
      onChange: () {
        final date = DateTime.tryParse(controller.text);
        onChange(date);
      },
      labelText: labelText,
      validator: validator,
      trailing: IconButton(
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
          );
          onChange(date);
        },
        icon: const Icon(Symbols.calendar_today),
      ),
      leading: leading,
    );
  }
}
