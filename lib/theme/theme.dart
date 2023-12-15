import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const primaryColor = Color(0xff2532A1);
const secondaryAccent = Color(0xffF6B700);
const primaryLight= Color(0xffD3EFFF);
const primaryLightVariant= Color(0xffFFF9D9);

const pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

class AppTheme {
  static ThemeData appTheme = ThemeData(
    primaryColor: primaryColor,
    useMaterial3: true,
    pageTransitionsTheme: pageTransitionsTheme,
    // Add this line
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryAccent,
      surfaceTint: Colors.white,
      surface: Colors.white,
      onError: Colors.red,
    ),
    fontFamily: "DMSans",
    appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarBrightness:
                Brightness.light // this makes the status bar transparent
            ),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white)),
    textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        labelSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        // labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(62)))),
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(fontStyle: FontStyle.normal)),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.white)),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(62)))),
    tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 16, fontFamily: "Roboto"),
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: Colors.white,
            ),
            insets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0))),
    chipTheme: const ChipThemeData(
        side: BorderSide(color: primaryColor),
        checkmarkColor: Colors.white,
        padding: EdgeInsets.all(20),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(12),
        ))),
    scaffoldBackgroundColor: Colors.white,
  );
}
