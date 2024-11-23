import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/general_utils/filtering/search_filter_cubit.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/manage_partnerships_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/search_for_candidates_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/set_up_subteams_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/set_up_trainings_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/simulation_exit_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/core/general_utils/filtering/matching_algorithms/jumper_matching_algorithms.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database_helper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/country_flags/country_flags_repository.dart';
import 'package:sj_manager/to_embrace/ui/database_item_editors/fields/my_search_bar.dart';
import 'package:sj_manager/general_ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/general_ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/general_ui/reusable_widgets/countries/country_flag.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/general_ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/general_ui/reusable_widgets/link_text_button.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/set_up_subteams/subteams_setting_up_personal_coach_dialog.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/set_up_trainings/set_up_trainings_dialog.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/subteams_setting_up_help_dialog.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/training_tutorial_dialog.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/trainings_are_not_set_up_dialog.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/trainings_setting_up_help_dialog.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/simulation_route_main_action_button.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_in_team_overview_card.dart';

import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_manager_row/jumper_training_manager_row.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/team_screen/team_overview_card_no_jumpers_info_widget.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/team_screen/team_screen_no_jumpers_info_widget.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/team_screen/team_screen_personal_coach_bottom_bar.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/team/team_screen/team_summary_card.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/teams/country_team_overview_list_tile.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/widgets/teams/country_team_profile/country_team_profile_widget.dart';
import 'package:sj_manager/core/general_utils/colors.dart';
import 'package:sj_manager/core/general_utils/filtering.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';
import 'package:sj_manager/core/general_utils/translating.dart';

part 'large/__large.dart';
part 'large/widgets/__current_date_card.dart';
part 'large/widgets/__upcoming_simulation_action_card.dart';
part 'large/__navigation_rail.dart';
part 'large/__top_panel.dart';
part 'large/subscreens/home/__home_screen.dart';
part 'large/subscreens/home/__next_competitions_card.dart';
part 'large/subscreens/home/__team_overview_card.dart';
part 'large/subscreens/team/__team_screen.dart';
part 'large/subscreens/teams/__teams_screen.dart';
part 'large/subscreens/jumpers/__jumpers_screen.dart';

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
