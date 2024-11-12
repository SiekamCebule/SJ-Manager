import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_search_bar.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper/jumper_simple_list_tile.dart';

class SearchForChargesJumpersDialog extends StatefulWidget {
  const SearchForChargesJumpersDialog({
    super.key,
    required this.jumpers,
    required this.onSubmit,
  });

  final List<SimulationJumper> jumpers;
  final Function(SimulationJumper jumper) onSubmit;

  @override
  State<SearchForChargesJumpersDialog> createState() =>
      _SearchForChargesJumpersDialogState();
}

class _SearchForChargesJumpersDialogState extends State<SearchForChargesJumpersDialog> {
  SimulationJumper? _currentJumper;
  late Iterable<SimulationJumper> _filteredJumpers;
  late TextEditingController _searchController;
  late StreamController<String> _searchTextStreamController;
  late StreamSubscription<String> _filterTextSubscription;

  @override
  void initState() {
    _filteredJumpers = widget.jumpers;
    _searchTextStreamController = StreamController();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _searchTextStreamController.add(_searchController.text);
    });
    _filterTextSubscription = _searchTextStreamController.stream
        .debounceTime(const Duration(milliseconds: 100))
        .listen(null);
    _filterTextSubscription.onData((searchData) {
      final filter = Filter<SimulationJumper>(
        shouldPass: (jumper) => DefaultJumperMatchingByTextAlgorithm(
                fullName: jumper.nameAndSurname(), text: searchData)
            .matches(),
      );
      setState(() {
        _filteredJumpers = filter(widget.jumpers);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();

    Future<void> onConfirm() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => _AreYouSureDialog(
          jumper: _currentJumper!,
        ),
      );
      if (ok == true) {
        if (!context.mounted) return;
        Navigator.of(context).pop();
        widget.onSubmit(_currentJumper!);
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      return AlertDialog(
        title: const Text('Nawiąż współpracę'),
        content: Column(
          children: [
            MySearchBar(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              controller: _searchController,
              hintText: 'Wyszukaj skoczków/skoczkinie',
            ),
            const Gap(10),
            SizedBox(
              height: 500,
              width: 650,
              child: ListView.builder(
                itemCount: _filteredJumpers.length,
                itemBuilder: (context, index) {
                  final jumper = _filteredJumpers.elementAt(index);
                  return JumperSimpleListTile(
                    jumper: jumper,
                    onTap: () {
                      setState(() {
                        _currentJumper = jumper;
                      });
                    },
                    selected: _currentJumper == jumper,
                    leading: JumperSimpleListTileLeading.jumperImage,
                    trailing: JumperSimpleListTileTrailing.countryFlag,
                    subtitle: JumperSimpleListTileSubtitle.levelDescription,
                    levelDescription:
                        database.jumperReports[jumper]!.levelReport!.levelDescription,
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: _currentJumper != null ? onConfirm : null,
            child: const Text('Zatwierdź'),
          ),
        ],
      );
    });
  }
}

class _AreYouSureDialog extends StatelessWidget {
  const _AreYouSureDialog({
    required this.jumper,
  });

  final SimulationJumper jumper;

  @override
  Widget build(BuildContext context) {
    final normalTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final boldTextStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600);
    return AlertDialog(
      title: const Text('Nawiązanie współpracy'),
      content: Text.rich(
        TextSpan(
          text: 'Czy chcesz nawiązać współpracę z ',
          style: normalTextStyle,
          children: [
            TextSpan(
              text: jumper.nameAndSurname(),
              style: boldTextStyle,
            ),
            TextSpan(
              text: '? Odpowiadasz za rozwój i wyniki swoich podopiecznych.',
              style: normalTextStyle,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Tak'),
        ),
      ],
    );
  }
}
