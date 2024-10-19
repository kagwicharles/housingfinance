import 'package:craft_dynamic/craft_dynamic.dart';
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
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white)),
    textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: "DMSans"),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "DMSans"),
        labelSmall: TextStyle(
          fontSize: 12,
          color: primaryColor,
          fontWeight: FontWeight.w400,
            fontFamily: "DMSans"
        ),
        // labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontFamily: "DMSans"
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(44)))),
    inputDecorationTheme: const InputDecorationTheme(
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: "DMSans", color: Colors.grey),
      hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: "DMSans", color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.never
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(fontSize: 12, fontFamily: "DMSans", color: primaryColor)),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.white)),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(62)))),
    tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 16, fontFamily: "DMSans"),
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: Colors.white,
            ),
            insets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0))),
    chipTheme: const ChipThemeData(
      selectedColor: primaryColor,
        side: BorderSide(color: primaryColor),
        checkmarkColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(12),
        ))),
    scaffoldBackgroundColor: Colors.white,
  );
}
