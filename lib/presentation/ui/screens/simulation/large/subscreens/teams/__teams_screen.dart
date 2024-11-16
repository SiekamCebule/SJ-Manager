part of '../../../simulation_route.dart';

class _TeamsScreen extends StatefulWidget {
  const _TeamsScreen({
    this.initialSex = SelectedSex.both,
  });

  final SelectedSex initialSex;

  @override
  State<_TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<_TeamsScreen> {
  late SelectedSex _selectedSex;
  late final SearchFilterCubit _searchFilterCubit;

  @override
  void initState() {
    _searchFilterCubit = SearchFilterCubit(
      debounceTime: const Duration(milliseconds: 100),
    );
    _selectedSex = widget.initialSex;
    super.initState();
  }

  @override
  void dispose() {
    _searchFilterCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchFilterCubit, SearchFilterState>(
      bloc: _searchFilterCubit,
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              children: [
                SizedBox(
                  width: 400,
                  child: MySearchBar(
                    onChanged: _searchFilterCubit.setText,
                    hintText: 'Wyszukaj...',
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                ),
                const Spacer(),
                SegmentedButton(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: SelectedSex.both,
                      icon: Icon(Symbols.diversity_3),
                      label: Text('Wszystkie'),
                    ),
                    ButtonSegment(
                      value: SelectedSex.male,
                      icon: Icon(Symbols.male),
                      label: Text('Męskie'),
                    ),
                    ButtonSegment(
                      value: SelectedSex.female,
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
          body: Column(
            children: [
              const Gap(20),
              Expanded(
                child: _ListView(
                  sex: _selectedSex,
                  searchText: state.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    required this.sex,
    required this.searchText,
  });

  final SelectedSex sex;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
    var teams = switch (sex) {
      SelectedSex.both => database.countryTeams,
      SelectedSex.male => database.maleJumperTeams,
      SelectedSex.female => database.femaleJumperTeams,
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
            final team = teams.elementAt(index);
            final flagsRepo = context.read<CountryFlagsRepo>();
            final jumperImagesRepo =
                context.read<DbItemImageGeneratingSetup<SimulationJumper>>();
            final dbHelper = context.read<SimulationDatabaseHelper>();
            await showDialog(
              context: context,
              builder: (context) {
                return MultiProvider(
                  providers: [
                    Provider.value(value: flagsRepo),
                    Provider.value(value: jumperImagesRepo),
                    Provider.value(value: dbHelper),
                    ChangeNotifierProvider.value(value: database),
                  ],
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.8,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CountryTeamProfileWidget(
                          team: team,
                        ),
                      ),
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

enum SelectedSex {
  male,
  female,
  both;

  Sex toSex() {
    return switch (this) {
      SelectedSex.male => Sex.male,
      SelectedSex.female => Sex.female,
      SelectedSex.both =>
        throw ArgumentError('Cannot convert "both sexes" to Sex object'),
    };
  }
}
