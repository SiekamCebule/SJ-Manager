import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_form_field.dart';

class MyDateFormField extends StatefulWidget {
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
  State<MyDateFormField> createState() => _MyDateFormFieldState();
}

class _MyDateFormFieldState extends State<MyDateFormField> {
  DateTime? _lastValidDate;

  @override
  void initState() {
    _lastValidDate = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyTextFormField(
      textFormFieldKey: widget.formKey,
      controller: widget.controller,
      onChange: () {
        print('current text: ${widget.controller.text}');
        final date = widget.dateFormat.tryParse(widget.controller.text);
        if (date != null) {
          _lastValidDate = date;
          widget.onChange(date);
        } else {
          if (_lastValidDate == null) {
            throw StateError(
              '(MyDateFormField): Both last valid date and changed date are null',
            );
          }
          widget.controller.text = widget.dateFormat.format(_lastValidDate!);
          widget.onChange(_lastValidDate!);
        }
      },
      labelText: widget.labelText,
      validator: widget.validator,
      trailing: IconButton(
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          );
          widget.onChange(date);
        },
        icon: const Icon(Symbols.calendar_today),
      ),
      leading: widget.leading,
    );
  }
}
