import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/screens/main_screen/main_menu_button.dart';

class MainMenuContinueButton extends StatelessWidget {
  const MainMenuContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuButton(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  translate(context).continueConfirm,
                  style: GoogleFonts.dosis(
                    color: Theme.of(context).colorScheme.primary,
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const Spacer(),
                Text(
                  '28-06-2024 19:05',
                  style: GoogleFonts.dosis(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Gap(20),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SvgPicture.network(
                      'https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Bulgaria.svg',
                      height: 45,
                      fit: BoxFit.fitHeight,
                    ),
                    const Gap(15),
                    Text(
                      'Bułgaria',
                      style: GoogleFonts.dosis(
                        color: Theme.of(context).colorScheme.onSurface,
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Symbols.calendar_month,
                      size: 45,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const Gap(15),
                    Text(
                      'Kwiecień \'26',
                      style: GoogleFonts.dosis(
                        color: Theme.of(context).colorScheme.onSurface,
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Symbols.person,
                      size: 45,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const Gap(15),
                    Text(
                      '5',
                      style: GoogleFonts.dosis(
                        color: Theme.of(context).colorScheme.onSurface,
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
