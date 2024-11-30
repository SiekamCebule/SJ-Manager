import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/helpers.dart';

class TeamScreenPersonalCoachBottomBar extends StatelessWidget {
  const TeamScreenPersonalCoachBottomBar({
    super.key,
    required this.traineesCount,
    required this.traineesLimit,
    required this.searchForCandidates,
    required this.managePartnerships,
  });

  final int traineesCount;
  final int traineesLimit;
  final VoidCallback searchForCandidates;
  final VoidCallback managePartnerships;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Row(
        children: [
          const Spacer(),
          Column(
            children: [
              Text(
                '$traineesCount/$traineesLimit',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(2),
              Text(
                translate(context).trainees(10), // many
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Gap(20),
          TextButton(
            onPressed: searchForCandidates,
            child: const Text('Rozpocznij współpracę'),
          ),
          const Gap(10),
          TextButton(
            onPressed: traineesCount > 0 ? managePartnerships : null,
            child: const Text('Zarządzaj współpracami'),
          ),
        ],
      ),
    );
  }
}
