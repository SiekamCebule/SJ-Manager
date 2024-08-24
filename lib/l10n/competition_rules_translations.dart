import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';

String translatedEntitiesLimitType(BuildContext context, EntitiesLimit? limit) {
  if (limit == null) {
    return translate(context).withoutLimit;
  } else {
    return switch (limit.type) {
      EntitiesLimitType.soft => translate(context).soft,
      EntitiesLimitType.exact => translate(context).exact,
    };
  }
}
