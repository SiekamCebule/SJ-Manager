part of '../training_analyzer_screen.dart';

class _DynamicMainBody extends StatelessWidget {
  const _DynamicMainBody();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TrainingAnalyzerCubit>().state;
    final initialWidget = Center(
      child: Text(
        'Przeprowadź symulację treningu, aby pokazać wyniki',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );

    final widget = state is TrainingAnalyzerSimulated
        ? _Chart(
            result: state.result,
            categories: state.dataCategories,
          )
        : initialWidget;

    return AnimatedSwitcher(
      duration: Durations.short4,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: widget,
    );
  }
}
