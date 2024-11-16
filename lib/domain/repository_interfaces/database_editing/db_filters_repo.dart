import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/utilities/filters/filter.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';

class DbFiltersRepo with EquatableMixin, ChangeNotifier {
  DbFiltersRepo({
    this.maleJumpersSearchFilter,
    this.maleJumpersCountryFilter,
    this.femaleJumpersSearchFilter,
    this.femaleJumpersCountryFilter,
  }) {
    _changesController = StreamController();
    addListener(() {
      _changesController.add(null);
    });
  }

  late final StreamController _changesController;

  Filter<JumperDbRecord>? maleJumpersSearchFilter;
  Filter<JumperDbRecord>? maleJumpersCountryFilter;
  Filter<JumperDbRecord>? femaleJumpersSearchFilter;
  Filter<JumperDbRecord>? femaleJumpersCountryFilter;

  void clear() {
    maleJumpersSearchFilter = null;
    maleJumpersCountryFilter = null;
    femaleJumpersSearchFilter = null;
    femaleJumpersCountryFilter = null;
    notify();
  }

  List<Filter?> filtersByType(Type type) {
    if (type == MaleJumperDbRecord) {
      return [maleJumpersSearchFilter, maleJumpersSearchFilter];
    } else if (type == FemaleJumperDbRecord) {
      return [femaleJumpersSearchFilter, femaleJumpersCountryFilter];
    } else {
      throw TypeError();
    }
  }

  void notify() => notifyListeners();

  Stream<void> get changesStream => _changesController.stream;

  @override
  List<Object?> get props => [
        maleJumpersSearchFilter,
        maleJumpersCountryFilter,
        femaleJumpersSearchFilter,
        femaleJumpersCountryFilter,
      ];

  @override
  void dispose() {
    _changesController.close();
    super.dispose();
  }
}
