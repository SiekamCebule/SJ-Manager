import 'package:flutter/material.dart';

enum LayoutType {
  forPhone,
  forTablet,
  forDesktop,
  forLargeDesktop;

  static LayoutType fromConstraints(BoxConstraints constraints) {
    return fromSize(constraints.biggest);
  }

  static LayoutType fromSize(Size size) {
    for (var layoutType in layoutBreakpoints.keys) {
      final breakpoint = layoutBreakpoints[layoutType]!;
      if (size.width <= breakpoint) {
        return layoutType;
      }
    }
    return LayoutType.forLargeDesktop;
  }
}

const layoutBreakpoints = {
  LayoutType.forPhone: 480,
  LayoutType.forTablet: 1024,
  LayoutType.forDesktop: 1440,
};
