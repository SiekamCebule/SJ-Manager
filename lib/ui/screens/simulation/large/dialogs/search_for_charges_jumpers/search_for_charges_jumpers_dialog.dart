import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';
import 'package:sj_manager/ui/screens/simulation/utils/ratings_displaying.dart';

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

  @override
  void initState() {
    _filteredJumpers = widget.jumpers;
    _searchController = TextEditingController();
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
              controller: _searchController,
              autoFocus: true,
              hintText: 'Wyszukaj skoczków/skoczkinie',
              elevation: const WidgetStatePropertyAll(5),
            ),
            SizedBox(
              height: 500,
              width: 650,
              child: ListView.builder(
                itemCount: widget.jumpers.length,
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
