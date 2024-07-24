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
  late LocalDbRepo _database;
  late MaleCountryPreviewCreator _maleCountryPreviewCreator;
  late FemaleCountryPreviewCreator _femaleCountryPreviewCreator;
  late bool _databaseIsExternal = false; // TODO: Loading external database
  Country? _selectedCountry;

  @override
  void initState() {
    widget.onChange(_selectedCountry);
    _setDatabaseToLocal();
    _maleCountryPreviewCreator = DefaultMaleCountryPreviewCreator(database: _database);
    _femaleCountryPreviewCreator =
        DefaultFemaleCountryPreviewCreator(database: _database);
    super.initState();
  }

  @override
  void dispose() {
    _database.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countries = _database.countries.lastItems.withoutNoneCountry.toList();
    final countryCode = _selectedCountry?.code ?? '';
    final nationalRecord = _maleCountryPreviewCreator.nationalRecord(countryCode);

    return MultiProvider(
      providers: [
        Provider.value(
          value: _maleCountryPreviewCreator,
        ),
        Provider.value(
          value: _femaleCountryPreviewCreator,
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 130,
                childAspectRatio: 0.9,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return _CountryTile(
                  key: ValueKey(country.code),
                  isSelected: _selectedCountry == country,
                  country: country,
                  onTap: () {
                    setState(() {
                      if (_selectedCountry == country) {
                        _selectedCountry = null;
                      } else {
                        _selectedCountry = country;
                      }
                    });
                    widget.onChange(_selectedCountry);
                  },
                );
              },
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 400,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: _selectedCountry != null
                  ? Column(
                      children: [
                        const Gap(15),
                        CountryTitle(country: _selectedCountry!),
                        const Gap(15),
                        const PreviewStatTexts(
                          description: 'Poziom: ',
                          content: Stars(stars: 5),
                        ),
                        const Gap(5),
                        PreviewStatTexts(
                          description: 'Najlepszy zawodnik: ',
                          contentText: _maleCountryPreviewCreator
                                  .bestJumper(countryCode)
                                  ?.nameAndSurname() ??
                              'Brak',
                        ),
                        const Gap(5),
                        PreviewStatTexts(
                          description: 'Rekord krajowy: ',
                          contentText: nationalRecord?.distance != null
                              ? '${nationalRecord!.distance.toStringAsFixed(1)}m (${nationalRecord.jumperNameAndSurname})'
                              : 'Brak',
                        ),
                        const Gap(5),
                        PreviewStatTexts(
                          description: 'Wschodząca gwiazda: ',
                          contentText: _maleCountryPreviewCreator
                                  .risingStar(countryCode)
                                  ?.nameAndSurname() ??
                              'Brak',
                        ),
                        const Gap(5),
                        PreviewStatTexts(
                          description: 'Największa skocznia: ',
                          contentText: _maleCountryPreviewCreator
                                  .largestHill(countryCode)
                                  ?.toString() ??
                              'Brak',
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _setDatabaseToLocal() {
    setState(() {
      _database = context.read<LocalDbRepo>();
      _databaseIsExternal = false;
    });
  }

  Future<void> _loadExternalDatabase(Directory directory) async {
    _database = await LocalDbRepo.fromDirectory(directory, context: context);
  }

  // TODO: Tylko kraje z zawodnikami (w bloc)
  // wiecej na text
  // ogolnie zmniejszyc
}
