import 'package:rxdart/rxdart.dart';

class LinearNavigationPermissionsRepo {
  LinearNavigationPermissionsRepo(
      {bool initialForward = true, bool initialBack = true})
      : _canGoForward = initialForward,
        _canGoBack = initialBack {
    _forwardNavSubject.add(_canGoForward);
    _backNavSubject.add(_canGoBack);
  }

  final _forwardNavSubject = BehaviorSubject<bool>();
  final _backNavSubject = BehaviorSubject<bool>();

  bool _canGoForward;
  bool _canGoBack;

  bool get canGoForward => _canGoForward;
  bool get canGoBack => _canGoBack;

  ValueStream<bool> get canGoForwardStream => _forwardNavSubject.stream;
  ValueStream<bool> get canGoBackStream => _backNavSubject.stream;

  set canGoForward(bool other) {
    _canGoForward = other;
    _forwardNavSubject.add(_canGoForward);
  }

  set canGoBack(bool other) {
    _canGoBack = other;
    _backNavSubject.add(_canGoBack);
  }

  void entirelyBlock() {
    canGoForward = false;
    canGoBack = false;
  }

  void entirelyAllow() {
    canGoForward = true;
    canGoBack = true;
  }
}
