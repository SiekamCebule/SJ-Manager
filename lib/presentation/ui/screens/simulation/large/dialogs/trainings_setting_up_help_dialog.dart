import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';

class TrainingsSettingUpHelpDialog extends StatelessWidget {
  const TrainingsSettingUpHelpDialog({
    super.key,
    required this.trainingsStartDate,
  });

  final DateTime trainingsStartDate;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM');
    final dateText = dateFormat.format(trainingsStartDate);
    final baseTextStyle = Theme.of(context).textTheme.bodyMedium;
    return AlertDialog(
      title: const Text('Rozpoczęcie treningów'),
      content: Text.rich(
        TextSpan(
          text:
              'W określonym dniu rozpoczną się przygotowania do następnego sezonu. Będziesz odpowiadać za indywidualny trening każdego z twoich podopiecznych. Właśnie od tego zależy twój sukces!\nW tym sezonie treningi zaczynają się dnia: ',
          style: baseTextStyle,
          children: [
            TextSpan(
              text: dateText,
              style: baseTextStyle!.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      actions: const [
        SjmDialogOkPopButton(),
      ],
    );
  }
}
