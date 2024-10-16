import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TeamScreenPersonalCoachBottomBar extends StatelessWidget {
  const TeamScreenPersonalCoachBottomBar({
    super.key,
    required this.searchForCandidates,
  });

  final VoidCallback searchForCandidates;

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
                '7/15',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(2),
              Text(
                'Podopiecznych',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Gap(20),
          TextButton(
            onPressed: searchForCandidates,
            child: const Text('Wyszukaj kandydatów'),
          ),
        ],
      ),
    );
  }
}
