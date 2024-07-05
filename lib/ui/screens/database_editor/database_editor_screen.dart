import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/bloc/database_editing/database_editing_cubit.dart';
import 'package:sj_manager/enums/database_item_type.dart';
import 'package:sj_manager/repositories/database_items/predefined_types.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/assets/icons.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/appropiate_db_item_list_tile.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/jumper_editor/jumper_editor.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/reorderable_database_items_list.dart';

part 'large/_large.dart';
part 'large/widgets/__body.dart';
part 'large/widgets/__appropiate_item_editor.dart';

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
