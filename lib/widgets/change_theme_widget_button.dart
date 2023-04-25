import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeProvider themeProvider, child) =>
          LiteRollingSwitch(
        //initial value
        value: themeProvider.isDarkMode,
        width: 105,

        textOn: 'Dark',
        textOff: 'Light',
        colorOn: Theme.of(context).colorScheme.primary,
        colorOff: Color.fromARGB(255, 190, 68, 31),
        iconOn: Icons.nightlight,
        iconOff: Icons.sunny,
        textSize: 16.0,
        onChanged: (value) {
          themeProvider.toggleTheme(value);
        },
        onDoubleTap: () {},
        onSwipe: () {},
        onTap: () {},
      ),
    );

    // Switch.adaptive(
    //   value: themeProvider.isDarkMode,
    //   onChanged: (value) {
    //     final provider = Provider.of<ThemeProvider>(context, listen: false);
    //     provider.toggleTheme(value);
    //   },
    // );
  }
}
