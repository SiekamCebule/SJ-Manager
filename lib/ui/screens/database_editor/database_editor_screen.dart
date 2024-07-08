import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/bloc/database_editing/cubits/database_items_type_cubit.dart';
import 'package:sj_manager/bloc/database_editing/cubits/local_db_repos_cubit.dart';
import 'package:sj_manager/bloc/database_editing/cubits/local_db_is_changed_cubit.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_cubit.dart';
import 'package:sj_manager/bloc/database_editing/repos/default_items_repository.dart';
import 'package:sj_manager/bloc/database_editing/repos/filters_repository.dart';
import 'package:sj_manager/bloc/database_editing/repos/local_db_repos_repository.dart';
import 'package:sj_manager/bloc/database_editing/repos/selected_indexes_repository.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/filters/jumpers_filter.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_api.dart';
import 'package:sj_manager/repositories/database_items/database_items_repository.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/assets/icons.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/reusable/countries_dropdown.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/database_editor_unsaved_changes_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropiate_db_item_list_tile.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/jumper_editor/jumper_editor.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/reorderable_database_items_list.dart';

part 'large/_large.dart';
part 'large/widgets/__body.dart';
part 'large/widgets/__appropiate_item_editor.dart';
part 'large/widgets/__app_bar.dart';
part 'large/widgets/__bottom_app_bar.dart';
part 'large/widgets/filters/__for_jumpers.dart';

class DatabaseEditorScreen extends StatelessWidget {
  const DatabaseEditorScreen({super.key});

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
