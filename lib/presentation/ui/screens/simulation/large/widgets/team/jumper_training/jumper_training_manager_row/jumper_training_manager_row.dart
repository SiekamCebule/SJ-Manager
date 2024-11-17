import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/domain/entities/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/large/widgets/team/jumper/jumper_simple_list_tile.dart';
import 'package:sj_manager/presentation/ui/screens/simulation/large/widgets/team/jumper_training/jumper_training_configurator/jumper_training_configurator.dart';

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
  SimulationJumper? _selectedJumper;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
    final dbHelper = context.read<SimulationDatabaseHelper>();
    final jumpers = dbHelper.managerJumpers;

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
                        levelDescription: jumper.reports.levelReport?.levelDescription,
                        selected: _selectedJumper == jumper,
                        leading: JumperSimpleListTileLeading.jumperImage,
                        trailing: JumperSimpleListTileTrailing.countryFlag,
                        onTap: () {
                          setState(() {
                            if (_selectedJumper == jumper) {
                              _selectedJumper = null;
                            } else {
                              _selectedJumper = jumper;
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
                  child: _selectedJumper != null
                      ? Builder(builder: (context) {
                          return JumperTrainingConfigurator(
                            jumper: _selectedJumper!,
                            trainingConfig: _selectedJumper!.trainingConfig!,
                            onTrainingChange: (trainingConfig) {
                              SimulationDatabaseUseCases(database: database)
                                  .changeJumperTraining(
                                jumper: _selectedJumper!,
                                config: trainingConfig,
                              );
                            },
                            weeklyTrainingReport:
                                _selectedJumper!.reports.weeklyTrainingReport,
                            monthlyTrainingReport:
                                _selectedJumper!.reports.monthlyTrainingReport,
                          );
                        })
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Aby zarządzać treningiem, zaznacz zawodnika/zawodniczkę po lewej stronie',
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
