import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/presentation/bloc/training_analyzer/training_analyzer_cubit.dart';
import 'package:sj_manager/utilities/extensions/set_toggle.dart';
import 'package:sj_manager/data/models/training_analyzer/actions.dart';
import 'package:sj_manager/data/models/training_analyzer/chart_data_category.dart';
import 'package:sj_manager/data/models/training_analyzer/training_analyzer_result.dart';
import 'package:sj_manager/presentation/ui/dialogs/simple_help_dialog.dart';
import 'package:sj_manager/presentation/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/help_icon_button.dart';
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
