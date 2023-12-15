import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/dashboard/header_section.dart';
import 'package:hfbbank/screens/home/components/acc_bal_sec.dart';
import 'package:hfbbank/screens/home/components/advert_section.dart';
import 'package:hfbbank/screens/home/components/modules_section.dart';
import 'package:hfbbank/screens/home/headers/drawer.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';
import 'package:hfbbank/screens/home/home_web/home.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:pinput/pinput.dart';

import '../headers/card.dart';
import 'bar_chart.dart';
import 'cred_deb_card.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  var firstName;
  final _prefs = CommonSharedPref();


  getName()async{
    firstName = await CommonSharedPref().getUserData(UserAccountData.FirstName.name);
  }
  List<BankAccount> accounts = [
    BankAccount(
        bankAccountId: "bankAccountId",
        groupAccount: false,
        defaultAccount: true),
    BankAccount(
        bankAccountId: "bankAccountId",
        groupAccount: false,
        defaultAccount: true)
  ];
  @override
  void initState() { getName();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // var firstName=  await _prefs.getUserData(UserAccountData.FirstName.toString());
    print('name>>>>>$firstName');
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return isDesktop
        ? HomeSideMenu()
        : Scaffold(
            drawer: mainDrawer(context),
            backgroundColor: primaryColor,
            body: SingleChildScrollView(
                child: Column(children: [
              const SizedBox(
                height: 20,
              ),

              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                     HeaderSectionApp(header: 'Good Morning'),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      child: Container(
                        // height: MediaQuery.of(context).size.height,
                        color: primaryLight,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 20, bottom: 20),
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: const AccBalance()),
                            Container(
                              height: 200,
                              child:
                                 GlassmorphismCreditCard())

                      ,

                            const AdvertSection(),
                            const Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: Text(
                                  'Payment List',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Modules()
                          ],
                        ),
                      ),
                    )
                  ]))
              // child:
            ])));

    // );
    // );
  }
}
