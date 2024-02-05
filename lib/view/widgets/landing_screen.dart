import 'package:azkar/controller/controllers/app_controller.dart';
import 'package:azkar/view/quran/quran_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azkar/controller/utils/themedata.dart';
import 'package:azkar/view/hadith/hadith_and_azkar.dart';
import 'package:azkar/view/qibla/qibla.dart';
import 'package:azkar/view/quran/quran_screen.dart';
import 'package:azkar/view/radio/radio_screen.dart';
import 'package:azkar/view/tasbeeh/tasbeeh_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = "landing-screen";

  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;

  List pages = [
    const QuranScreen(),
    const HadithAndAzkarScreen(),
    const TasbeehScreen(),
    const QiblaScreen(),
    const RadioScreen(),
  ];

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppController>(context);
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: provider.isDarkTheme()
            ? ThemeDataProvider.primaryDarkThemeColor
            : ThemeDataProvider.primaryLightThemeColor,
        selectedItemColor: ThemeDataProvider.mainAppColor,
        unselectedItemColor: provider.isDarkTheme()
            ? ThemeDataProvider.textDarkThemeColor
            : ThemeDataProvider.textLightThemeColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp), label: 'quran'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined), label: 'hadeth'),
          BottomNavigationBarItem(
              icon: Icon(Icons.rounded_corner), label: 'tasbeeh'),
          BottomNavigationBarItem(
              icon: Icon(Icons.compass_calibration_outlined), label: 'qiblah'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
        ],
      ),
    );
  }
}
