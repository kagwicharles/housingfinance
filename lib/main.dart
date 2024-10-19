import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/screens/dashboard/ATMLocations.dart';
import 'package:hfbbank/screens/dashboard/AgentLocations.dart';
import 'package:hfbbank/screens/dashboard/BranchLocations.dart';
import 'package:hfbbank/screens/dashboard/check_permissions.dart';
import 'package:hfbbank/screens/home/loading_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

ProfileRepository _profileRepo = ProfileRepository();

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  _profileRepo.checkAppActivationStatus().then((value) {
    debugPrint('Activation>>>>>$value');
    // _isActive = value;
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  Hive.registerAdapter(AgentLocationAdapter());
  Hive.openBox<AgentLocation>('agentLocations');
  Hive.registerAdapter(ATMLocationAdapter());
  Hive.openBox<ATMLocation>('atmLocations');
  Hive.registerAdapter(BranchLocsAdapter());
  Hive.openBox<BranchLocs>('branchLocations');

  await checkLocationPermissions();
  bool isSkyBlueTheme = await CommonSharedPref().checkSkyBlueTheme();
  runApp(
      DynamicCraftWrapper(
        dashboard: DashBoardScreen(isSkyTheme: isSkyBlueTheme,),
        appLoadingScreen: const LoadingScreen(),
        appTimeoutScreen: DashBoardScreen(isSkyTheme: isSkyBlueTheme,),
        appInactivityScreen: DashBoardScreen(isSkyTheme: isSkyBlueTheme,),
        appTheme: AppTheme.appTheme,
      )
  );

  // runApp(
  //     ShowCaseWidget(
  //       builder: Builder(
  //         builder: (context) => DynamicCraftWrapper(
  //           dashboard: DashBoardScreen(isSkyTheme: isSkyBlueTheme,),
  //           appLoadingScreen: const LoadingScreen(),
  //           appTimeoutScreen: DashBoardScreen(isSkyTheme: isSkyBlueTheme,),
  //           appInactivityScreen: DashBoardScreen(isSkyTheme: isSkyBlueTheme,),
  //           appTheme: AppTheme.appTheme,
  //         ),
  //       ),
  //     )
  // );

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.red
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.red
    ..textColor = Colors.red
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
