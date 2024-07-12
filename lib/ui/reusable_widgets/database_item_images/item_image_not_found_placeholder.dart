import 'package:flutter/material.dart';

class ItemImageNotFoundPlaceholder extends StatelessWidget {
  const ItemImageNotFoundPlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Placeholder(
        color: Theme.of(context).colorScheme.onError,
        child: const Center(
            child: Text(
          'Nie znaleziono zdjęcia',
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
