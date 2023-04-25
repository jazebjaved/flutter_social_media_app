import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    fontFamily: 'Poppins-Regular',
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(primary: Color(0xff03dac6)),
    iconTheme: IconThemeData(
      color: Color(0xff03dac6),
    ),
    cardTheme: CardTheme(color: Colors.grey[900]),
  );

  static final lightTheme = ThemeData(
    fontFamily: 'Poppins-Regular',
    scaffoldBackgroundColor: Color.fromARGB(210, 255, 255, 255),
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Color(0xFFEE0F38),
    ),
    iconTheme: IconThemeData(color: Color(0xFFEE0F38)),
    // iconButtonTheme: IconButtonThemeData(
    //   style: ButtonStyle(
    //       foregroundColor: MaterialStateProperty.all<Color>(
    //           Color.fromARGB(255, 224, 45, 45)),
    //       backgroundColor: MaterialStateProperty.all<Color>(
    //           Color.fromARGB(255, 224, 45, 45)),
    //       iconColor: MaterialStateProperty.all<Color>(
    //           Color.fromARGB(255, 224, 45, 45))),
    // ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFEE0F38), foregroundColor: Colors.white),
  );
}
