import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

DropdownMenuEntry noneMenuEntry(BuildContext context) {
  return DropdownMenuEntry(
    value: null,
    label: translate(context).none,
  );
}
