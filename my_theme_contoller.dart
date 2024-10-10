import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/*
Create by Raj Jani
Simple and easy to use Theme controller with GetX 
Apply dark and light mode theme. Example cusomization is done
you cna change as per your need 
Required packages : 
  get: ^4.6.6
  google_fonts: ^6.2.1

Implematation Sample : 

  final ThemeController themeController = Get.put(ThemeController());

   Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      home: const SplashScreen(),
      themeMode: themeController.themeMode,
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
    );
  }

*/

class ThemeController extends GetxController {
  final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    textTheme: GoogleFonts.poppinsTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.poppinsTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    log('them mode channged : $_themeMode');
    Get.changeTheme(_themeMode == ThemeMode.light ? lightTheme : darkTheme);
    refresh();
  }
}
