part of '../../database_editor_page.dart';

class DbEditorItemsListEmptyStateBody extends StatelessWidget {
  const DbEditorItemsListEmptyStateBody({
    super.key,
    this.showNothing = false,
    required this.contentType,
    required this.removeFilters,
  });

  final bool showNothing;
  final DbEditorItemsListEmptyStateContentType contentType;
  final VoidCallback removeFilters;

  @override
  Widget build(BuildContext context) {
    if (showNothing) {
      return const SizedBox();
    }

    final onSurfaceLightColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceColor =
        onSurfaceLightColor.blendWithBg(Theme.of(context).brightness, 0.1);
    final textStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(color: onSurfaceColor);

    final content = switch (contentType) {
      DbEditorItemsListEmptyStateContentType.addFirstElement => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.folder_open,
              color: onSurfaceColor,
              size: UiItemEditorsConstants.emptyStateIconSize,
            ),
            const Gap(10),
            RichText(
              text: TextSpan(
                text: 'Dodaj pierwszy element korzystając z przycisku ',
                style: textStyle,
                children: [
                  WidgetSpan(
                    child: Icon(
                      Symbols.add,
                      color: onSurfaceLightColor,
                    ),
                  ),
                  TextSpan(
                    text: ' w rogu ekranu',
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      DbEditorItemsListEmptyStateContentType.noSearchResults => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.search_off,
              color: onSurfaceColor,
              size: UiItemEditorsConstants.emptyStateIconSize,
            ),
            const Gap(10),
            Column(
              children: [
                Text(
                  'Nic nie znaleźliśmy. Spróbuj zmienić lub usunąć filtry',
                  style: textStyle,
                ),
                const Gap(5),
                TextButton(
                  onPressed: removeFilters,
                  child: const Text('Usuń filtry'),
                ),
              ],
            ),
          ],
        ),
    };

    return Center(
      child: content,
    );
  }
}

enum DbEditorItemsListEmptyStateContentType {
  addFirstElement,
  noSearchResults;
}
