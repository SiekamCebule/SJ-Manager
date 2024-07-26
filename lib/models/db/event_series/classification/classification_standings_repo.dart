import 'package:sj_manager/models/db/event_series/classification/classification_result.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class ClassificationStandingsRepo<T> extends ItemsRepo<ClassificationResult<T>> {
  List<ClassificationResult<T>> _updatedRanking(List<ClassificationResult<T>> standings) {
    final items = standings.toList();
    items.sort((first, second) {
      return second.score.compareTo(first.score);
    });
    return items;
  }

  void update({required ClassificationResult<T> newResult}) {
    var list = List.of(last);
    list = list.map((result) {
      if (result.entity == newResult.entity) {
        return newResult;
      } else {
        return result;
      }
    }).toList();
    set(_updatedRanking(list));
  }

  void addToScore({required T entity, required double addition}) {
    if (!containsEntity(entity)) {
      throw StateError(
          'Classification standings does not contain the $entity entity, so cannot add $addition to its score');
    }
    update(
      newResult: ClassificationResult(
        entity: entity,
        score: resultOf(entity)!.score + addition,
      ),
    );
  }

  bool containsEntity(T entity) =>
      last.where((result) => result.entity == entity).isNotEmpty;

  int get length => last.length;

  ClassificationResult<T>? resultOf(T entity) {
    final whereEntityMatches = last.where((result) => result.entity == entity);
    if (whereEntityMatches.length > 1) {
      throw StateError(
        '$entity entity has more than one result in the classification standings',
      );
    }
    return whereEntityMatches.singleOrNull;
  }

  ClassificationResult<T>? atPosition(int position) {
    return last[position];
  }

  int positionOf(T entity) {
    if (!containsEntity(entity)) {
      throw StateError(
        'Standings does not have any $entity\'s result, so cannot get its position',
      );
    }
    return last.indexOf(resultOf(entity)!) + 1;
  }
}
