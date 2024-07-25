part of '../../simulation_wizard_dialog.dart';

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    super.key,
    required this.country,
    required this.onTap,
    required this.isSelected,
  });

  final Country country;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: SimulationWizardOptionButton(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        isSelected: isSelected,
        child: Column(
          children: [
            const Gap(10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CountryFlag(
                    country: country,
                    width: constraints.maxWidth * 0.8,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  country.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
