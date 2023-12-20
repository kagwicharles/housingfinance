import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/account_tab.dart';
import 'package:hfbbank/screens/home/components/home_screen_bottom_nav.dart';
import 'package:hfbbank/screens/home/components/profile_screen.dart';
import 'package:hfbbank/screens/home/components/transaction_screen.dart';
import 'package:hfbbank/theme/theme.dart';

import 'components/mini_statement.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  bool isTheme1 = true; // Track the current theme

  void toggleTheme() {
    setState(() {
      isTheme1 = !isTheme1; // Toggle the theme
    });
  }

  final _moduleRepo = ModuleRepository();
  final _profileRepository = ProfileRepository();

  var firstName;
  var lastName;
  var email;
  var ID;
  var image;
  var phone;

  getName() async {
    firstName = lastName =
        await CommonSharedPref().getUserData(UserAccountData.LastName.name);
    email = await CommonSharedPref().getUserData(UserAccountData.EmailID.name);
    ID = await CommonSharedPref().getUserData(UserAccountData.IDNumber.name);
    image =
        await CommonSharedPref().getUserData(UserAccountData.ImageUrl.name) ??
            "";
    phone = await CommonSharedPref().getUserData(UserAccountData.Phone.name);
    debugPrint(">>>${image.toString()}");
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeBottomNav(),

    // TransactionTab(),
    // Accounts(),
    Ministatement(),

    ProfileTab()
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getName();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width < 600;
    return screenSize
        ? Scaffold(
            // drawer: Drawer(),
            // appBar: AppBar(
            //   leading: InkWell(
            //     onTap: () {
            //       _profileRepository.checkMiniStatement('1100206653').then((value) {
            //         debugPrint('Balance Value>>>>>>$value');
            //         AlertUtil.showAlertDialog(context, value.toString());
            //       });
            //     },
            //     child: const Icon(Icons.menu),
            //   ),
            //   title: const Text('HFB'),
            // ),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: 'Home',
                      backgroundColor: primaryColor),
                  // BottomNavigationBarItem(
                  //     icon: Icon(Icons.monetization_on),
                  //     // activeIcon: Icon(Icons.account_balance),
                  //     label: 'Transaction',
                  //     backgroundColor: primaryColor
                  //     ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_balance_wallet),
                      // activeIcon: Icon(Icons.account_balance),
                      label: 'Accounts',
                      backgroundColor: primaryColor),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.account_balance_wall et_outlined),
                  //   label: 'Accounts',
                  //   backgroundColor: primaryColor,
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded),
                    label: 'Profile',
                    backgroundColor: primaryColor,
                  ),
                ],
                type: BottomNavigationBarType.shifting,
                // backgroundColor: Colors.blue,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.yellow,
                iconSize: 25,
                onTap: _onItemTapped,
                elevation: 5),
          )
        : Container();
  }

// ,

// Stack(
//   children: <Widget>[
//     Padding(
//       padding: EdgeInsets.only(bottom: bottomNavBarHeight),
//       child: bodyContainer(),
//     ),
//     Align(alignment: Alignment.bottomCenter, child: bottomNav())
//   ],
// ),
//   );
// }
}
