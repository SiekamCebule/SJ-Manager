import 'package:sj_manager/core/utils/jumper/jumper_sex_utils.dart';
import 'package:sj_manager/features/database_editor/data/data_sources/items_from_game_variant/items_from_game_variant_data_source.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

class MaleJumpersFromGameVariantDataSource
    implements ItemsFromGameVariantDataSource<MaleJumperDbRecord> {
  const MaleJumpersFromGameVariantDataSource({
    required this.gameVariant,
    required this.saveVariant,
  });

  final GameVariant gameVariant;
  final Future<void> Function(GameVariant variant) saveVariant;

  @override
  Future<Iterable<MaleJumperDbRecord>> loadAll() async {
    return gameVariant.jumpers.where(jumperIsMale).cast();
  }

  @override
  Future<void> saveAll() async {
    await saveVariant(gameVariant);
  }
}
