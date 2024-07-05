part of '../../main_screen.dart';

class _SiteRedirectButton extends StatelessWidget {
  const _SiteRedirectButton({
    required this.image,
    required this.siteAdress,
  });

  final ImageProvider image;
  final String siteAdress;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100,
      child: Material(
        elevation: 1.0,
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(image: image),
          ),
          child: InkWell(
            onTap: () async {
              await launchUrl(
                Uri.parse(siteAdress),
              );
            },
          ),
        ),
      ),
    );
  }
}
