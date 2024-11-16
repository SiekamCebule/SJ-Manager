import 'package:flutter/material.dart';
import 'package:sj_manager/presentation/ui/responsiveness/layout_type.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.phone,
    required this.tablet,
    required this.desktop,
    required this.largeDesktop,
  });

  final Widget phone;
  final Widget tablet;
  final Widget desktop;
  final Widget largeDesktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final layoutType = LayoutType.fromConstraints(constraints);
      return switch (layoutType) {
        LayoutType.forPhone => phone,
        LayoutType.forTablet => tablet,
        LayoutType.forDesktop => desktop,
        LayoutType.forLargeDesktop => largeDesktop,
      };
    });
  }
}
