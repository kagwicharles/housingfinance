import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/dashboard/branch_locations.dart';
import 'package:hfbbank/screens/dashboard/contacts_section.dart';
import 'package:hfbbank/screens/dashboard/header_section.dart';
import 'package:hfbbank/screens/dashboard/map_screen.dart';
import 'package:hfbbank/screens/dashboard/menu_section.dart';
import 'package:hfbbank/screens/home/components/advert_section.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:hfbbank/util/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../auth/activation_screen.dart';
import '../auth/login_screen.dart';
import '../remoteAccountOpening/rao_screen.dart';

class DashBoardScreen extends StatefulWidget {
  final bool isSkyTheme;
  const DashBoardScreen({required this.isSkyTheme});

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
        // isActive = true;
      });
    });
  }

  getName() async {
    firstName =
        await CommonSharedPref().getUserData(UserAccountData.FirstName.name);
  }

  @override
  void initState() {
    //TODO: Comment out activation data before sharing
    CommonSharedPref().addActivationData("256777026164", "1025714053");
    // CommonSharedPref().addActivationData("256700146817", "1794246760");
    // CommonSharedPref().addActivationData("254725166822", "1183220071");
    getName();
    getAppActivationStatus();
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // drawer: mainDrawer(context),
      body: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const SizedBox(
            height: 20,
          ),
          const HeaderSection(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
                // color: primaryLight,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: widget.isSkyTheme ? primaryLightVariant : primaryLight,
                    borderRadius: const BorderRadius.only(
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
                            const EdgeInsets.only(left: 20, top: 24),
                            child: Text(
                              Util.getGreeting(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "DMSans",
                                  color: Colors.grey[600]),
                              softWrap: true,
                            )),
                        Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "${firstName ?? "Customer"}",
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: "DMSans",
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        // WelcomeWidget(onProceedToLogin: () {  },),
                        // Padding(
                        //     padding:
                        //     const EdgeInsets.only(left: 24, right: 24),
                        //     child: MenuSection(
                        //       isActive: isActive, isSkyTheme: widget.isSkyTheme,
                        //
                        //     )),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     Icon(Icons.account_circle, color: Colors.white, size: 40), // Profile-like icon
                              //     const SizedBox(width: 12),
                              //     Text(
                              //       "Welcome Back!",
                              //       style: TextStyle(
                              //         fontSize: 24,
                              //         fontFamily: "DMSans",
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Text(
                                "Explore your banking needs with ease.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: "DMSans",
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 16),
                              Card(
                                margin: EdgeInsets.zero,
                                color: primaryColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeftWithFade,
                                        duration: Duration(milliseconds: 500),
                                        child: LoginScreen(isSkyBlueTheme: widget.isSkyTheme,),
                                      ),
                                    );
                                    isActive
                                        ? Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeftWithFade,
                                        duration: Duration(milliseconds: 500),
                                        child: LoginScreen(isSkyBlueTheme: widget.isSkyTheme,),
                                      ),
                                    )
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => LoginScreen(isSkyBlueTheme: widget.isSkyTheme,)))
                                        : Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeftWithFade,
                                        duration: Duration(milliseconds: 500),
                                        child: ActivationScreen(isSkyBlueTheme: widget.isSkyTheme,),
                                      ),
                                    );

                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => ActivationScreen(isSkyBlueTheme: widget.isSkyTheme,)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isActive ? "Proceed to Login" : "Proceed to App Activation",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "DMSans",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward, color: Colors.white, size: 18,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.shield, size: 16, color: Colors.grey[600],),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Banking made secure",
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600],fontFamily: "DMSans",),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: secondaryAccent,
                          height: 1,
                        ),
                        Container(
                            color: widget.isSkyTheme ? primaryLight : primaryLightVariant,
                            padding: EdgeInsets.zero,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                // const AdvertSection(),
                                // const SizedBox(height: 16),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Bank With Us",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "DMSans",
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              TopDashItem(
                                                  ontap: () {
                                                    Get.to(() => RAOScreen(isSkyBlueTheme: widget.isSkyTheme,));
                                                  },
                                                  image:
                                                  "assets/images/accop.png",
                                                  color: Colors.white),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Open Account',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
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
                                                  ontap: (){
                                                    Fluttertoast.showToast(
                                                      msg: "Coming Soon",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM, // You can change the position
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0,
                                                    );
                                                  },
                                                  color: Colors.white),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Loan Calculator',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
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
                                                    Fluttertoast.showToast(
                                                      msg: "Coming Soon",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM, // You can change the position
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0,
                                                    );
                                                  },
                                                  color: Colors.white),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Personal Loans',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: primaryColor),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  Fluttertoast.showToast(
                                                    msg: "Coming Soon",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM, // You can change the position
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 14.0,
                                                  );
                                                },
                                                child: TopDashItem(
                                                    image:
                                                    "assets/images/treasury.png",
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Treasury Bonds',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: primaryColor),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  Fluttertoast.showToast(
                                                    msg: "Coming Soon",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM, // You can change the position
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 14.0,
                                                  );
                                                },
                                                child: TopDashItem(
                                                    image:
                                                    "assets/images/bills.png",
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Treasury Bills',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: primaryColor),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  Fluttertoast.showToast(
                                                    msg: "Coming Soon",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM, // You can change the position
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 14.0,
                                                  );
                                                },child: TopDashItem(
                                                // title: "Mobile Banking",
                                                  image:
                                                  "assets/images/homeL.png",
                                                  ontap: () {
                                                    Fluttertoast.showToast(
                                                      msg: "Coming Soon",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM, // You can change the position
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0,
                                                    );
                                                  },
                                                  color: Colors.white),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Home Loans',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: primaryColor),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 32,
                                      ),
                                    ],
                                  ),),
                                const AdvertSection(),
                                const SizedBox(height: 20),
                                Container(
                                  color: primaryColor,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Contact Us",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "DMSans",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  launchWhatsAppUri(
                                                      "+256771888755",
                                                      "Hi, I need help");
                                                },
                                                child: Image.asset(
                                                  "assets/images/ont1.png",
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                ),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Chat',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  _launchPhoneCaller(
                                                      '0800211082');
                                                },
                                                child: Image.asset(
                                                  "assets/images/ont2.png",
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                ),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Call',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  _launchEmail('info@housingfinance.co.ug');
                                                },
                                                child: Image.asset(
                                                  "assets/images/mail.png",
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                ),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'E-mail',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTapDown: (TapDownDetails details) {
                                                  _showPopupMenu(context, details.globalPosition);
                                                },
                                                // onTap: (){
                                                //   context.navigate(
                                                //       Locations());
                                                // },
                                                child: Image.asset(
                                                  "assets/images/locat.png",
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                ),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'Locations',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType.rightToLeftWithFade,
                                                      duration: Duration(milliseconds: 500),
                                                      child: ContactUs(isSkyBlueTheme: widget.isSkyTheme,),
                                                    ),
                                                  );

                                                  // context.navigate(
                                                  //     ContactUs(isSkyBlueTheme: widget.isSkyTheme,));
                                                },
                                                child: Image.asset(
                                                  "assets/images/faq.png",
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                ),
                                              ),
                                              SizedBox(height: 12,),
                                              const Text(
                                                'More >',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily: "DMSans",
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),

                        // const TabSection(),
                        // const ContactSection()
                      ]),
                ),
              ))
        ]),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _showPopupMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 50, 0),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Image(
                image: AssetImage("assets/images/shop.png"),
                width: 20,
                height: 20,
                color: primaryColor,
              ),
              SizedBox(width: 8,),
              Text('Agent Locations',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Manrope",
                      fontSize: 12)),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Image(
                image: AssetImage("assets/images/bank.png"),
                width: 20,
                height: 20,
                color: primaryColor,
              ),
              SizedBox(width: 8,),
              Text('Branch Locations',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Manrope",
                      fontSize: 12)),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              const Image(
                image: AssetImage("assets/images/atm.png"),
                width: 20,
                height: 20,
                color: primaryColor,
              ),
              SizedBox(width: 8,),
              Text('ATM Locations',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Manrope",
                      fontSize: 12)),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 0:
          CommonUtils.navigateToRoute(
              context: context, widget: MapView(type: "AGENT"));
          break;
        case 1:
          CommonUtils.navigateToRoute(
              context: context, widget: MapView(type: "BRANCH"));
          break;
        case 2:
          CommonUtils.navigateToRoute(
              context: context, widget: MapView(type: "ATM"));
          break;
      }
    });
  }

  _launchEmail(String emailAddress) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    await launchUrl(_emailLaunchUri);
  }

  launchWhatsAppUri(String phone, String message) async {
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: message,
    );
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
