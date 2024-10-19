import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/home_page.dart';
import 'package:hfbbank/screens/settings/profile_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import '../beneficiaryMgt/beneficiary_mgt.dart';
import '../transaction_list/transaction_list.dart';

class ScreenHome extends StatefulWidget {
  final bool isSkyBlueTheme;
  const ScreenHome({required this.isSkyBlueTheme});
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int selectedIndex = 0; // The selected tab index
  bool isSkyBlueTheme = false; // Default theme state

  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    loadThemeAndInitWidgets();
  }

  Future<void> loadThemeAndInitWidgets() async {
    isSkyBlueTheme = await CommonSharedPref().checkSkyBlueTheme();
    String firstName = await CommonSharedPref().getUserData(UserAccountData.FirstName.name);

    setState(() {
      _widgetOptions = <Widget>[
        HomePage(isSkyBlueTheme: isSkyBlueTheme, firstName: firstName,),
        BeneficiaryMgt(isSkyBlueTheme: isSkyBlueTheme),
        MyTransactions(isSkyBlueTheme: isSkyBlueTheme),
        ProfileTab(isSkyBlueTheme: isSkyBlueTheme),
      ];
    });
  }

  void _onItemTapped(int index) async {
    bool updatedIsSkyBlueTheme = await CommonSharedPref().checkSkyBlueTheme();
    String firstName = await CommonSharedPref().getUserData(UserAccountData.FirstName.name);

    setState(() {
      isSkyBlueTheme = updatedIsSkyBlueTheme;
      selectedIndex = index;

      _widgetOptions = <Widget>[
        HomePage(isSkyBlueTheme: isSkyBlueTheme, firstName: firstName,),
        BeneficiaryMgt(isSkyBlueTheme: isSkyBlueTheme),
        MyTransactions(isSkyBlueTheme: isSkyBlueTheme),
        ProfileTab(isSkyBlueTheme: isSkyBlueTheme),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width < 600;

    if (_widgetOptions.isEmpty) {
      return Container(
        color: isSkyBlueTheme
            ? primaryLight
            : primaryLightVariant,
        child: Center(
          heightFactor: MediaQuery.of(context).size.height,
          child: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,), // Show loading indicator until widget options are populated
        ),
      );
    }

    return screenSize
        ? Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: _widgetOptions, // Widgets stored in the stack
        ),
        // Center(
        //   child: _widgetOptions.elementAt(selectedIndex),
        // ),
        bottomNavigationBar: StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            initialActiveIndex: 0,
            height: 70, // Overall height of the bar
            top: -16,
            curveSize: 80,
            style: TabStyle.reactCircle, // You can try other styles
            items: [
              TabItem(icon: Icons.home_filled, title: 'Home'),
              TabItem(icon: Icons.people_alt, title: 'Beneficiaries'),
              TabItem(icon: Icons.article_outlined, title: 'Transactions'),
              TabItem(icon: Icons.settings, title: 'App Settings'),
            ],
            backgroundColor: primaryColor, // Background color of the app bar
            activeColor: Colors.white, // Color of the active icon
            color: Colors.white, // Color for inactive icons
            onTap: _onItemTapped, // Check theme and navigate
          ),
        ))
        : Container(); // Handle case for larger screens if needed
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 28;

  @override
  double get activeIconMargin => 15;

  @override
  double get iconSize => 20; // Non-active icon size

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: "Manrope",
      height: 2,
    );
  }

  @override
  EdgeInsetsGeometry get iconPadding {
    return EdgeInsets.only(
        bottom: 8);
  }
}
