part of '../../database_editor_screen.dart';

class DbEditorItemsListEmptyStateBody extends StatelessWidget {
  const DbEditorItemsListEmptyStateBody({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsState = context.watch<DatabaseItemsCubit>().state;
    if (itemsState is DatabaseItemsNonEmpty) {
      return const SizedBox();
    }
    final itemsStateEmpty = itemsState as DatabaseItemsEmpty;
    final itemsType = itemsState.itemsType;

    final onSurfaceLightColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceColor =
        onSurfaceLightColor.blendWithBg(Theme.of(context).brightness, 0.1);
    final textStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(color: onSurfaceColor);

    final contentType = itemsStateEmpty.hasValidFilters
        ? _ContentType.noSearchResults
        : _ContentType.addFirstElement;

    final content = switch (contentType) {
      _ContentType.addFirstElement => Column(
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
      _ContentType.noSearchResults => Column(
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
                  onPressed: () {
                    context.read<DbFiltersRepo>().setByGenericAndArgumentType(
                      type: itemsType,
                      filters: [],
                    );
                  },
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

enum _ContentType {
  addFirstElement,
  noSearchResults;
}
