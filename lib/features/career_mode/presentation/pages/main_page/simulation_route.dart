import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/general_utils/filtering/filter/generic_filters.dart';
import 'package:sj_manager/core/general_utils/filtering/search_filter_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/manager_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/my_team_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/simulation_config_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/teams_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/manage_partnerships/show_manage_partnerships_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/simulation_cubit.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/search_for_charges_jumpers/show_search_for_charges_dialog.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/features/career_mode/presentation/bloc/ui/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
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
import 'package:sj_manager/features/career_mode/presentation/dialogs/set_up_subteams/show_subteams_setting_up_personal_coach_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/trainings/set_up_trainings/set_up_trainings_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/trainings/set_up_trainings/show_set_up_trainings_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/simulation_exit/simulation_exit_are_you_sure_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/set_up_subteams/subteams_setting_up_help_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/trainings/training_tutorial_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/trainings/trainings_are_not_set_up_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/dialogs/trainings/trainings_setting_up_help_dialog.dart';
import 'package:sj_manager/features/career_mode/presentation/pages/main_page/simulation_route_main_action_button.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/jumper/jumper_in_team_overview_card.dart';

import 'package:sj_manager/features/career_mode/presentation/widgets/jumper_training_manager_row/jumper_training_manager_row.dart';
import 'package:sj_manager/features/career_mode/presentation/pages/team_page/team_overview_card_no_jumpers_info_widget.dart';
import 'package:sj_manager/features/career_mode/presentation/pages/team_page/team_screen_no_jumpers_info_widget.dart';
import 'package:sj_manager/features/career_mode/presentation/pages/team_page/team_screen_personal_coach_bottom_bar.dart';
import 'package:sj_manager/features/career_mode/presentation/pages/team_page/team_summary_card.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/country_team_profile/country_team_overview_list_tile.dart';
import 'package:sj_manager/features/career_mode/presentation/widgets/country_team_profile/country_team_profile_widget.dart';
import 'package:sj_manager/core/general_utils/colors.dart';
import 'package:sj_manager/core/general_utils/filtering.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';
import 'package:sj_manager/core/general_utils/translating.dart';

part 'large/__large.dart';
part '__current_date_card.dart';
part '__upcoming_simulation_action_card.dart';
part 'large/__navigation_rail.dart';
part 'large/__top_panel.dart';
part '../home_page/__home_page.dart';
part '../home_page/__next_competitions_card.dart';
part '../home_page/__team_overview_card.dart';
part '../team_page/__team_page.dart';
part '../teams_page/__teams_page.dart';
part '../jumpers_page/__jumpers_page.dart';

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
