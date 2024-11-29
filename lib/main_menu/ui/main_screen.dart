import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/presentation/bloc/game_variant_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/presentation/bloc/available_simulations_cubit.dart';
import 'package:sj_manager/features/simulations/presentation/bloc/simulation_cubit.dart';
import 'package:sj_manager/main_menu/ui/dialogs/show_simulation_wizard_command.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/general_ui/dialogs/main_menu/choose_simulation_dialog.dart';
import 'package:sj_manager/general_ui/dialogs/main_menu/select_game_variant_to_edit_dialog.dart';
import 'package:sj_manager/general_ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/general_ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/main_menu/ui/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/main_menu/ui/large/widgets/generic/main_menu_only_title_button.dart';
import 'package:sj_manager/main_menu/ui/large/widgets/generic/main_menu_text_content_button_body.dart';
import 'package:sj_manager/main_menu/ui/large/widgets/shaking_app_title.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

part 'large/__large.dart';
part 'large/widgets/__buttons_table.dart';
part 'large/widgets/__background_image.dart';
part 'large/widgets/buttons/main_menu_continue_simulation_button.dart';
part 'large/widgets/buttons/main_menu_simulations_button.dart';
part 'large/widgets/buttons/main_menu_new_simulation_button.dart';
part 'large/widgets/buttons/main_menu_settings_button.dart';
part 'large/widgets/buttons/main_menu_database_editor_button.dart';
part 'large/widgets/buttons/main_menu_acknowledgements_button.dart';
part 'large/widgets/__site_redirect_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
      phone: _Large(),
      tablet: _Large(),
      desktop: _Large(),
      largeDesktop: _Large(),
    );
  }
}
