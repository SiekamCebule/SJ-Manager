import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';

class SubteamsSettingUpHelpDialog extends StatelessWidget {
  const SubteamsSettingUpHelpDialog({
    super.key,
    required this.subteamsSetuppingDate,
  });

  final DateTime subteamsSetuppingDate;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM');
    final dateText = dateFormat.format(subteamsSetuppingDate);
    final baseTextStyle = Theme.of(context).textTheme.bodyMedium;
    return AlertDialog(
      title: const Text('Powołania do kadr'),
      content: Text.rich(
        TextSpan(
          text:
              'Przed rozpoczęciem przygotowań do nowego sezonu wybierzesz kadrę skoczków, z którymi będziesz pracować przez najbliższy czas. Będziesz odpowiadać za powołania na zawody. Będziesz nadzorował trening, a także zostaniesz obarczony odpowiedzialnością za ich wyniki.\nW tym sezonie powoływanie do kadr odbywa się dnia: ',
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
