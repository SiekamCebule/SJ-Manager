import 'package:flutter_bloc/flutter_bloc.dart';

class LocalDbIsChangedCubit extends Cubit<bool> {
  LocalDbIsChangedCubit() : super(false);

  void markAsChanged() {
    emit(true);
  }
}
