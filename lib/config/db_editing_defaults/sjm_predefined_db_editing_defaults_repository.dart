import 'package:sj_manager/config/db_editing_defaults/game_variant_editing_defaults_repository.dart';

class SjmPredefinedDbEditingDefaultsRepository
    implements GameVariantEditingDefaultsRepository {
  @override
  double get maxJumperQualitySkill => 20;
}
