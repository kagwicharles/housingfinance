import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/database_helper.dart';
import '../../auth/login_screen.dart';
import '../../dashboard/contacts_section.dart';
import '../../dashboard/map_screen.dart';
import 'about_us.dart';

class CustomDrawer extends StatefulWidget {
  final bool isSkyTheme;
  const CustomDrawer({required this.isSkyTheme});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _profileRepo = ProfileRepository();
  String? firstName, phone, lastName, lastLogin;
  File? customerDPFile;
  String? dpImgString;
  bool isDpSet = false;
  Uint8List? dp;

  @override
  initState() {
    super.initState();
    getUserInfo();
  }

  @override
  void dispose() {
    // Re-enable system UI when disposing the widget
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent.
      statusBarIconBrightness: Brightness.light, // Dark icons for light background.
      statusBarBrightness: Brightness.light, // For iOS devices.
    ));
    super.dispose();
  }

  getUserInfo() async {
    await _profileRepo.getUserInfo(UserAccountData.FirstName).then((value) {
      setState(() {
        firstName = value;
      });
    });
    await _profileRepo
        .getUserInfo(UserAccountData.Phone)
        .then((value) {
      setState(() {
        phone = value;
      });
    });
    await _profileRepo.getUserInfo(UserAccountData.LastName).then((value) {
      setState(() {
        lastName = value;
      });
    });

    await _profileRepo.getUserInfo(UserAccountData.LastLoginDateTime).then((value) {
      setState(() {
        lastLogin = value;
      });
    });

    final localImageString = await DatabaseHelper.instance.getProfileImage();
    if (localImageString != null) {
      setState(() {
        dpImgString = localImageString;
        isDpSet = true;
        dp = base64Decode(localImageString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Light icons
    ),
      child: Drawer(
        backgroundColor: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 60, bottom: 24),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 16.0),
                  Container(
                    width: 80,
                    height: 80,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(40)),
                    child: isDpSet
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            50), // Half of the width or height for a circular shape
                        child: Image.memory(
                          dp!,
                          fit: BoxFit
                              .cover, // You can adjust the fit property as needed
                          width: 100, // Adjust the width and height as needed
                          height: 100,
                        ))
                        : const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                      // child: Image.network(image),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                          color: primaryColor,
                          fontFamily: "Manrope",
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      const Text(
                        "Last Login Date: ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                        ),
                      ),
                      Text(
                        "$lastLogin",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "Manrope",
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                children: <Widget>[
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Image(
                      image: AssetImage("assets/images/card.png"),
                      width: 30,
                      height: 30,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'Prepaid Card',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Manrope",
                          fontSize: 12),
                    ),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    minLeadingWidth: 30,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onTap: () {
                      launchUrl(
                          Uri.parse("https://portals.housingfinance.co.ug/consumerHFB/faces/consumerHFB.xhtml"),
                          mode: LaunchMode.externalApplication,
                          webViewConfiguration: const WebViewConfiguration(
                            enableJavaScript: false,
                          ));
                    },
                  ),
                  SizedBox(height: 8,),
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Image(
                      image: AssetImage("assets/images/shop.png"),
                      width: 30,
                      height: 30,
                      color: primaryColor,
                    ),
                    title: Text('Agent Locations',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Manrope",
                            fontSize: 12)),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    minLeadingWidth: 30,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onTap: () {
                      CommonUtils.navigateToRoute(
                          context: context, widget: MapView(type: "AGENT"));
                    },
                  ),
                  SizedBox(height: 8,),
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Image(
                      image: AssetImage("assets/images/bank.png"),
                      width: 30,
                      height: 30,
                      color: primaryColor,
                    ),
                    title: Text('Branch Locations',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Manrope",
                            fontSize: 12)),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    minLeadingWidth: 30,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onTap: () {
                      CommonUtils.navigateToRoute(
                          context: context, widget: MapView(type: "BRANCH"));
                    },
                  ),
                  SizedBox(height: 8,),
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Image(
                      image: AssetImage("assets/images/atm.png"),
                      width: 30,
                      height: 30,
                      color: primaryColor,
                    ),
                    title: const Text(
                      'ATM Locations',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Manrope",
                          fontSize: 12),
                    ),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    minLeadingWidth: 30,
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onTap: () {
                      CommonUtils.navigateToRoute(
                          context: context, widget: MapView(type: "ATM"));
                    },
                  ),
                  const SizedBox(height: 8,),
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Image(
                      image: AssetImage("assets/images/about.png"),
                      width: 30,
                      height: 30,
                      color: primaryColor,
                    ),
                    title: const Text('About Us',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Manrope",
                            fontSize: 12)),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    minLeadingWidth: 30,
                    onTap: () {
                      context.navigate(
                          AboutUsPage(isSkyBlueTheme: widget.isSkyTheme,));
                    },
                  ),
                  SizedBox(height: 8,),
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Image(
                      image: AssetImage("assets/images/contact.png"),
                      width: 30,
                      height: 30,
                      color: primaryColor,
                    ),
                    title: const Text('Contact Us',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Manrope",
                            fontSize: 12)),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    minLeadingWidth: 30,
                    onTap: () {
                      context.navigate(
                          ContactUs(isSkyBlueTheme: widget.isSkyTheme,));
                    },
                  ),
                  SizedBox(height: 34,),
                  ListTile(
                    tileColor: primaryColor,
                    leading: Icon(Icons.logout, color: Colors.white),
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "DMSans",
                            fontSize: 14)),
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color:primaryColor,
                      size: 18,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actionsPadding:
                            const EdgeInsets.only(bottom: 16, right: 14, left: 14),
                            insetPadding: const EdgeInsets.symmetric(horizontal: 44),
                            titlePadding: EdgeInsets.zero,
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            title: Container(
                              height: 100,
                              color: primaryColor,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Alert",
                                    style: TextStyle(
                                        fontFamily: "DMSans",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 38,
                                  )
                                ],
                              ),
                            ),
                            content: Container(
                              padding: EdgeInsets.only(top: 12),
                              child: const Text(
                                "Are you sure you want to Logout?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "DMSans",
                                    fontSize: 14
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: primaryColor,
                                      fontFamily: "DMSans",
                                      fontSize: 14),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // Allow back navigation
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: APIService.appPrimaryColor, // Set the blue background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // Adjust the curvature of the borders
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 34.0), // Optional padding
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: "DMSans",
                                      fontSize: 14),
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen(isSkyBlueTheme: widget.isSkyTheme,)),
                                        (route) => false,
                                  ); // Allow back navigation
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
