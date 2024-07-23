part of '../simulation_wizard_dialog.dart';

class _CountryScreen extends StatefulWidget {
  const _CountryScreen({
    required this.onChange,
  });

  final void Function(Country? country) onChange;

  @override
  State<_CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<_CountryScreen> {
  late LocalDbRepo database;
  bool databaseIsExternal = false;

  Country? selectedCountry;

  @override
  void initState() {
    widget.onChange(selectedCountry);
    _setDatabaseToLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 130),
            itemCount: database.countries.lastLength,
            itemBuilder: (context, index) {
              final country = database.countries.lastItems[index];
              return _CountryTile(
                key: ValueKey(country.code),
                isSelected: selectedCountry == country,
                country: country,
                onTap: () {
                  setState(() {
                    if (selectedCountry == country) {
                      selectedCountry = null;
                    } else {
                      selectedCountry = country;
                    }
                  });
                  widget.onChange(selectedCountry);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _setDatabaseToLocal() {
    setState(() {
      database = context.read<LocalDbRepo>();
      databaseIsExternal = false;
    });
  }

  Future<void> _loadExternalDatabase(Directory directory) async {
    database = await LocalDbRepo.fromDirectory(directory, context: context);
  }

  // TODO: Tylko kraje z zawodnikami (w bloc)
  // wiecej na text
  // ogolnie zmniejszyc
}
