import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/view/shared/custom_switch.dart';

import '../../app/global_provider.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer(builder: (context, ref, child) {
              final themeMode = ref.watch(themeController);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/show.svg",
                        color: themeMode == ThemeMode.light
                            ? Colors.grey[800]
                            : AppColors.offWhite,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  CustomSwitch(
                    value: themeMode == ThemeMode.light ? false : true,
                    enableColor: AppColors.primary,
                    disableColor: const Color.fromARGB(40, 120, 120, 128),
                    onChanged: (val) {
                      ref.read(themeController.notifier).updateThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                    },
                  )
                  // Consumer(builder: (context, ref, child) {
                  //   final themeMode = ref.watch(themeController);

                  //   return CustomSwitch(
                  //     value: themeMode == ThemeMode.light ? false : true,
                  //     enableColor: AppColors.primary,
                  //     disableColor: const Color.fromARGB(40, 120, 120, 128),
                  //     onChanged: (val) {
                  //       ref.read(themeController.notifier).updateThemeMode(
                  //             val ? ThemeMode.dark : ThemeMode.light,
                  //           );
                  //     },
                  //   );
                  // }),
                ],
              );
            }),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.visibility_outlined,
          //   ),
          //   horizontalTitleGap: 0,
          //   title: const Text("Dark Mode"),
          //   trailing: Consumer(builder: (context, ref, child) {
          //     final themeMode = ref.watch(themeController);

          //     return CustomSwitch(
          //       value: themeMode == ThemeMode.light ? false : true,
          //       enableColor: AppColors.primary,
          //       disableColor: const Color.fromARGB(40, 120, 120, 128),
          //       onChanged: (val) {
          //         ref.read(themeController.notifier).updateThemeMode(
          //               val ? ThemeMode.dark : ThemeMode.light,
          //             );
          //       },
          //     );
          //   }),
          // ),
        ],
      ),
    );
  }
}
