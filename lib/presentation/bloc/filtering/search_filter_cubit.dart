import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit({
    this.debounceTime = const Duration(milliseconds: 100),
  }) : super(const SearchFilterState(text: ''));

  Duration? debounceTime;
  Timer? _debounce;

  void setText(String text) {
    _debounce?.cancel();

    if (debounceTime != null) {
      _debounce = Timer(debounceTime!, () {
        emit(SearchFilterState(text: text));
      });
    } else {
      emit(SearchFilterState(text: text));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

class SearchFilterState {
  const SearchFilterState({
    required this.text,
  });

  final String text;
}
