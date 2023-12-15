import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/cred_deb_card.dart';
import 'package:hfbbank/screens/home/home_screen.dart';
import 'package:hfbbank/test.dart';
import 'package:hfbbank/theme/theme.dart';
import 'screens/dashboard/dashboard_screen.dart';

ProfileRepository _profileRepo = ProfileRepository();

void main() async {
  bool isTheme1 = true; // Track the current theme
  bool _isActive;

  await WidgetsFlutterBinding.ensureInitialized();

  _profileRepo.checkAppActivationStatus().then((value) {
    debugPrint('Activation>>>>>$value');
    // _isActive = value;
  });

  runApp(
      // MyApp());
      DynamicCraftWrapper(
    appInactivityScreen: const ScreenHome(),
    appLoadingScreen: const DashBoardScreen(),
    appTimeoutScreen: const DashBoardScreen(),
    dashboard: const DashBoardScreen(),
    appTheme: AppTheme.appTheme,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreDebCard(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:hfbbank/theme/themetest.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ThemeToggleDemo(),
//     );
//   }
// }
//
// class ThemeToggleDemo extends StatefulWidget {
//   @override
//   _ThemeToggleDemoState createState() => _ThemeToggleDemoState();
// }
//
// class _ThemeToggleDemoState extends State<ThemeToggleDemo> {
//   bool isTheme1 = true; // Track the current theme
//
//   void toggleTheme() {
//     setState(() {
//       isTheme1 = !isTheme1; // Toggle the theme
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: isTheme1 ? AppTheme.theme1 : AppTheme.theme2, // Use the selected theme
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Theme Toggle Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: toggleTheme,
//                 child: Text('Toggle Theme'),
//               ),
//               Text('Current Theme: ${isTheme1 ? "Theme 1" : "Theme 2"}'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
