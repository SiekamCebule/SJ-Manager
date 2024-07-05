part of '../database_editor_screen.dart';

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> {
  late final DatabaseEditingCubit _databaseEditingCubit;

  var _closed = false;

  @override
  void initState() {
    _databaseEditingCubit = DatabaseEditingCubit(
      originalMaleJumpersRepo: RepositoryProvider.of<MaleJumpersDatabaseRepo>(context),
      originalFemaleJumpersRepo:
          RepositoryProvider.of<FemaleJumpersDatabaseRepo>(context),
    );
    scheduleMicrotask(() async {
      await _databaseEditingCubit.setUp();
    });
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (!_closed) {
        String? action = await _showSaveChangesDialog();
        final shouldClose = await _shouldCloseAfterDialog(action);
        if (action == 'yes') {
          await _databaseEditingCubit.endEditing();
        }
        if (!_closed && shouldClose) {
          _closed = shouldClose;
        }
        return shouldClose;
      } else {
        return false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _databaseEditingCubit.close();
    super.dispose();
  }

  Future<String?> _showSaveChangesDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Zapisać zmiany?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('yes'),
              child: const Text('Tak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('no'),
              child: const Text('Nie'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _shouldCloseAfterDialog(String? action) async {
    return switch (action) {
      'cancel' => false,
      'no' => true,
      'yes' => true,
      _ => throw StateError('Invalid action ID'),
    };
  }

  @override
  Widget build(BuildContext context) {
    print('[_Large]: build');

    return BlocProvider.value(
      value: _databaseEditingCubit,
      child: Builder(builder: (context) {
        final dbEditingCubit = context.watch<DatabaseEditingCubit>();
        final selectedIndexes = dbEditingCubit.state.selectedIndexes;
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop || _closed) {
              return;
            }
            String? action = await _showSaveChangesDialog();
            bool shouldClose = await _shouldCloseAfterDialog(action);
            if (action == 'yes') {
              await _databaseEditingCubit.endEditing();
            }
            if (shouldClose) {
              _closed = true;
              if (!context.mounted) return;
              router.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Edytor bazy danych'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Zapisz jako'),
                ),
              ],
            ),
            body: Row(
              children: [
                const Gap(10),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Gap(10),
                    AnimatedOpacity(
                      duration: Durations.short3,
                      curve: Curves.easeIn,
                      opacity: selectedIndexes.length <= 1 ? 1 : 0,
                      child: FloatingActionButton(
                        heroTag: 'FABadd',
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        onPressed: () async {
                          final lastIndex =
                              dbEditingCubit.state.itemsForEditing.length - 1;
                          var addIndex =
                              dbEditingCubit.state.selectedIndexes.singleOrNull;
                          bool selectedExists =
                              dbEditingCubit.state.selectedIndexes.length == 1;
                          if (selectedExists) {
                            addIndex = addIndex! + 1;
                          }
                          await dbEditingCubit.addDefaultItem(addIndex);
                          if (selectedExists) {
                            dbEditingCubit.setSelection(addIndex! - 1, false);
                          }
                          dbEditingCubit.setSelection(addIndex ?? lastIndex, true);
                        },
                        tooltip: 'Dodaj',
                        child: const Icon(Symbols.add),
                      ),
                    ),
                    const Gap(10),
                    AnimatedOpacity(
                      duration: Durations.short3,
                      curve: Curves.easeIn,
                      opacity: selectedIndexes.isNotEmpty ? 1 : 0,
                      child: FloatingActionButton(
                        heroTag: 'FABremove',
                        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                        onPressed: () async {
                          final indexes = dbEditingCubit.state.selectedIndexes;
                          var subtraction = 0;
                          for (var removeIndex in indexes) {
                            removeIndex -= subtraction;
                            await dbEditingCubit.removeAt(removeIndex);
                            subtraction += 1;
                          }
                        },
                        tooltip: 'Usuń',
                        child: const Icon(Symbols.remove),
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Center(
                      child: Column(
                        children: [
                          TabBar(
                            tabs: const [
                              Tab(
                                text: 'Zawodnicy',
                                icon: Icon(Symbols.male),
                              ),
                              Tab(
                                text: 'Zawodniczki',
                                icon: Icon(Symbols.female),
                              ),
                              Tab(
                                text: 'Skocznie',
                                icon: ImageIcon(hillIcon),
                              ),
                            ],
                            onTap: (index) {
                              dbEditingCubit
                                  .switchType(DatabaseItemType.fromIndex(index));
                            },
                          ),
                          Expanded(
                            child: BlocSelector<DatabaseEditingCubit,
                                DatabaseEditingState, bool>(
                              selector: (state) {
                                return state.prepared;
                              },
                              builder: (context, prepared) {
                                return prepared
                                    ? const TabBarView(
                                        children: [
                                          _Body(),
                                          _Body(),
                                          _Body(),
                                        ],
                                      )
                                    : const Center(
                                        child: SizedBox.square(
                                            dimension: 150,
                                            child: CircularProgressIndicator()),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
