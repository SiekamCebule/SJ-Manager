import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/local_db_loader_from_directory.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class ItemsReposRegistry extends ItemsRepo<ItemsRepo> with EquatableMixin {
  ItemsReposRegistry({
    Set<ItemsRepo> initial = const {},
  }) {
    set(Set.of(initial));
  }

  ItemsReposRegistry clone() {
    return ItemsReposRegistry(initial: Set.of(_repos));
  }

  late Set<ItemsRepo> _repos;

  @override
  void set(Iterable<ItemsRepo> value) {
    _repos = value.toSet();
    super.set(_repos);
  }

  void register(ItemsRepo repo) {
    _repos.add(repo);
    set(_repos);
  }

  void removeByType<T>() {
    if (_repos.whereType<T>().isEmpty) {
      throw StateError(
        'ItemsReposRegistry does not contain any repo with type ItemsRepo<$T>, so cannot remove it',
      );
    }
    _repos.removeWhere((repo) => repo is ItemsRepo<T>);
  }

  ItemsRepo<T> get<T>() {
    return byTypeArgument(T) as ItemsRepo<T>;
  }

  EditableItemsRepo getEditable(Type type) {
    return byTypeArgument(type) as EditableItemsRepo;
  }

  ItemsRepo byTypeArgument(Type type) {
    try {
      return _repos.singleWhere((repo) {
        return repo.itemsType == type;
      });
    } catch (e) {
      throw _repoWithTypeDoesNotExist(type);
    }
  }

  static Future<ItemsReposRegistry> fromDirectory(Directory directory,
      {required BuildContext context}) async {
    return LocalDbLoaderFromDirectory(directory: directory).load(context: context);
  }

  static _repoWithTypeDoesNotExist(Type type) => StateError(
      'An ItemsRepo with items of that type ($type) does not exist in the registry');

  @override
  List<Object?> get props => [_repos];

  @override
  void dispose() {
    for (var repo in _repos) {
      repo.dispose();
    }
  }
}
