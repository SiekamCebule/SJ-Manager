import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

DropdownMenuEntry<T?> noneDropdownEntry<T>(BuildContext context) =>
    DropdownMenuEntry<T?>(value: null, label: translate(context).none);
