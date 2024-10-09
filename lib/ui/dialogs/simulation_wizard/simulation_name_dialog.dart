import 'package:flutter/material.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_text_form_field.dart';

class SimulationNameDialog extends StatefulWidget {
  const SimulationNameDialog({super.key});

  @override
  State<SimulationNameDialog> createState() => _SimulationNameDialogState();
}

class _SimulationNameDialogState extends State<SimulationNameDialog> {
  late final TextEditingController _controller;
  final _nameFormFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nazwij swoją symulację'),
      content: MyTextFormField(
        textFormFieldKey: _nameFormFieldKey,
        controller: _controller,
        onChange: () {},
        labelText: 'Nazwa symulacji',
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Nazwa symulacji nie powinna być pusta';
          } else if (text == 'Kocham SJ Managera') {
            return 'Bardzo się cieszymy :)';
          } else {
            return null;
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_nameFormFieldKey.currentState!.validate()) {
              router.pop(context, _controller.text);
            }
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
