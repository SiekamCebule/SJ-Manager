import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/commands/simulation/common/change_jumper_training_command.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/jumper_training_configurator.dart';

class JumperTrainingManagerRow extends StatefulWidget {
  const JumperTrainingManagerRow({
    super.key,
    required this.noJumpersWidget,
  });

  final Widget noJumpersWidget;

  @override
  State<JumperTrainingManagerRow> createState() => _JumperTrainingManagerRowState();
}

class _JumperTrainingManagerRowState extends State<JumperTrainingManagerRow> {
  Jumper? _selectedJumperInTrainingMode;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final dbHelper = context.read<SimulationDatabaseHelper>();
    final jumpers = dbHelper.managerJumpers;

    final dynamicParams = database.jumperDynamicParams[_selectedJumperInTrainingMode];

    return jumpers.isNotEmpty
        ? Row(
            children: [
              SizedBox(
                width: 400,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: ListView.builder(
                    itemCount: jumpers.length,
                    itemBuilder: (context, index) {
                      final jumper = jumpers[index];
                      return JumperSimpleListTile(
                        jumper: jumper,
                        subtitle: JumperSimpleListTileSubtitle.levelDescription,
                        levelDescription:
                            database.jumperReports[jumper]!.levelReport?.levelDescription,
                        selected: _selectedJumperInTrainingMode == jumper,
                        leading: JumperSimpleListTileLeading.jumperImage,
                        trailing: JumperSimpleListTileTrailing.countryFlag,
                        onTap: () {
                          setState(() {
                            if (_selectedJumperInTrainingMode == jumper) {
                              _selectedJumperInTrainingMode = null;
                            } else {
                              _selectedJumperInTrainingMode = jumper;
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: _selectedJumperInTrainingMode != null
                      ? Builder(builder: (context) {
                          return JumperTrainingConfigurator(
                            jumper: _selectedJumperInTrainingMode!,
                            trainingConfig: dynamicParams!.trainingConfig!,
                            dynamicParams: dynamicParams,
                            onTrainingChange: (trainingConfig) {
                              ChangeJumperTrainingCommand(
                                context: context,
                                database: database,
                                jumper: _selectedJumperInTrainingMode!,
                                trainingConfig: trainingConfig,
                              ).execute();
                            },
                            weeklyTrainingReport: database
                                .jumperReports[_selectedJumperInTrainingMode]!
                                .weeklyTrainingReport,
                            monthlyTrainingReport: database
                                .jumperReports[_selectedJumperInTrainingMode]!
                                .monthlyTrainingReport,
                          );
                        })
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Aby zaarządzać treningiem, zaznacz zawodnika/zawodniczkę po lewej stronie',
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ],
          )
        : widget.noJumpersWidget;
  }
}
