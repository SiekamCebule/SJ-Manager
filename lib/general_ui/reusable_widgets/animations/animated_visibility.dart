import 'package:flutter/material.dart';

class AnimatedVisibility extends StatefulWidget {
  const AnimatedVisibility({
    super.key,
    required this.duration,
    required this.curve,
    required this.visible,
    required this.child,
  });

  final Duration duration;
  final Curve curve;

  final bool visible;
  final Widget child;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  bool _shouldShowVisibility = false;
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _opacity.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _shouldShowVisibility = true;
      } else if (status == AnimationStatus.dismissed) {
        _shouldShowVisibility = false;
      }
    });
    _animateInAppropriateDirection();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedVisibility oldWidget) {
    if (oldWidget.visible != widget.visible) {
      _animateInAppropriateDirection();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _animateInAppropriateDirection() async {
    if (widget.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      excluding: !widget.visible,
      child: IgnorePointer(
        ignoring: !widget.visible,
        child: Visibility(
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          visible: _shouldShowVisibility,
          child: FadeTransition(
            opacity: _opacity,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
