import 'package:flutter/material.dart';
import 'package:sj_manager/ui/responsiveness/responsive_builder.dart';

part 'large/__large.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const large = _Large();
    return const ResponsiveBuilder(
      phone: large,
      tablet: large,
      desktop: large,
      largeDesktop: large,
    );
  }
}
