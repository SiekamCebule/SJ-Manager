import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/training_analyzer/logic/training_analyzer_cubit.dart';
import 'package:sj_manager/core/general_utils/extensions/set_toggle.dart';
import 'package:sj_manager/core/training_analyzer/training_analyzer_actions.dart';
import 'package:sj_manager/core/training_analyzer/training_analyzer_chart_data_category.dart';
import 'package:sj_manager/core/training_analyzer/training_analyzer_result.dart';
import 'package:sj_manager/general_ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/general_ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/general_ui/reusable_widgets/help_icon_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part 'large/__large.dart';
part 'large/__dynamic_main_body.dart';
part 'large/__chart.dart';

class TrainingAnalyzerScreen extends StatelessWidget {
  const TrainingAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainingAnalyzerCubit(),
      child: const ResponsiveBuilder(
        phone: _Large(),
        tablet: _Large(),
        desktop: _Large(),
        largeDesktop: _Large(),
      ),
    );
  }
}
