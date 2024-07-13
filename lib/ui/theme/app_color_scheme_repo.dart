import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

class AppColorSchemeRepo {
  final _subject = BehaviorSubject.seeded(UiGlobalConstants.defaultAppColorScheme);

  void update(AppColorScheme scheme) {
    _subject.add(scheme);
  }

  void dispose() => _subject.close();

  AppColorScheme get state => values.value;
  ValueStream<AppColorScheme> get values => _subject.stream;
}
