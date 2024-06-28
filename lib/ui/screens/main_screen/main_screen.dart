import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/screens/main_screen/app_title.dart';
import 'package:sj_manager/ui/screens/main_screen/buttons/main_menu_continue_button.dart';
import 'package:sj_manager/ui/screens/main_screen/buttons/main_menu_load_simulation_button.dart';
import 'package:sj_manager/ui/screens/main_screen/buttons/main_menu_new_simulation_button.dart';
import 'package:sj_manager/ui/screens/main_screen/buttons/main_menu_settings_button.dart';
import 'package:sj_manager/ui/screens/main_screen/main_menu_background_image.dart';

part 'large/__large.dart';

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
