part of '../training_analyzer_screen.dart';

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TrainingAnalyzerCubit>().state;
    final categories = state.dataCategories;
    void toggleCategory(TrainingAnalyzerDataCategory category) {
      final changedCategories = Set.of(categories);
      changedCategories.toggle(category);
      context.read<TrainingAnalyzerCubit>().setCategories(changedCategories);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Training Analyzer'),
        actions: [
          HelpIconButton(
            onPressed: () async {
              await showSimpleHelpDialog(
                context: context,
                title: 'Training Analyzer',
                content:
                    'Training Analyzer jest narzędziem które pozwala testować mechanizmy treningu w SJ Managerze.\nWczytuje on plik config.json z folderu \'sj_manager/user_data/training_analyzer\', w którym dopasowuje się silnik treningowy i parametry osoby trenowanej',
              );
            },
          ),
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(Symbols.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<TrainingAnalyzerCubit>().simulate(
                pathsCache: context.read(),
                additionalActions: TrainingAnalyzerActions.values.toSet(),
              );
        },
        label: const Text('Symuluj trening'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      endDrawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(8),
            Text(
              'Wykres',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            CheckboxListTile(
              title: const Text('Wybicie'),
              value: categories.contains(TrainingAnalyzerDataCategory.takeoffQuality),
              onChanged: (value) =>
                  toggleCategory(TrainingAnalyzerDataCategory.takeoffQuality),
            ),
            CheckboxListTile(
              title: const Text('Lot'),
              value: categories.contains(TrainingAnalyzerDataCategory.flightQuality),
              onChanged: (value) =>
                  toggleCategory(TrainingAnalyzerDataCategory.flightQuality),
            ),
            CheckboxListTile(
              title: const Text('Lądowanie'),
              value: categories.contains(TrainingAnalyzerDataCategory.landingQuality),
              onChanged: (value) =>
                  toggleCategory(TrainingAnalyzerDataCategory.landingQuality),
            ),
            CheckboxListTile(
              title: const Text('Forma'),
              value: categories.contains(TrainingAnalyzerDataCategory.form),
              onChanged: (value) => toggleCategory(TrainingAnalyzerDataCategory.form),
            ),
            CheckboxListTile(
              title: const Text('Równość'),
              value: categories.contains(TrainingAnalyzerDataCategory.jumpsConsistency),
              onChanged: (value) =>
                  toggleCategory(TrainingAnalyzerDataCategory.jumpsConsistency),
            ),
            CheckboxListTile(
              title: const Text('Zmęczenie'),
              value: categories.contains(TrainingAnalyzerDataCategory.fatigue),
              onChanged: (value) => toggleCategory(TrainingAnalyzerDataCategory.fatigue),
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          Expanded(
            child: SizedBox.expand(
              child: _DynamicMainBody(),
            ),
          ),
          Gap(15),
        ],
      ),
    );
  }
}
