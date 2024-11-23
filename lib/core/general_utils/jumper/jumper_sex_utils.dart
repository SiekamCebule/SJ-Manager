import 'package:sj_manager/core/mixins/sex_mixin.dart';
import 'package:sj_manager/core/core_classes/sex.dart';

bool jumperIsMale(SexMixin jumper) => jumper.sex == Sex.male;
bool jumperIsFemale(SexMixin jumper) => jumper.sex == Sex.female;
