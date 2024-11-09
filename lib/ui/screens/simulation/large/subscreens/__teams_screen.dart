part of '../../simulation_route.dart';

enum TeamsScreenSelectedSex {
  male,
  female,
  both;

  Sex toSex() {
    return switch (this) {
      TeamsScreenSelectedSex.male => Sex.male,
      TeamsScreenSelectedSex.female => Sex.female,
      TeamsScreenSelectedSex.both =>
        throw ArgumentError('Cannot convert "both sexes" to Sex object'),
    };
  }
}

class _TeamsScreen extends StatefulWidget {
  const _TeamsScreen({
    this.initialSex = TeamsScreenSelectedSex.both,
  });

  final TeamsScreenSelectedSex initialSex;

  @override
  State<_TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<_TeamsScreen> {
  late TeamsScreenSelectedSex _selectedSex;
  late final TextEditingController _searchController;
  late StreamController<String> _searchTextStreamController;
  late StreamSubscription<String> _filterTextSubscription;

  @override
  void initState() {
    _searchTextStreamController = StreamController();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _searchTextStreamController.add(_searchController.text);
    });
    _filterTextSubscription = _searchTextStreamController.stream
        .debounceTime(const Duration(milliseconds: 100))
        .listen(null);
    _filterTextSubscription.onData((_) {
      setState(() {});
    });
    _selectedSex = widget.initialSex;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Row(
          children: [
            SizedBox(
              width: 400,
              child: MySearchBar(
                controller: _searchController,
                hintText: 'Wyszukaj...',
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
            ),
            const Spacer(),
            SegmentedButton(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: TeamsScreenSelectedSex.both,
                  icon: Icon(Symbols.diversity_3),
                  label: Text('Wszystkie'),
                ),
                ButtonSegment(
                  value: TeamsScreenSelectedSex.male,
                  icon: Icon(Symbols.male),
                  label: Text('Męskie'),
                ),
                ButtonSegment(
                  value: TeamsScreenSelectedSex.female,
                  icon: Icon(Symbols.female),
                  label: Text('Żeńskie'),
                ),
              ],
              selected: {_selectedSex},
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedSex = selected.single;
                });
              },
            ),
            const Gap(50),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Gap(20),
            Expanded(
              child: _ListView(
                sex: _selectedSex,
                searchText: _searchController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    required this.sex,
    required this.searchText,
  });

  final TeamsScreenSelectedSex sex;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    var teams = switch (sex) {
      TeamsScreenSelectedSex.both => database.countryTeams.last,
      TeamsScreenSelectedSex.male => database.maleJumperTeams,
      TeamsScreenSelectedSex.female => database.femaleJumperTeams,
    };
    teams = teams.where((countryTeam) {
      final countryName = countryTeam.country.multilingualName.translate(context);
      return countryName.toLowerCase().containsAllLetters(from: searchText.toLowerCase());
    });

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 50,
      ),
      shrinkWrap: true,
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return CountryTeamOverviewListTile(
          team: teams.elementAt(index),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  child: AlertDialog(
                    title: Text('Profil drużyny'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Placeholder(),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// francja
// musi zawierac f i r
// fr
