import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/screens/home/components/acc_bal_sec.dart';
import 'package:hfbbank/screens/home/components/last_cred_last_deb_card.dart';
import 'package:hfbbank/screens/home/components/modules_section.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:hfbbank/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../home_header.dart';
import 'custom_drawer.dart';

class HomePage extends StatefulWidget {
  final bool isSkyBlueTheme;
  final String firstName;
  const HomePage({required this.isSkyBlueTheme, required this.firstName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkIfFirstLaunch();
  }

  Future<void> _checkIfFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('firstLaunch');

    if (isFirstLaunch == null || isFirstLaunch) {
      Future.delayed(Duration(milliseconds: 500), () {
        ShowCaseWidget.of(context)?.startShowCase([_menuKey, _searchKey, _profileKey]);
      });

      await prefs.setBool('firstLaunch', false);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
          child: Scaffold(
            drawer: CustomDrawer(isSkyTheme: widget.isSkyBlueTheme),
            backgroundColor: primaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        HomeHeaderSectionApp(
                          header: Util.getGreeting(),
                          name: widget.firstName,
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: Container(
                            color: widget.isSkyBlueTheme
                                ? primaryLight
                                : primaryLightVariant,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                AccBalance(),
                                Container(
                                  color: Colors.grey[200],
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  child: LastCrDrCard(
                                    isSkyBlueTheme: widget.isSkyBlueTheme,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24, right: 10),
                                  child: Showcase(
                                    key: _searchKey,
                                    description: "These are your payments",
                                    child: Text(
                                      'Payments List',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Manrope",
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Modules(isSkyBlueTheme: widget.isSkyBlueTheme),
                                Container(
                                    height: 32,
                                  color: widget.isSkyBlueTheme
                                      ? primaryLight
                                      : primaryLightVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin  {
//   // Keys to identify the widgets
//   final GlobalKey _menuKey = GlobalKey();
//   final GlobalKey _searchKey = GlobalKey();
//   final GlobalKey _profileKey = GlobalKey();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _checkIfFirstLaunch();
//     super.initState();
//   }
//
//   Future<void> _checkIfFirstLaunch() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool? isFirstLaunch = prefs.getBool('firstLaunch');
//
//     if (isFirstLaunch == null || isFirstLaunch) {
//       WidgetsBinding.instance.addPostFrameCallback(
//             (_) => ShowCaseWidget.of(context).startShowCase([_menuKey, _searchKey, _profileKey]),
//       );
//       await prefs.setBool('firstLaunch', false);
//     }
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return AnnotatedRegion(
//             value: const SystemUiOverlayStyle(
//                 statusBarColor: Colors.transparent,
//                 statusBarBrightness: Brightness.dark,
//                 statusBarIconBrightness: Brightness.light),
//             child: Scaffold(
//               drawer: CustomDrawer(isSkyTheme: widget.isSkyBlueTheme,),
//               backgroundColor: primaryColor,
//               body: SingleChildScrollView(
//                   child: Column(children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         child: Column(children: [
//                           HomeHeaderSectionApp(
//                               header: Util.getGreeting(), name: widget.firstName),
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(30),
//                                 topRight: Radius.circular(30)),
//                             child: Container(
//                               // height: MediaQuery.of(context).size.height,
//                               color: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
//                               width: MediaQuery.of(context).size.width,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   AccBalance(),
//                                   Container(
//                                     color: Colors.grey[200],
//                                     padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
//                                     child: LastCrDrCard(isSkyBlueTheme: widget.isSkyBlueTheme,),
//                                   ),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   // AdvertSection(),
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                           left: 24, right: 10),
//                                       child: Showcase(key: _searchKey, description: "These are your payments",
//                                           child: Text(
//                                         'Payments List',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontFamily: "Manrope",
//                                             fontSize: 14),
//                                       ))),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   Modules(isSkyBlueTheme: widget.isSkyBlueTheme,)
//                                 ],
//                               ),
//                             ),
//                           )
//                         ]))
//                     // child:
//                   ]))
//             ),
//           );
//   }
// }
