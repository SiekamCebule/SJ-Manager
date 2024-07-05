part of 'database_editing_cubit.dart';

class DatabaseEditingState extends Equatable {
  const DatabaseEditingState({
    required this.prepared,
    required this.itemsForEditing,
    required this.selectedIndexes,
    required this.itemsType,
  });

  final bool prepared;
  final Iterable<dynamic> itemsForEditing;
  final Set<int> selectedIndexes;
  final DatabaseItemType itemsType;

  @override
  List<Object> get props => [
        prepared,
        itemsForEditing,
        selectedIndexes,
        itemsType,
      ];
}
