part of '../simulation_wizard_dialog.dart';

class _SubteamScreen extends StatefulWidget {
  const _SubteamScreen({
    required this.onChange,
    required this.subteamTypes,
  });

  final Function(SubteamType? subteamType) onChange;
  final Set<SubteamType> subteamTypes;

  @override
  State<_SubteamScreen> createState() => _SubteamScreenState();
}

class _SubteamScreenState extends State<_SubteamScreen> {
  SubteamType? _selected;

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
              itemCount: widget.subteamTypes.length,
              itemBuilder: (context, index) {
                final subteamType = widget.subteamTypes.elementAt(index);
                final titleText = subteamTypeNames[subteamType]!.translate(context);
                final subtitleText =
                    subteamTypeDescriptionsWhenChoosing[subteamType]!.translate(context);
                return ListTile(
                  key: ValueKey(index),
                  leading: const Icon(Symbols.circle),
                  title: Text(titleText),
                  subtitle: Text(subtitleText),
                  selected: _selected == subteamType,
                  onTap: () {
                    setState(() {
                      if (_selected == null || (_selected != subteamType)) {
                        _selected = subteamType;
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
