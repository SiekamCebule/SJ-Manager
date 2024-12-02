import 'package:sj_manager/to_embrace/competition/rules/ko/ko_group.dart';

abstract interface class KoGroupsCreator<T> {
  List<KoGroup<T>> create(dynamic context);
}
