import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';

void main() {
  late SelectedIndexesRepository repo;
  group(SelectedIndexesRepository, () {
    setUp(() {
      repo = SelectedIndexesRepository();
    });
    test('setSelection', () async {
      repo.setSelection(2, true);
      repo.setSelection(4, true);
      repo.setSelection(4, false);
      expect(repo.state, {2});
      repo.setSelection(5, true);
      expect(repo.state, {2, 5});
    });
    test('selectOnlyAt', () async {
      for (var i = 0; i < 3; i++) {
        repo.setSelection(i, true);
      }
      repo.selectOnlyAt(3);
      expect(repo.state, {3});
      repo.selectOnlyAt(1);
      expect(repo.state, {1});
    });
    test('toggleSelection', () {
      for (var i = 0; i < 3; i++) {
        repo.setSelection(i, true);
      }
      repo.toggleSelection(0);
      repo.toggleSelection(0);
      repo.toggleSelection(1);
      expect(repo.state, {0, 2});
    });
    test('moveSelection', () {
      for (var i = 0; i < 3; i++) {
        repo.setSelection(i, true);
      }
      repo.moveSelection(from: 0, to: 5);
      repo.moveSelection(from: 4, to: 7);
      repo.moveSelection(from: 2, to: 1);
      expect(repo.state, {1, 2, 5});
    });

    tearDown(() {
      repo.close();
    });
  });
}
