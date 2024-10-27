part of '../jumper_training_configurator.dart';

class _SubjectiveTrainingEfficiencyComponent extends StatelessWidget {
  const _SubjectiveTrainingEfficiencyComponent({
    required this.efficiency,
  });

  final double? efficiency;

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Odczucia zawodnika',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          HelpIconButton(
            onPressed: () {},
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (efficiency == null)
            Center(
              child: Text(
                'Ujawnią się za jakiś czas...',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          if (efficiency != null)
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${(efficiency! * 100).round()}%',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 8.0))),
                    TextSpan(
                      text: 'efektywności treningu wg zawodnika',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
