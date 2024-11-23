import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/features/app_settings/presentation/widgets/go_to_training_analyzer_button.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/general_ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/general_ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/features/app_settings/presentation/widgets/app_color_scheme_dropdown.dart';
import 'package:sj_manager/features/app_settings/presentation/widgets/language_dropdown.dart';

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
