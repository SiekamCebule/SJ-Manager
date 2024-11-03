import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/screens/settings/widgets/app_color_scheme_dropdown.dart';
import 'package:sj_manager/ui/screens/settings/widgets/app_theme_brigthness_dropdown.dart';
import 'package:sj_manager/ui/screens/settings/widgets/go_to_training_analyzer_button.dart';
import 'package:sj_manager/ui/screens/settings/widgets/language_dropdown.dart';

part 'large/__large.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
