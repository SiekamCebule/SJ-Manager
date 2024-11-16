part of '../../../simulation_route.dart';

class _JumpersScreen extends StatefulWidget {
  const _JumpersScreen({
    this.initialSex = SelectedSex.female,
  }) : assert(initialSex != SelectedSex.both);

  final SelectedSex initialSex;

  @override
  State<_JumpersScreen> createState() => _JumpersScreenState();
}

class _JumpersScreenState extends State<_JumpersScreen> {
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
    final cardTitleStyle = Theme.of(context).textTheme.headlineSmall;
    return BlocBuilder<SearchFilterCubit, SearchFilterState>(
      bloc: _searchFilterCubit,
      builder: (context, searchState) {
        return Scaffold(
          body: Column(
            children: [
              const Gap(10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: CardWithTitle(
                        title: Row(
                          children: [
                            Text(
                              'Lista skoczków',
                              style: cardTitleStyle,
                            ),
                            const Gap(15),
                            SegmentedButton(
                              showSelectedIcon: false,
                              segments: const [
                                ButtonSegment(
                                  value: SelectedSex.male,
                                  icon: Icon(Symbols.male),
                                  label: Text('Mężczyźni'),
                                ),
                                ButtonSegment(
                                  value: SelectedSex.female,
                                  icon: Icon(Symbols.female),
                                  label: Text('Kobiety'),
                                ),
                              ],
                              selected: {_selectedSex},
                              onSelectionChanged: (selected) {
                                setState(() {
                                  _selectedSex = selected.single;
                                });
                              },
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: _JumpersListView(
                                selectedSex: _selectedSex,
                                searchText: searchState.text,
                              ),
                            ),
                            const Gap(10),
                            Center(
                              child: SizedBox(
                                width: 400,
                                child: MySearchBar(
                                  onChanged: _searchFilterCubit.setText,
                                  hintText: 'Wyszukaj...',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surfaceContainerHigh,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 10,
                            child: CardWithTitle(
                              title: Text(
                                'Ranking męski',
                                style: cardTitleStyle,
                              ),
                              child: Placeholder(),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 10,
                            child: CardWithTitle(
                              title: Text(
                                'Ranking żeński',
                                style: cardTitleStyle,
                              ),
                              child: Placeholder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }
}

class _JumpersListView extends StatelessWidget {
  const _JumpersListView({
    required this.selectedSex,
    required this.searchText,
  });

  final SelectedSex selectedSex;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
    final helper = SimulationDatabaseHelper(database: database);
    final jumpers = database.jumpers.where((jumper) => jumper.sex == selectedSex.toSex());
    final filter = Filter<SimulationJumper>(
        shouldPass: (jumper) => DefaultJumperMatchingByTextAlgorithm(
                fullName: jumper.nameAndSurname(), text: searchText)
            .matches());
    final filteredJumpers = filter(jumpers);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        mainAxisExtent: 65,
        mainAxisSpacing: 8,
        crossAxisSpacing: 15,
      ),
      itemCount: filteredJumpers.length,
      itemBuilder: (context, index) {
        final jumper = filteredJumpers.elementAt(index);
        final jumperIsCharge = helper.managerJumpers.contains(jumper);
        return JumperSimpleListTile(
          jumper: jumper,
          subtitle: JumperSimpleListTileSubtitle.levelDescription,
          levelDescription: jumper.reports.levelReport!.levelDescription,
          leading: JumperSimpleListTileLeading.jumperImage,
          trailing: JumperSimpleListTileTrailing.countryFlag,
          tileColor: jumperIsCharge
              ? Theme.of(context)
                  .colorScheme
                  .onSecondary
                  .blendWithBg(Theme.of(context).brightness, 0.04)
              : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            // TODO
          },
        );
      },
    );
  }
}
