import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'SJ Manager \'24',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
