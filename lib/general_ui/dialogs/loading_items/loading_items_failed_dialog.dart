import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sj_manager/core/errors/country_not_found_error.dart';
import 'package:sj_manager/core/exceptions/json_exceptions.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/core/general_utils/close_app.dart';
import 'package:sj_manager/core/general_utils/fonts.dart';

class LoadingItemsFailedDialog extends StatelessWidget {
  const LoadingItemsFailedDialog({
    super.key,
    required this.titleText,
    required this.filePath,
    required this.error,
    required this.stackTrace,
  });

  final String titleText;
  final String? filePath;
  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    final errorText = switch (error) {
      CountryByCodeNotFoundError(countryCode: var countryCode) =>
        '${translate(context).countryNotFound}: $countryCode',
      JsonIsEmptyException() => translate(context).jsonIsEmptyExceptionContent,
      FormatException() => translate(context).invalidJsonFormatExceptionContent,
      PathNotFoundException(path: final path, osError: final osError) =>
        '${translate(context).pathNotFoundWhenLoadingDatabase}: $path (${translate(context).osError}: $osError)',
      _ => '${translate(context).unknownError}\n${error.toString()}',
    };
    return AlertDialog(
      title: Text(titleText),
      content: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            style: dialogLightFont(context),
            children: [
              if (filePath != null) ...[
                TextSpan(text: 'Jeśli edytowałeś plik ', style: dialogLightFont(context)),
                TextSpan(text: filePath, style: dialogBoldFont(context)),
                TextSpan(
                    text: ', sprawdź jego poprawność.\n\n',
                    style: dialogLightFont(context)),
              ],
              TextSpan(
                text: '$errorText\n${stackTrace.toString()}',
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
      ],
    );
  }
}
