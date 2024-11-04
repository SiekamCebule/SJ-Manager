part of '../jumper_training_configurator.dart';

class _ReportComponent extends StatelessWidget {
  const _ReportComponent({
    required this.weeklyReport,
    required this.monthlyReport,
  });

  final TrainingReport? weeklyReport;
  final TrainingReport? monthlyReport;

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(
        'Raport z treningu',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            IntrinsicHeight(
              child: const TabBar.secondary(
                tabs: [
                  Tab(
                    text: 'Tygodniowo',
                  ),
                  Tab(
                    text: 'Miesięcznie',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TrainingProgressReportDisplay(
                    report: weeklyReport,
                  ),
                  TrainingProgressReportDisplay(
                    report: monthlyReport,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
