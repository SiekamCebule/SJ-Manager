import 'package:flutter/material.dart';
import 'package:sj_manager/utilities/utils/close_app.dart';
import 'package:sj_manager/utilities/utils/fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SjmErrorDialog extends StatelessWidget {
  const SjmErrorDialog({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final errorText =
        'Rodzaj błędu: ${error.runtimeType.toString()}\n${error.toString()}';

    return AlertDialog(
      title: const Text('Wystąpił błąd'),
      content: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            style: dialogLightFont(context),
            children: [
              const TextSpan(
                text:
                    'Przepraszamy, ale nie wiemy co się stało. Prosimy o zgłoszenie nam tego błędu\n',
              ),
              if (stackTrace != null)
                TextSpan(
                  text: '$errorText\n${stackTrace.toString()}',
                  style: dialogLightItalicFont(context),
                ),
              if (stackTrace == null)
                TextSpan(
                  text: 'Ślad stosu nie jest dostępny dla tego błędu',
                  style: dialogLightItalicFont(context),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await closeApp();
          },
          child: const Text('Zamknij aplikację'),
        ),
        TextButton(
          onPressed: () async {
            await launchUrlString(
                'https://github.com/SiekamCebule/sj-manager/issues/new');
          },
          child: const Text('Zgłoś błąd (GitHub)'),
        ),
      ],
    );
  }
}
