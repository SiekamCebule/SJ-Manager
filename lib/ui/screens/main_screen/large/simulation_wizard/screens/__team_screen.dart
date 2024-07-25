part of '../simulation_wizard_dialog.dart';

class _TeamScreen extends StatefulWidget {
  const _TeamScreen({
    required this.onChange,
  });

  final void Function(Team? country) onChange;

  @override
  State<_TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<_TeamScreen> {
  late LocalDbRepo _database;
  late TeamPreviewCreator _teamPreviewCreator;
  late bool _databaseIsExternal = false; // TODO: Loading external database

  var _selectedSex = Sex.male;
  CountryTeam? _selectedTeam;
  late List<CountryTeam> _maleTeams;
  late List<CountryTeam> _femaleTeams;

  @override
  void initState() {
    widget.onChange(_selectedTeam);
    _setDatabaseToLocal();
    _teamPreviewCreator = DefaultCountryTeamPreviewCreator(database: _database);
    _maleTeams = _database.teams.lastItems
        .cast<CountryTeam>()
        .where((team) => team.sex == Sex.male)
        .toList();
    _femaleTeams = _database.teams.lastItems
        .cast<CountryTeam>()
        .where((team) => team.sex == Sex.female)
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    _database.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: _teamPreviewCreator,
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
                    if (index != _selectedSex.index) {
                      _selectedTeam = null;
                    }
                    _selectedSex = Sex.values[index];
                  });
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _CountryTeamsGrid(
                        teams: _selectedSex == Sex.male ? _maleTeams : _femaleTeams,
                        onTap: (tappedTeam) {
                          final oldTeam = _selectedTeam;
                          setState(() {
                            if (tappedTeam == _selectedTeam) {
                              _selectedTeam = null;
                            } else {
                              _selectedTeam = tappedTeam;
                            }
                          });
                          if (_selectedTeam != oldTeam) {
                            widget.onChange(_selectedTeam);
                          }
                        },
                        selected: _selectedTeam,
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      width: 400,
                      child: _selectedTeam != null
                          ? _TeamPreview(team: _selectedTeam!)
                          : null,
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
    _database = await LocalDbRepo.fromDirectory(
      directory,
      context: context,
      teamFromJson: context.read<DbItemsJsonConfiguration<Team>>().fromJson,
    );
  }

  // wiecej na text
  // ogolnie zmniejszyc
}
