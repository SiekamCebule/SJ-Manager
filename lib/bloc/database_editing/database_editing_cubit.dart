import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/extensions/set_toggle.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/models/jumper_skills.dart';
import 'package:sj_manager/models/sex.dart';
import 'package:sj_manager/repositories/database_items/database_items_api.dart';

part 'database_editing_state.dart';

class DatabaseEditingCubit extends Cubit<DatabaseEditingState> {
  DatabaseEditingCubit({
    required this.originalMaleJumpersRepo,
    required this.originalFemaleJumpersRepo,
  }) : super(initialState);

  final DatabaseItemsApi<Jumper> originalMaleJumpersRepo;
  final DatabaseItemsApi<Jumper> originalFemaleJumpersRepo;

  late final DatabaseItemsApi<Jumper> _editableMaleJumpersRepo;
  late final DatabaseItemsApi<Jumper> _editableFemaleJumpersRepo;

  Future<void> setUp() async {
    _editableMaleJumpersRepo = await originalMaleJumpersRepo.clone();
    _editableFemaleJumpersRepo = await originalFemaleJumpersRepo.clone();

    emit(DatabaseEditingState(
      prepared: true,
      itemsForEditing: newRepoItems(),
      selectedIndexes: state.selectedIndexes,
      itemsType: state.itemsType,
    ));
  }

  Future<void> endEditing() async {
    await originalMaleJumpersRepo.loadRaw(_editableMaleJumpersRepo.items);
    await originalMaleJumpersRepo.saveToSource();

    await originalFemaleJumpersRepo.loadRaw(_editableFemaleJumpersRepo.items);
    await originalFemaleJumpersRepo.saveToSource();
  }

  void switchType(DatabaseItemType type) {
    emit(
      DatabaseEditingState(
        prepared: state.prepared,
        itemsForEditing: _repoByType(type).items,
        selectedIndexes: const {},
        itemsType: type,
      ),
    );
  }

  DatabaseItemsApi _repoByType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper => _editableMaleJumpersRepo,
      DatabaseItemType.femaleJumper => _editableFemaleJumpersRepo,
    };
  }

  void toggleOnly(int index) {
    var selectedIndexes = <int>{};
    if (state.selectedIndexes.contains(index)) {
      selectedIndexes = {};
    } else {
      selectedIndexes = {index};
    }

    emit(DatabaseEditingState(
      prepared: state.prepared,
      itemsForEditing: state.itemsForEditing,
      selectedIndexes: selectedIndexes,
      itemsType: state.itemsType,
    ));
  }

  void setSelection(int index, bool selection) {
    final newSelectedIndexes = Set.of(state.selectedIndexes);

    if (selection == true) {
      newSelectedIndexes.add(index);
    } else {
      newSelectedIndexes.remove(index);
    }

    emit(DatabaseEditingState(
      prepared: state.prepared,
      itemsForEditing: state.itemsForEditing,
      selectedIndexes: newSelectedIndexes,
      itemsType: state.itemsType,
    ));
  }

  void toggleSelection(int index) {
    final newSelectedIndexes = Set.of(state.selectedIndexes);
    newSelectedIndexes.toggle(index);

    emit(DatabaseEditingState(
      prepared: state.prepared,
      itemsForEditing: state.itemsForEditing,
      selectedIndexes: newSelectedIndexes,
      itemsType: state.itemsType,
    ));
  }

  Future<void> move({required int from, required int to}) async {
    final newSelectedIndexes = Set<int>.from(state.selectedIndexes);
    if (newSelectedIndexes.contains(from)) {
      newSelectedIndexes.remove(from);
      newSelectedIndexes.add(to);
    }
    await _repoByType(state.itemsType).move(from: from, to: to);
    emit(
      DatabaseEditingState(
        prepared: state.prepared,
        itemsForEditing: newRepoItems(),
        selectedIndexes: newSelectedIndexes,
        itemsType: state.itemsType,
      ),
    );
  }

  Future<void> addDefaultItem([int? index]) async {
    await _repoByType(state.itemsType).save(
      _defaultItemByType(state.itemsType),
      index,
    );

    emit(DatabaseEditingState(
      prepared: state.prepared,
      itemsForEditing: newRepoItems(),
      selectedIndexes: state.selectedIndexes,
      itemsType: state.itemsType,
    ));
  }

  dynamic _defaultItemByType(DatabaseItemType type) {
    return switch (type) {
      DatabaseItemType.maleJumper || DatabaseItemType.femaleJumper => const Jumper(
          name: '',
          surname: '',
          country: null,
          sex: Sex.male,
          age: 10,
          skills: JumperSkills(
            qualityOnSmallerHills: 0,
            qualityOnLargerHills: 0,
            landingStyle: LandingStyle.average,
            jumpsConsistency: JumpsConsistency.average,
          ),
        )
    };
  }

  Future<void> removeAt(int index) async {
    final newSelectedIndexes = Set<int>.from(state.selectedIndexes);
    if (newSelectedIndexes.contains(index)) {
      newSelectedIndexes.remove(index);
    }
    await _repoByType(state.itemsType).removeAt(index);
    emit(
      DatabaseEditingState(
        prepared: state.prepared,
        itemsForEditing: newRepoItems(),
        selectedIndexes: newSelectedIndexes,
        itemsType: state.itemsType,
      ),
    );
  }

  Future<void> update(int index, dynamic item) async {
    try {
      await _repoByType(state.itemsType).replace(oldIndex: index, newItem: item);
    } on TypeError {
      throw Exception(
        'The item type (${item.runtimeType}) does not conform to the actual bloc\'s items type ${state.itemsType}',
      );
    }
    final newSelectedIndexes = Set<int>.from(state.selectedIndexes);
    //newSelectedIndexes.remove(index);
    emit(DatabaseEditingState(
      prepared: state.prepared,
      itemsForEditing: newRepoItems(),
      selectedIndexes: newSelectedIndexes,
      itemsType: state.itemsType,
    ));
  }

  static DatabaseEditingState get initialState {
    return const DatabaseEditingState(
      prepared: false,
      itemsForEditing: [],
      selectedIndexes: {},
      itemsType: DatabaseItemType.maleJumper,
    );
  }

  Iterable<dynamic> newRepoItems() {
    return List.of(_repoByType(state.itemsType).items);
  }
}
