import 'package:flutter/material.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/jumpers_ranking/jumper_in_ranking_tile.dart';

class TeamJumpersRankingList extends StatelessWidget {
  const TeamJumpersRankingList({
    super.key,
    required this.jumpers,
  });

  final List<Jumper> jumpers;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < jumpers.length; i++)
          JumperInRankingTile(
            jumper: jumpers[i],
            position: i + 1,
          ),
      ],
    );
  }
}
