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
          children: [
            LanguageDropdownListTile(),
            gap,
            AppColorSchemeDropdownListTile(),
          ],
        ),
      ),
    );
  }
}
