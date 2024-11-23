part of 'simulation_wizard_dialog.dart';

class _TeamScreen extends StatefulWidget {
  const _TeamScreen({
    required this.onChange,
  });

  final void Function(CountryTeam? country) onChange;

  @override
  State<_TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<_TeamScreen> {
  // Zrobić dispose() na bazie danych - tutaj lub z poziomu zapisanych opcji wizarda
  late TeamPreviewCreator _teamPreviewCreator;

  var _selectedSex = Sex.male;
  CountryTeam? _selectedTeam;
  late List<CountryTeam> _maleTeams;
  late List<CountryTeam> _femaleTeams;
  late final StreamSubscription _dbChangesSubscription;

  @override
  void initState() {
    widget.onChange(_selectedTeam);
    final variant = context.read<SimulationWizardOptions>().gameVariant!;
    final date = context.read<SimulationWizardOptions>().startDate!;
    _teamPreviewCreator = DefaultCountryTeamPreviewCreator(
      gameVariant: variant,
      currentDate: date.date,
    );
    context.read<SimulationWizardOptions>().addListener(() {
      _setUpMaleAndFemaleTeams();
    });
    _setUpMaleAndFemaleTeams();

    super.initState();
  }

  void _setUpMaleAndFemaleTeams() {
    final variant = context.read<SimulationWizardOptions>().gameVariant!;
    setState(() {
      _maleTeams = variant.countryTeams
          .cast<CountryTeam>()
          .where((team) => team.sex == Sex.male)
          .toList();
      _femaleTeams = variant.countryTeams
          .cast<CountryTeam>()
          .where((team) => team.sex == Sex.female)
          .toList();
    });
  }

  @override
  void dispose() {
    _dbChangesSubscription.cancel();
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
}
