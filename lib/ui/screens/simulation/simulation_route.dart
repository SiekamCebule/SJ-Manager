import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/bloc/simulation/simulation_mode_constants.dart';
import 'package:sj_manager/bloc/simulation/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/utils/default_simulation_database_saver_to_file.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/simulation/flow/training/training_risk.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulations_registry_saver_to_file.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/personal_coach_team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/reusable_widgets/card_with_title.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/reusable_widgets/link_text_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/manage_partnerships/manage_partnerships_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/search_for_charges_jumpers/search_for_charges_jumpers_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/set_up_trainings/set_up_trainings_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/simulation_exit_are_you_sure_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/subteams_setting_up_help_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/training_tutorial_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/trainings_are_not_set_up_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/trainings_setting_up_help_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/large/simulation_route_main_action_button.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/jumper_in_team_overview_card.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_in_team_card/team_screen_jumper_card.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/team_screen/team_overview_card_no_jumpers_info_widget.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/team_screen/team_screen_no_jumpers_info_widget.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/team_screen/team_screen_personal_coach_bottom_bar.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/team_screen/team_summary_card.dart';
import 'package:sj_manager/utils/datetime.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/show_dialog.dart';
import 'package:sj_manager/utils/translating.dart';

part 'large/__large.dart';
part 'large/widgets/__current_date_card.dart';
part 'large/widgets/__upcoming_simulation_action_card.dart';
part 'large/__navigation_rail.dart';
part 'large/__top_panel.dart';
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
