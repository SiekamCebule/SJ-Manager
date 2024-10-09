import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/simulation/database/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/screens/simulation/large/simulation_route_main_action_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card.dart';

part 'large/__large.dart';
part 'large/__current_date_card.dart';
part 'large/__navigation_rail.dart';
part 'large/subscreens/home/__home_screen.dart';
part 'large/subscreens/home/__next_competitions_card.dart';
part 'large/subscreens/home/__team_overview_card.dart';
part 'large/subscreens/__team_screen.dart';

class SimulationRoute extends StatelessWidget {
  const SimulationRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const large = _Large();
    return const ResponsiveBuilder(
      phone: large,
      tablet: large,
      desktop: large,
      largeDesktop: large,
    );
  }
}
