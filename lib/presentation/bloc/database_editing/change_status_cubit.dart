import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeStatusCubit extends Cubit<bool> {
  ChangeStatusCubit() : super(false);

  void markAsChanged() {
    emit(true);
  }
}
