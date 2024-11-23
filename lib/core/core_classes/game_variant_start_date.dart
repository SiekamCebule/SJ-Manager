import 'package:sj_manager/core/general_utils/multilingual_string.dart';

class GameVariantStartDate {
  const GameVariantStartDate({
    required this.label,
    required this.date,
  });

  final MultilingualString label;
  final DateTime date;
}
