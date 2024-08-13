import 'package:flutter/material.dart';

TextStyle dialogLightFont(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w300,
        );

TextStyle dialogLightItalicFont(BuildContext context) =>
    dialogLightFont(context).copyWith(fontStyle: FontStyle.italic);

TextStyle dialogBoldFont(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
        );
