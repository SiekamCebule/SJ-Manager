part of '../simulation_wizard_dialog.dart';

class _TeamScreen extends StatefulWidget {
  const _TeamScreen({
    required this.onChange,
  });

  final void Function(CountryTeam? country) onChange;

  @override
  State<_TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<_TeamScreen> {
  late LocalDbRepo _database;
  late MaleCountryPreviewCreator _maleCountryPreviewCreator;
  late FemaleCountryPreviewCreator _femaleCountryPreviewCreator;
  late bool _databaseIsExternal = false; // TODO: Loading external database

  var _selectedSex = Sex.male;
  CountryTeam? _selectedTeam;
  late DbItemsRepo<CountryTeam> _maleTeams;
  late DbItemsRepo<CountryTeam> _femaleTeams;
  List<CountryTeam> get _teams =>
      _selectedSex == Sex.male ? _maleTeams.lastItems : _femaleTeams.lastItems;

  @override
  void initState() {
    widget.onChange(_selectedTeam);
    _setDatabaseToLocal();
    _maleCountryPreviewCreator = DefaultMaleCountryPreviewCreator(database: _database);
    _femaleCountryPreviewCreator =
        DefaultFemaleCountryPreviewCreator(database: _database);
    _initializeTeams();
    super.initState();
  }

  void _initializeTeams() {
    final countriesHaveMales = jumpersByCountry(
        _database.maleJumpers.lastItems, _database.countries.lastItems,
        excludeEmpty: true);
    _maleTeams = DbItemsRepo(
      initial: countriesHaveMales.keys
          .map((country) => CountryTeam(sex: Sex.male, country: country))
          .toList(),
    );
    final countriesHaveFemales = jumpersByCountry(
        _database.femaleJumpers.lastItems, _database.countries.lastItems,
        excludeEmpty: true);
    _femaleTeams = DbItemsRepo(
      initial: countriesHaveFemales.keys
          .map((country) => CountryTeam(sex: Sex.female, country: country))
          .toList(),
    );
  }

  @override
  void dispose() {
    _database.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryCode = _selectedTeam?.country.code ?? '';
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
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: const [
                  Tab(
                    text: 'Drużyny męskie',
                    icon: Icon(Symbols.male),
                  ),
                  Tab(
                    text: 'Drużyny żeńskie',
                    icon: Icon(Symbols.female),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedSex = Sex.values[index];
                    print(_selectedSex);
                  });
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 130,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: _teams.length,
                        itemBuilder: (context, index) {
                          final team = _teams[index];
                          return _CountryTile(
                            // key: ValueKey(team.country.code),
                            isSelected: _selectedTeam?.country == team.country,
                            country: team.country,
                            onTap: () {
                              setState(() {
                                if (_selectedTeam?.country == team.country) {
                                  _selectedTeam = null;
                                } else {
                                  _selectedTeam = CountryTeam(
                                      sex: _selectedSex, country: team.country);
                                }
                              });
                              widget.onChange(_selectedTeam);
                            },
                          );
                        },
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      width: 400,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        child: _selectedTeam != null
                            ? Column(
                                children: [
                                  const Gap(15),
                                  CountryTitle(country: _selectedTeam!.country),
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
              ),
            ],
          ),
        ),
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

  // wiecej na text
  // ogolnie zmniejszyc
}
