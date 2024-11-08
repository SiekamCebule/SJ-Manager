import 'package:sj_manager/models/user_db/jumper/jumper.dart';

abstract interface class PartialAppointmentsAlgorithm {
  const PartialAppointmentsAlgorithm();

  List<Jumper> chooseBestJumpers({
    required List<Jumper> source,
    required Map<Jumper, double> form,
    required int limit,
  });
}
