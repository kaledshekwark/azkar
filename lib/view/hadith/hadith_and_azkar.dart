// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azkar/controller/utils/themedata.dart';
import 'package:azkar/view/azkar/azkar_screen.dart';
import 'package:azkar/view/hadith/hadith_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/controllers/app_controller.dart';

class HadithAndAzkarScreen extends StatefulWidget {
  const HadithAndAzkarScreen({Key? key}) : super(key: key);

  @override
  State<HadithAndAzkarScreen> createState() => _HadithAndAzkarScreenState();
}

class _HadithAndAzkarScreenState extends State<HadithAndAzkarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AppController provider = Provider.of<AppController>(context);

  List<Tab> tabs_ar = <Tab>[
    const Tab(text: "الاحاديث"),
    const Tab(text: "الاذكار"),
  ];

  List<Tab> tabs_en = <Tab>[
    const Tab(text: "Hadith"),
    const Tab(text: "Azkar"),
  ];

  List<Widget> widgets = <Widget>[
    const HadithScreen(),
    const AzkarScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widgets.length);
  }

  late bool isRTL;
  var surahsNames = [];
  var surahsVerses = [];

  @override
  Widget build(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    isRTL = currentDirection == TextDirection.rtl;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: MediaQuery.of(context).size.width > 1000
                  ? provider.isDarkTheme()
                  ? const AssetImage(
                  ThemeDataProvider.imageBackgroundDarkWeb)
                  : const AssetImage(
                  ThemeDataProvider.imageBackgroundLightWeb)
                  : provider.isDarkTheme()
                  ? const AssetImage(ThemeDataProvider.imageBackgroundDark)
                  : const AssetImage(
                  ThemeDataProvider.imageBackgroundLight),
              // opacity: 0.4,
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: const BoxDecoration(
                  color: ThemeDataProvider.mainAppColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: ThemeDataProvider.textDarkThemeColor,
                      ),
                    ),
                    TabBar(
                      indicatorColor: ThemeDataProvider.textDarkThemeColor,
                      labelColor: ThemeDataProvider.textDarkThemeColor,
                      labelStyle: const TextStyle(fontSize: 20),
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _tabController,
                      tabs: provider.isEnglish() ? tabs_en : tabs_ar,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child:
                TabBarView(controller: _tabController, children: widgets))
          ],
        ),
      ),
    );
  }
}
