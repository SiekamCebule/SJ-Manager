import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/utils/translating.dart';

class CountryTeamProfileSubteamsNotAvailable extends StatelessWidget {
  const CountryTeamProfileSubteamsNotAvailable({
    super.key,
    required this.currentDate,
    required this.settingUpSubteamsDeadline,
  });

  final DateTime currentDate;
  final DateTime settingUpSubteamsDeadline;

  static final dateFormat = DateFormat("d MMM");

  @override
  Widget build(BuildContext context) {
    final futureDateText = sjmFutureDateDescription(
      context: context,
      currentDate: currentDate,
      targetDate: settingUpSubteamsDeadline,
    ).toLowerCase();
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Ustalone kadry pojawią się ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextSpan(
              text: futureDateText,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextSpan(
              text: ' (${dateFormat.format(settingUpSubteamsDeadline)})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
