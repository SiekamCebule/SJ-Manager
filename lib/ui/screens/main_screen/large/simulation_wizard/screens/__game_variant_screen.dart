part of '../simulation_wizard_dialog.dart';

class _GameVariantScreen extends StatefulWidget {
  const _GameVariantScreen({
    required this.onChange,
    required this.gameVariants,
  });

  final Function(GameVariant? variant) onChange;
  final Iterable<GameVariant> gameVariants;

  @override
  State<_GameVariantScreen> createState() => __GameVariantScreenState();
}

class __GameVariantScreenState extends State<_GameVariantScreen> {
  GameVariant? _selected;

  @override
  void initState() {
    widget.onChange(_selected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: ListView.builder(
              itemCount: widget.gameVariants.length,
              itemBuilder: (context, index) {
                final variant = widget.gameVariants.elementAt(index);
                return ListTile(
                  key: ValueKey(index),
                  leading: const Icon(Symbols.circle),
                  title: Text(variant.name.translate(context)),
                  subtitle: Text(variant.description.translate(context)),
                  selected: _selected == variant,
                  onTap: () {
                    setState(() {
                      if (_selected == null) {
                        _selected = variant;
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
        Expanded(
          flex: 3,
          child: SizedBox(
            height: double.infinity,
            child: Card(
              shape: const Border(),
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              margin: EdgeInsets.zero,
              child: const Padding(
                padding: EdgeInsets.only(left: 13, top: 13),
                child: Text(
                  'Różne warianty gry oferują różne wrażenia - każdy wariant ma inne kalendarze, inne skocznie i zasady rozgrywki. Dzięki temu możesz m.in. symulować legendarne sezony z uwzględnieniem realnych kalendarzy. Chcesz zagrać realistyczną karierę w czasie teraźniejszym, a może karierę opartą na fikcyjnym uniwersum przyszłości?\nWciąż trwają prace nad dodawaniem kolejnych wariantów.',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
