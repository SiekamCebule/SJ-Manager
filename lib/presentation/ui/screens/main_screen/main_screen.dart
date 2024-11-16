import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/domain/use_cases/ui/main_menu/create_new_simulation_command.dart';
import 'package:sj_manager/domain/use_cases/ui/main_menu/show_simulation_wizard_command.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/data/models/game_variants/game_variant.dart';
import 'package:sj_manager/data/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/data/models/simulation/user_simulation/user_simulation_model.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/editable_items_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_repo.dart';
import 'package:sj_manager/presentation/ui/dialogs/main_menu/choose_simulation_dialog.dart';
import 'package:sj_manager/presentation/ui/dialogs/main_menu/select_game_variant_to_edit_dialog.dart';
import 'package:sj_manager/presentation/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/widgets/generic/main_menu_only_title_button.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/large/widgets/generic/main_menu_text_content_button_body.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/widgets/shaking_app_title.dart';
import 'package:sj_manager/utilities/utils/show_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

part 'large/__large.dart';
part 'large/widgets/__buttons_table.dart';
part 'large/widgets/__background_image.dart';
part 'large/widgets/buttons/main_menu_continue_button.dart';
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
