import 'package:sj_manager/models/user_db/jumper/jumper.dart';

abstract interface class PartialAppointmentsAlgorithm {
  const PartialAppointmentsAlgorithm();

  Iterable<Jumper> chooseBestJumpers({
    required Iterable<Jumper> source,
    required Map<Jumper, double> form,
    required int limit,
  });
}
