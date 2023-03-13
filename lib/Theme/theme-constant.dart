import 'package:flutter/material.dart';
import 'package:mybixbite/Theme/app-theme.dart';

const COLOR_PRIMARY = Colors.deepOrangeAccent;
const COLOR_ACCENT = Colors.orange;

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: COLOR_PRIMARY,
    appBarTheme: const AppBarTheme(backgroundColor: COLOR_ACCENT),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: COLOR_ACCENT),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(350.0, 50.0)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
            backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT))),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.black));

ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
    brightness: Brightness.dark,
    accentColor: Colors.white,
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all<Color>(Colors.grey),
      thumbColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(350.0, 50.0)),
            //fixedSize: MaterialStateProperty.all<Size>(Size(400, 300)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            overlayColor: MaterialStateProperty.all<Color>(Colors.black26))),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white));
