import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextMaybeRead on BuildContext {
  T? maybeRead<T>() {
    try {
      return read<T>();
    } on ProviderNotFoundException {
      return null;
    }
  }
}
