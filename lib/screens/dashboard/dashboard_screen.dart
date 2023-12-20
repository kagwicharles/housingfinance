import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/dashboard/branch_locations.dart';
import 'package:hfbbank/screens/dashboard/contacts_section.dart';
import 'package:hfbbank/screens/dashboard/header_section.dart';
import 'package:hfbbank/screens/dashboard/menu_section.dart';
import 'package:hfbbank/screens/home/components/advert_section.dart';
import 'package:hfbbank/screens/home/headers/drawer.dart';
import 'package:hfbbank/screens/rao/remote_account_opening.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:hfbbank/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'tabs_section.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final ProfileRepository _profileRepository = ProfileRepository();
  bool isActive = false;
  var firstName;

  getAppActivationStatus() {
    _profileRepository.checkAppActivationStatus().then((value) {
      setState(() {
        debugPrint('Activation Status>>$value');
        isActive = value;
      });
    });
  }

  getName() async {
    firstName =
        await CommonSharedPref().getUserData(UserAccountData.FirstName.name);
  }

  @override
  void initState() {
    getName();
    getAppActivationStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isTwoPane = MediaQuery.of(context).size.width > 600;

    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        child: DefaultTabController(
            length: 4,
            child: Scaffold(
              // drawer: mainDrawer(context),
              body: SafeArea(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const HeaderSection(),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: Container(
                    // color: primaryLight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: primaryLight,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: SingleChildScrollView(
                      // padding: const EdgeInsets.all(24),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, top: 24),
                                child: Text(
                                  Util.getGreeting(),
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.grey[600]),
                                  softWrap: true,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Text(
                                  "${firstName ?? ""}",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: MenuSection(
                                  isActive: isActive,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                color: primaryLightVariant,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24, right: 24, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AdvertSection(),
                                        const Text(
                                          "Bank With Us",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    ontap: () {
                                                      Get.to(() => const RAO());
                                                    },
                                                    image:
                                                        "assets/images/forex.png",
                                                    color: Colors.white),
                                                const Text(
                                                  'Open Account',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    image:
                                                        "assets/images/calc.png",
                                                    color: Colors.white),
                                                const Text(
                                                  'Loan Calculator',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    // title: "Mobile Banking",
                                                    image:
                                                        "assets/images/pLoans.png",
                                                    ontap: () {
                                                      // context.navigate(const ActivationScreen());
                                                    },
                                                    color: Colors.white),
                                                const Text(
                                                  'Personal Loans',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    image:
                                                        "assets/images/treasury.png",
                                                    color: Colors.white),
                                                const Text(
                                                  'Treasury Bonds',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    image:
                                                        "assets/images/bills.png",
                                                    color: Colors.white),
                                                const Text(
                                                  'Treasury Bills',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    // title: "Mobile Banking",
                                                    image:
                                                        "assets/images/homeL.png",
                                                    ontap: () {
                                                      // context.navigate(const ActivationScreen());
                                                    },
                                                    color: Colors.white),
                                                const Text(
                                                  'Home Loans',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          "Contact Us",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    ontap: () {
                                                      launchWhatsAppUri(
                                                          "+256771888755",
                                                          "Hi, I need help");
                                                    },
                                                    image:
                                                        "assets/images/cc.png",
                                                    color: Colors.transparent),
                                                const Text(
                                                  'Chat',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    ontap: () {
                                                      _launchPhoneCaller(
                                                          '0800211082');
                                                    },
                                                    image:
                                                        "assets/images/call.png",
                                                    color: Colors.transparent),
                                                const Text(
                                                  'Call',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    // title: "Mobile Banking",
                                                    image:
                                                        "assets/images/mail.png",
                                                    ontap: () {
                                                      context.navigate(
                                                          Locations());
                                                    },
                                                    color: Colors.transparent),
                                                const Text(
                                                  'Locations',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                TopDashItem(
                                                    // title: "Mobile Banking",
                                                    image:
                                                        "assets/images/faq.png",
                                                    ontap: () {
                                                      context.navigate(
                                                          const ContactUs());
                                                    },
                                                    color: Colors.transparent),
                                                const Text(
                                                  'More >',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ))),

                            // const TabSection(),
                            // const ContactSection()
                          ]),
                    ),
                  ))
                ]),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            )));
  }

  launchWhatsAppUri(String phone, String message) async {
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: message,
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launchUrl(link.asUri());
  }

  void _launchPhoneCaller(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch Phone Caller';
    }
  }
}
