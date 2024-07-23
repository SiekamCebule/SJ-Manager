part of '../simulation_wizard_dialog.dart';

class _CountryScreen extends StatefulWidget {
  const _CountryScreen();

  @override
  State<_CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<_CountryScreen> {
  late LocalDbRepo database; // TODO

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150),
            itemCount: database.countries.lastLength,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.red,
              );
            },
          ),
        ),
      ],
    );
  }
}
