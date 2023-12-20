import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/theme/theme.dart';

class HomeSideMenu extends StatefulWidget {
  const HomeSideMenu({super.key});

  @override
  State<HomeSideMenu> createState() => _HomeSideMenuState();
}

class _HomeSideMenuState extends State<HomeSideMenu> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SideMenuItem> items = [
      SideMenuItem(
        title: 'Dashboard',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.home),
        badgeContent: Text(
          '3',
          style: TextStyle(color: Colors.white),
        ),
      ),
      SideMenuItem(
          title: 'Funds Transfer',
          onTap: (index, _) {
            sideMenu.changePage(index);
          },
          icon: Icon(
            Icons.monetization_on_rounded,
          )),
      SideMenuItem(
        title: 'Other Transfers',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.monetization_on_outlined),
      ),
      SideMenuItem(
        title: 'Airtime',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.network_cell),
      ),
      SideMenuItem(
        title: 'Mobile Money',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.mobile_friendly),
      ),
      SideMenuItem(
        title: 'Settings',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.settings),
      ),
      SideMenuItem(
        title: 'Exit',
        onTap: null,
        icon: Icon(Icons.exit_to_app),
      ),
    ];

    return Scaffold(
        backgroundColor: primaryLight,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              style: SideMenuStyle(backgroundColor: primaryLightVariant),
              // Page controller to manage a PageView
              controller: sideMenu,
              // Will shows on top of all items, it can be a logo or a Title text
              title: Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset('assets/images/main_logo.png')),
              // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
              footer: Text('Copyright 2023. Housing Finance Bank'),
              // Notify when display mode changed
              onDisplayModeChanged: (mode) {
                print(mode);
              },
              // List of SideMenuItem to show them on SideMenu
              items: items,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  Container(
                    child: Container(
                        // child: Text('Dashboard'),
                        ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Funds Transfer'),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Other Transfers'),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Airtime'),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Mobile Money'),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Settings'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
