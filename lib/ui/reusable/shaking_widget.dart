import 'package:flutter/material.dart';

class ShakingWidget extends StatefulWidget {
  const ShakingWidget({
    super.key,
    required this.shakeDuration,
    this.curve = Curves.linear,
    required this.child,
    this.shakeRange = 0.05,
  });

  final Widget child;
  final Duration shakeDuration;
  final Curve curve;
  final double shakeRange;

  @override
  State<ShakingWidget> createState() => ShakingWidgetState();
}

class ShakingWidgetState extends State<ShakingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> turns;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.shakeDuration ~/ 3,
    );
    turns = controller.drive(
      Tween(begin: -widget.shakeRange, end: widget.shakeRange),
    );
    Future.microtask(() async {
      controller.value = 0.5;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: turns,
      child: widget.child,
    );
  }

  Future<void> shake() async {
    await _performShaking();
  }

  Future<void> _performShaking() async {
    await _toRight();
    await _toLeft();
    await _toCenter();
  }

  Future<void> _toRight() async {
    await _animateTo(1.0);
  }

  Future<void> _toLeft() async {
    await _animateTo(0.0);
  }

  Future<void> _toCenter() async {
    await _animateTo(0.5);
  }

  Future<void> _animateTo(double target) async {
    await controller.animateTo(target, curve: widget.curve);
  }
}
