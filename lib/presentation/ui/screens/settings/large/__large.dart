part of '../settings_screen.dart';

class _Large extends StatelessWidget {
  const _Large();

  @override
  Widget build(BuildContext context) {
    const gap = Gap(UiSettingsConstants.gapBetweenSettingTiles);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context).settings),
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LanguageDropdown(),
            gap,
            AppColorSchemeDropdown(),
            gap,
            AppThemeBrigthnessDropdown(),
            gap,
            Padding(
              padding: EdgeInsets.only(left: 6),
              child: GoToTrainingAnalyzerButton(),
            ),
            gap,
          ],
        ),
      ),
    );
  }
}
