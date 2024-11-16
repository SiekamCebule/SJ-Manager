part of '../simulation_wizard_dialog.dart';

class _StartDateScreen extends StatefulWidget {
  const _StartDateScreen({
    required this.onChange,
    required this.gameVariant,
  });

  final Function(GameVariantStartDate? startDate) onChange;
  final GameVariant gameVariant;

  @override
  State<_StartDateScreen> createState() => _StartDateScreenState();
}

class _StartDateScreenState extends State<_StartDateScreen> {
  GameVariantStartDate? _selected;

  @override
  void initState() {
    widget.onChange(_selected);
    super.initState();
  }

  static final _dateFormat = DateFormat('EEE, MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    final startDates = widget.gameVariant.startDates;
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: ListView.builder(
              itemCount: startDates.length,
              itemBuilder: (context, index) {
                final startDate = startDates.elementAt(index);
                return ListTile(
                  key: ValueKey(index),
                  leading: const Icon(Symbols.circle),
                  title: Text(startDate.label.translate(context)),
                  subtitle: Text(_dateFormat.format(startDate.date)),
                  selected: _selected == startDate,
                  onTap: () {
                    setState(() {
                      if (_selected == null || (_selected != startDate)) {
                        _selected = startDate;
                      } else {
                        _selected = null;
                      }
                      widget.onChange(_selected);
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
