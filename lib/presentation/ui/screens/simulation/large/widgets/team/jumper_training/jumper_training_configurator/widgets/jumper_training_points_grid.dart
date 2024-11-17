import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/utilities/utils/colors.dart';
import 'package:sj_manager/domain/entities/simulation/flow/training/jumper_training_config.dart';

const double _rowHeight = 26;
const double _rowWidth = 12;

class JumperTrainingPointsGrid extends StatefulWidget {
  const JumperTrainingPointsGrid({
    super.key,
    required this.maxPointsToUse,
    required this.length,
    this.initialPoints,
    required this.onChange,
  });

  final int maxPointsToUse;
  final int length;
  final Map<JumperTrainingCategory, int>? initialPoints;
  final Function(Map<JumperTrainingCategory, int> points) onChange;

  @override
  State<JumperTrainingPointsGrid> createState() => _JumperTrainingPointsGridState();
}

class _JumperTrainingPointsGridState extends State<JumperTrainingPointsGrid> {
  late final Map<JumperTrainingCategory, int> _selectedCounts;
  final _hoveredCounts = {
    JumperTrainingCategory.takeoff: 0,
    JumperTrainingCategory.flight: 0,
    JumperTrainingCategory.landing: 0,
    JumperTrainingCategory.form: 0,
  };
  var _usedPoints = 0;
  int get _availablePoints => widget.maxPointsToUse - _usedPoints;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialPoints != null ? Map.of(widget.initialPoints!) : null;
    if (initial != null && initial.values.contains(0)) {
      throw ArgumentError(
          'Initial points map should not have any zero. Minimal points value for category is 1');
    }
    _selectedCounts = initial ??
        {
          JumperTrainingCategory.takeoff: 1,
          JumperTrainingCategory.flight: 1,
          JumperTrainingCategory.landing: 1,
          JumperTrainingCategory.form: 1,
        };
    _updateUsedPoints();
  }

  void _updateUsedPoints() {
    _usedPoints = 0;
    _selectedCounts.forEach(
      (category, points) => _usedPoints += points,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyLarge;
    Widget constructLabel(String text) {
      return SizedBox(
        height: _rowHeight,
        child: Text(
          text,
          style: labelStyle,
        ),
      );
    }

    Widget constructRow({
      required JumperTrainingCategory category,
    }) {
      return _PointsRow(
        length: widget.length,
        selectedCount: _selectedCounts[category]!,
        hoveredCount: _hoveredCounts[category]!,
        availableCount: _availablePoints + _selectedCounts[category]!,
        onHover: (isHovering, hoveredIndex) {
          setState(() {
            _hoveredCounts[category] = isHovering ? hoveredIndex + 1 : 0;
          });
        },
        onSelect: (selectedIndex) {
          final newPoints = selectedIndex + 1;
          final totalPoints = _usedPoints - _selectedCounts[category]! + newPoints;

          if (totalPoints <= widget.maxPointsToUse) {
            setState(() {
              _selectedCounts[category] = newPoints;
              _updateUsedPoints();
            });
            widget.onChange(_selectedCounts);
          }
        },
      );
    }

    final translator = translate(context);

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              constructLabel(translator.takeoff),
              const Gap(3),
              constructLabel(translator.flight),
              const Gap(3),
              constructLabel(translator.landing),
              const Gap(3),
              constructLabel(translator.form),
            ],
          ),
        ),
        const Gap(10),
        Flexible(
          child: Column(
            children: [
              constructRow(category: JumperTrainingCategory.takeoff),
              const Gap(3),
              constructRow(category: JumperTrainingCategory.flight),
              const Gap(3),
              constructRow(category: JumperTrainingCategory.landing),
              const Gap(3),
              constructRow(category: JumperTrainingCategory.form),
            ],
          ),
        ),
      ],
    );
  }
}

class _PointsRow extends StatelessWidget {
  const _PointsRow({
    required this.length,
    required this.selectedCount,
    required this.hoveredCount,
    required this.availableCount,
    required this.onSelect,
    required this.onHover,
  });

  final int length;
  final int selectedCount;
  final int hoveredCount;
  final int availableCount;
  final Function(int selectedIndex) onSelect;
  final Function(bool isHovering, int hoveredIndex) onHover;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var currentIndex = 0; currentIndex < length; currentIndex++) ...[
          _Cell(
            onTap: currentIndex < availableCount
                ? () => onSelect(currentIndex)
                : null, // Dodanie zabezpieczenia dla klikania
            onHover: currentIndex < availableCount
                ? (isHovering) => onHover(isHovering, currentIndex)
                : (_) {},
            enabled: currentIndex < availableCount,
            selected: currentIndex < selectedCount,
            hovered: currentIndex < hoveredCount,
            height: _rowHeight,
            width: _rowWidth,
          ),
          const Gap(1.5),
        ]
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.onTap,
    required this.onHover,
    required this.enabled,
    required this.selected,
    required this.hovered,
    required this.height,
    required this.width,
  });

  final VoidCallback? onTap;
  final Function(bool isHovering) onHover;
  final bool enabled;
  final bool selected;
  final bool hovered;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfaceHighest = Theme.of(context).colorScheme.surfaceContainerHighest;

    final disabledColor = Theme.of(context).colorScheme.surfaceContainerLowest;
    final selectedColor = surfaceHighest.blendWithBg(brightness, -0.3);
    final hoveredColor = surfaceHighest.blendWithBg(brightness, -0.1);
    final unselectedColor = surfaceHighest;

    late Color color;

    if (selected) {
      color = selectedColor;
    } else if (!enabled) {
      color = disabledColor;
    } else if (hovered) {
      color = hoveredColor;
    } else {
      color = unselectedColor;
    }

    return Material(
      color: color,
      child: SizedBox(
        height: height,
        width: width,
        child: InkWell(
          onTap: enabled ? onTap : null,
          onHover: (isHovering) => onHover(isHovering),
        ),
      ),
    );
  }
}
