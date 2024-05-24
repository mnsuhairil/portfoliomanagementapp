import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: const Color(0xFF414C82), // Updated background color
  appBarTheme: const AppBarTheme(
    color: Color(0xFF414C82), // Updated app bar color
    centerTitle: true,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white, // Drawer background color
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.blue[900]), // Text color
  ),
  cardTheme: const CardTheme(
    color: Colors.white, // Card background color
    elevation: 4, // Card elevation
    margin: EdgeInsets.symmetric(horizontal: 8.0), // Card margin
  ),
  iconTheme: const IconThemeData(
    color: Color(0x008999d7), // Icon color
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue, // FAB background color
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue), // Border color
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue, // Button color
    textTheme: ButtonTextTheme.primary,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue, // Text button color
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Elevated button color
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue, // Outlined button color
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.blue, // Bottom navigation bar background color
    selectedItemColor: Colors.white, // Selected item color
    unselectedItemColor: Colors.white.withOpacity(0.5), // Unselected item color
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.blue, // Tab label color
    unselectedLabelColor: Colors.blue[100], // Unselected tab label color
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.blue, // Divider color
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.blue, // Active track color
    inactiveTrackColor: Colors.blue[100], // Inactive track color
    thumbColor: Colors.blue, // Thumb color
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white, // Dialog background color
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.blue, // Snack bar background color
    contentTextStyle: TextStyle(color: Colors.white), // Snack bar text color
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // Bottom sheet background color
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white, // Popup menu color
  ),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Colors.white, // Time picker background color
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue, // Text selection cursor color
    selectionColor: Colors.blue[100], // Text selection color
    selectionHandleColor: Colors.blue, // Text selection handle color
  ),
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: Colors.blue, // Navigation rail background color
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
