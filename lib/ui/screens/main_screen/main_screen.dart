import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/screens/main_screen/large/simulation_wizard/simulation_wizard_dialog.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_card.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_only_title_button.dart';
import 'package:sj_manager/ui/screens/main_screen/large/widgets/generic/main_menu_text_content_button.dart';
import 'package:sj_manager/ui/screens/main_screen/widgets/shaking_app_title.dart';
import 'package:url_launcher/url_launcher.dart';

part 'large/__large.dart';
part 'large/widgets/__buttons_table.dart';
part 'large/widgets/__background_image.dart';
part 'large/widgets/buttons/main_menu_continue_button.dart';
part 'large/widgets/buttons/main_menu_load_simulation_button.dart';
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
