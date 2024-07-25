import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:rxdart/streams.dart';
import 'package:sj_manager/bloc/database_editing/database_items_type_cubit.dart';
import 'package:sj_manager/bloc/database_editing/copied_local_db_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/bloc/database_editing/local_db_filtered_items_cubit.dart';
import 'package:sj_manager/filters/hills/hill_matching_algorithms.dart';
import 'package:sj_manager/filters/jumpers/jumper_matching_algorithms.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/models/db/hill/hill_type_by_size.dart';
import 'package:sj_manager/filters/hills/hills_filter.dart';
import 'package:sj_manager/l10n/hill_parameters_translations.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/enums/db_editable_item_type.dart';
import 'package:sj_manager/filters/jumpers/jumpers_filter.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/models/db/sex.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_filters_repository.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';
import 'package:sj_manager/ui/assets/icons.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/database_item_editors/hill_editor.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/animations/animated_visibility.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/countries_dropdown.dart';
import 'package:sj_manager/ui/reusable_widgets/filtering/search_text_field.dart';
import 'package:sj_manager/ui/reusable_widgets/menu_entries/predefined_reusable_entries.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/database_editor_unsaved_changes_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/database_successfully_saved_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/dialogs/selected_db_is_not_valid_dialog.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropiate_db_item_list_tile.dart';
import 'package:sj_manager/ui/database_item_editors/jumper_editor.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/database_items_list.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/filtering_countries.dart';
import 'package:sj_manager/utils/single_where_type.dart';

part 'large/__large.dart';
part 'large/widgets/__body.dart';
part 'large/widgets/__appropiate_item_editor.dart';
part 'large/widgets/__app_bar.dart';
part 'large/widgets/__bottom_app_bar.dart';
part 'large/widgets/filters/__for_jumpers.dart';
part 'large/widgets/filters/__for_hills.dart';
part 'large/widgets/__add_fab.dart';
part 'large/widgets/__remove_fab.dart';
part 'large/widgets/__items_list.dart';
part 'large/widgets/__animated_editor.dart';
part 'large/widgets/__save_as_button.dart';
part 'large/widgets/__load_button.dart';

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
