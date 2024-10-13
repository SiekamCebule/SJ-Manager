import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';

class TrainingsAreNotSetUpDialog extends StatelessWidget {
  const TrainingsAreNotSetUpDialog({
    super.key,
    required this.trainingsStartDate,
  });

  final DateTime trainingsStartDate;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final dateFormat = DateFormat('d MMM');
    final dateText = dateFormat.format(trainingsStartDate);

    return AlertDialog(
      title: const Text('Treningi jeszcze nie wystartowały'),
      content: Text.rich(
        TextSpan(
          text:
              'Za niedługo zostaniesz poproszony o wstępne ustalenie treningu dla swoich podopiecznych.\nTermin rozpoczęcia treningów: ',
          style: baseTextStyle,
          children: [
            TextSpan(
              text: dateText,
              style: baseTextStyle.copyWith(fontWeight: FontWeight.w500),
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
