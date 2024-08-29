part of '../../database_editor_screen.dart';

class _TutorialRunner {
  final _widgetKeys = <_TutorialStep, GlobalKey>{};
  late TutorialCoachMark _tutorial;

  void addWidgetKey({required _TutorialStep step, required GlobalKey key}) {
    if (!_widgetKeys.containsKey(step)) {
      _widgetKeys[step] = key;
    }
  }

  void runTutorial(BuildContext context) {
    _tutorial = _constructTutorial(context);
    _tutorial.show(context: context);
  }

  TutorialCoachMark _constructTutorial(BuildContext context) {
    final goNextButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () {
        _tutorial.next();
      },
      child: Text(
        'Dalej',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
    return TutorialCoachMark(
      textSkip: 'Pomiń przewodnik',
      textStyleSkip: Theme.of(context).textTheme.headlineSmall!,
      opacityShadow: 0.935,
      pulseEnable: false,
      alignSkip: const Alignment(0.98, 0.88),
      targets: [
        TargetFocus(
          shape: ShapeLightFocus.RRect,
          radius: 15,
          identify: 'Target 1 (Tabs)',
          keyTarget: _widgetKeys[_TutorialStep.tabs]!,
          enableOverlayTab: false,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Możesz edytować 6 różnych rodzajów danych',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Gap(15),
                  goNextButton,
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          shape: ShapeLightFocus.RRect,
          radius: 15,
          identify: 'Target 2 (Items)',
          keyTarget: _widgetKeys[_TutorialStep.items]!,
          contents: [
            TargetContent(
                padding: EdgeInsets.zero,
                align: ContentAlign.custom,
                customPosition: CustomTargetContentPosition(top: 200, left: 200),
                child: FractionallySizedBox(
                  widthFactor: 0.35,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          'W tym miejscu widzisz listę elementów. Po kliknięciu na jeden z nich wyświetli się edytor',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const Gap(15),
                      goNextButton,
                    ],
                  ),
                )),
          ],
        ),
        TargetFocus(
          shape: ShapeLightFocus.RRect,
          radius: 15,
          identify: 'Target 3 (FABs)',
          keyTarget: _widgetKeys[_TutorialStep.fabs]!,
          contents: [
            TargetContent(
              padding: EdgeInsets.zero,
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 200, right: 100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Dodawaj i usuwaj dane używajac tych przycisków',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Gap(15),
                  goNextButton,
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          shape: ShapeLightFocus.RRect,
          radius: 15,
          identify: 'Target 4 (Editor)',
          keyTarget: _widgetKeys[_TutorialStep.editor]!,
          contents: [
            TargetContent(
              padding: EdgeInsets.zero,
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 200, right: 450),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Kiedy wybierzesz jakiś przedmiot, pojawi się tu zaawansowany edytor',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Gap(15),
                  goNextButton,
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          shape: ShapeLightFocus.RRect,
          radius: 15,
          identify: 'Target 5 (Filters)',
          keyTarget: _widgetKeys[_TutorialStep.filters]!,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Pokaż tylko te przedmioty, które cię interesują. Pomogą ci w tym filtry',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Gap(15),
                  goNextButton,
                ],
              ),
            ),
          ],
        ),
        TargetFocus(
          shape: ShapeLightFocus.RRect,
          radius: 15,
          identify: 'Target 6 (Special IO Buttons)',
          keyTarget: _widgetKeys[_TutorialStep.specialIoButtons]!,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Możesz wczytać bazę danych z dysku, lub stworzyć kopię w wybranym folderze',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Gap(15),
                  goNextButton,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum _TutorialStep {
  tabs,
  items,
  fabs,
  editor,
  filters,
  specialIoButtons,
}
