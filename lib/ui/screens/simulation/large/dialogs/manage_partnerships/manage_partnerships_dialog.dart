import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';
import 'package:sj_manager/ui/screens/simulation/utils/jumper_ratings_translations.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class ManagePartnershipsDialog extends StatefulWidget {
  const ManagePartnershipsDialog({
    super.key,
    required this.jumpers,
    required this.onSubmit,
  });

  final List<SimulationJumper> jumpers;
  final Function(ManagePartnershipsDialogResult result) onSubmit;

  @override
  State<ManagePartnershipsDialog> createState() => _ManagePartnershipsDialogState();
}

class _ManagePartnershipsDialogState extends State<ManagePartnershipsDialog> {
  late final List<SimulationJumper> _orderedJumpers;
  late final Map<SimulationJumper, bool> _shouldBeRemoved;

  @override
  void initState() {
    _orderedJumpers = List.of(widget.jumpers);
    _shouldBeRemoved = {
      for (final jumper in widget.jumpers) jumper: false,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();

    return LayoutBuilder(
      builder: (context, constraints) => AlertDialog(
        title: const Text('Zarządzaj współpracami'),
        content: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: const Text(
                'Możesz zmieniać kolejność skoczków poprzez przeciąganie poszczególnych "kafelków" (mechanizm przeciągnij i upuść). Masz możliwość zakończenia współpracy z wybranymi podopiecznymi.',
              ),
            ),
            const Gap(20),
            SizedBox(
              height: constraints.maxHeight * 0.6,
              width: 650,
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: _orderedJumpers.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final movedJumper = _orderedJumpers.removeAt(oldIndex);
                    _orderedJumpers.insert(newIndex, movedJumper);
                  });
                },
                itemBuilder: (context, index) {
                  final jumper = _orderedJumpers[index];
                  return ReorderableDragStartListener(
                    key: ValueKey(index),
                    index: index,
                    child: _JumperTile(
                      jumper: jumper,
                      levelReport: database.jumperReports[jumper]!.levelReport,
                      onAction: () {
                        setState(() {
                          _shouldBeRemoved[jumper] = !_shouldBeRemoved[jumper]!;
                        });
                      },
                      action: _shouldBeRemoved[jumper] == true
                          ? _JumperTileAction.undoEndingPartnership
                          : _JumperTileAction.endPartnership,
                    ),
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
            onPressed: () async {
              final toRemove = _shouldBeRemoved.keys
                  .where((jumper) => _shouldBeRemoved[jumper] == true);
              final endOfPartnershipExists = toRemove.isNotEmpty;

              bool confirm = false;
              if (!endOfPartnershipExists) {
                confirm = true;
              } else {
                confirm = await showSjmDialog(
                  barrierDismissible: true,
                  context: context,
                  child: _AreYouSureDialog(
                    partnershipsToEnd: toRemove,
                  ),
                );
              }

              if (confirm) {
                final newOrder = _orderedJumpers.where(
                  (jumper) => !_shouldBeRemoved[jumper]!,
                );
                final dialogResult = ManagePartnershipsDialogResult(
                  partnershipsToRemove: toRemove,
                  newOrder: newOrder.toList(),
                );
                widget.onSubmit(dialogResult);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            },
            child: const Text('Zatwierdź'),
          ),
        ],
      ),
    );
  }
}

class _JumperTile extends StatelessWidget {
  const _JumperTile({
    required this.jumper,
    required this.levelReport,
    required this.onAction,
    required this.action,
  });

  final SimulationJumper jumper;
  final JumperLevelReport? levelReport;
  final VoidCallback onAction;
  final _JumperTileAction action;

  @override
  Widget build(BuildContext context) {
    final actionText = action == _JumperTileAction.endPartnership
        ? 'Zakończ współpracę'
        : 'Cofnij zakończenie współpracy';
    final actionTextColor = action == _JumperTileAction.endPartnership
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.secondary;

    return ListTile(
      leading: SimulationJumperImage(
        jumper: jumper,
        width: 35,
      ),
      trailing: TextButton(
        onPressed: onAction,
        child: Text(
          actionText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: actionTextColor),
        ),
      ),
      title: Text(jumper.nameAndSurname()),
      subtitle: Text(
        translateJumperLevelDescription(
          context: context,
          levelDescription: levelReport?.levelDescription,
        ),
      ),
    );
  }
}

enum _JumperTileAction {
  endPartnership,
  undoEndingPartnership,
}

class _AreYouSureDialog extends StatelessWidget {
  const _AreYouSureDialog({
    required this.partnershipsToEnd,
  });

  final Iterable<SimulationJumper> partnershipsToEnd;

  @override
  Widget build(BuildContext context) {
    final normalTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final boldTextStyle = Theme.of(context).textTheme.titleSmall!;
    return AlertDialog(
      title: const Text('Zakończenie współpracy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Czy chcesz przejść dalej? Oznacza to zakończenie współpracy z następującymi skoczkami/skoczkiniami:',
            style: normalTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var jumper in partnershipsToEnd)
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '- ', style: normalTextStyle),
                      TextSpan(text: jumper.nameAndSurname(), style: boldTextStyle),
                    ]),
                  ),
              ],
            ),
          ),
        ],
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
          child: const Text('Tak, zakończ współprace'),
        ),
      ],
    );
  }
}

class ManagePartnershipsDialogResult {
  const ManagePartnershipsDialogResult({
    required this.partnershipsToRemove,
    required this.newOrder,
  });

  final Iterable<SimulationJumper> partnershipsToRemove;
  final List<SimulationJumper> newOrder;
}
