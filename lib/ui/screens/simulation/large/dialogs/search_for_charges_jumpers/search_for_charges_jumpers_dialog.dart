import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';
import 'package:sj_manager/ui/screens/simulation/utils/jumper_ratings_translations.dart';

part '__list_tile.dart';

class SearchForChargesJumpersDialog extends StatefulWidget {
  const SearchForChargesJumpersDialog({
    super.key,
    required this.jumpers,
    required this.onSubmit,
  });

  final List<Jumper> jumpers;
  final Function(Jumper jumper) onSubmit;

  @override
  State<SearchForChargesJumpersDialog> createState() =>
      _SearchForChargesJumpersDialogState();
}

class _SearchForChargesJumpersDialogState extends State<SearchForChargesJumpersDialog> {
  Jumper? _currentJumper;
  late List<Jumper> _filteredJumpers;
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
      final filter = JumpersFilterBySearch(
          searchAlgorithm: DefaultJumperMatchingByTextAlgorithm(text: searchData));
      setState(() {
        _filteredJumpers = filter(widget.jumpers);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;

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
            SearchBar(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.surfaceContainerLow,
              ),
              overlayColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.surfaceContainerLowest;
                } else {
                  return Colors.transparent;
                }
              }),
              controller: _searchController,
              autoFocus: true,
              hintText: 'Wyszukaj skoczków/skoczkinie',
              elevation: const WidgetStatePropertyAll(0),
            ),
            const Gap(10),
            SizedBox(
              height: 500,
              width: 650,
              child: ListView.builder(
                itemCount: _filteredJumpers.length,
                itemBuilder: (context, index) {
                  final jumper = _filteredJumpers[index];
                  return _ListTile(
                    jumper: jumper,
                    levelReport: database.jumpersReports[jumper]!.levelReport,
                    selected: _currentJumper == jumper,
                    onTap: () {
                      setState(() {
                        _currentJumper = jumper;
                      });
                    },
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

  final Jumper jumper;

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
