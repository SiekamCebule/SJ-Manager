import 'package:sj_manager/features/database_editor/data/convert/jumpers_converting.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_model.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

extension GameVariantToModel on GameVariant {
  GameVariantModel toModel() {
    final jumperModels = jumpers.map((jumperEntity) => jumperEntity.toModel()).toList();
    return GameVariantModel(
      id: id,
      jumpers: jumperModels,
      countries: countries,
      countryTeams: countryTeams,
    );
  }
}
