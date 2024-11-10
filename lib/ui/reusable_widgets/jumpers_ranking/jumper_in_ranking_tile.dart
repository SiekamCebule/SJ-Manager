import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/simulation_jumper_image.dart';

class JumperInRankingTile extends StatelessWidget {
  const JumperInRankingTile({
    super.key,
    required this.jumper,
    required this.position,
    this.onTap,
  });

  final Jumper jumper;
  final int position;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        position.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: SimulationJumperImage(
        jumper: jumper,
        width: 25,
      ),
      title: Text(jumper.nameAndSurname()),
      onTap: onTap,
    );
  }
}
