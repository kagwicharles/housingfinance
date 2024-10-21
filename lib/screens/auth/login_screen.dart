import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/home/components/home_page.dart';
import 'package:hfbbank/screens/home/home_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dashboard/dashboard_screen.dart';
import '../settings/database_helper.dart';

class LoginScreen extends StatefulWidget {
  final bool isSkyBlueTheme;
  const LoginScreen({required this.isSkyBlueTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authRepository = AuthRepository();
  final _sharedPref= CommonSharedPref();
  bool _isLoading = false;
  Completer<void> dialogCompleter = Completer<void>();
  _biometricsLogin() {
    setState(() {
      _isLoading = true;
    });

    _sharedPref.getLanguageID();

    authRepository.biometricLogin(_pinController).then((value) {

      if (value) {
        setState(() {
          _isLoading = false;
        });
        Get.off(() => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme,));
      } else {
        setState(() {
          _isLoading = false;
        });
        _showAlertDialog(dialogCompleter);
      }
      _pinController.clear();
    });
  }

  void _showAlertDialog(Completer<void> dialogCompleter) {
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
                  size: 48,
                )
              ],
            ),
          ),
          content: Container(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: const Text(
              "Please login with your PIN, navigate to 'Settings' on the bottom menu and select 'Biometrics Login' to enable fingerprint login",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "DMSans",
                  fontSize: 14
              ),
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: APIService.appPrimaryColor, // Set the blue background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Adjust the curvature of the borders
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0), // Optional padding
                ),
                child: const Text(
                  "Ok",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: "DMSans",
                      fontSize: 14),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogCompleter.complete();  // Allow back navigation
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // _biometricsLogin();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Revert the status bar icons back to dark when leaving this page
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }

  // String pin=
  TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isTwoPane = MediaQuery.of(context).size.width < 600;

    return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
                backgroundColor:  widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
                body: SafeArea(
                    child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context, rootNavigator: true)
                          //     .pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => DashBoardScreen(isSkyTheme: widget.isSkyBlueTheme,)),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: Image.asset(
                          "assets/images/arrleft.png",
                          fit: BoxFit.cover,
                          width: 24,
                        ),
                      ),
                      SizedBox(width: 80,),
                      Image.asset(
                        "assets/images/main_logo.png",
                        fit: BoxFit.cover,
                        height: 45,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        const SizedBox(
                          height:32,
                        ),
                        Align(alignment: Alignment.centerLeft,
                        child: const Text(
                          "Let’s Sign You In",
                          style: TextStyle(fontSize: 26,
                              fontFamily: "DMSans",
                              fontWeight: FontWeight.bold),
                        ),),
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:                         Text(
                            "Welcome back, you’ve been greatly missed!",
                            style: TextStyle(fontSize: 16, fontFamily: "DMSans", color: Colors.grey[600]),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Pinput(
                                  obscureText: true,
                                  controller: _pinController,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Field Required';
                                    }
                                    return null;
                                  },
                                  defaultPinTheme: PinTheme(
                                    width: 56, // Set width for each pin box
                                    height: 56, // Set height for each pin box
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.isSkyBlueTheme ? Colors.white : Colors.grey[200], // Fill color based on theme
                                      borderRadius: BorderRadius.circular(8), // Adjust border radius
                                      border: Border.all(
                                        color: primaryColor, // Example border color
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forgot PIN ?",
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: "DMSans", color: Colors.grey[600]),
                                    )),
                                const SizedBox(
                                  height: 16,
                                ),
                                _isLoading
                                    ? const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,)
                                    : GestureDetector(
                                  onTap: (){
                                    if (_pinController.text.isEmpty) {
                                      Get.snackbar('Alert', 'PIN Required');
                                    } else {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      login(_pinController.text);
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: primaryColor),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height:46,
                                      child: const Center(child:Text('Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "DMSans",
                                            fontWeight: FontWeight.bold
                                        ),),
                                      )
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[600],
                                thickness: 0.5,
                                indent: 14,
                                endIndent: 16,
                              ),
                            ),
                            Text(
                              'Or Login With',
                              style: TextStyle(
                                fontFamily: "DMSans",
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[600],
                                thickness: 0.5,
                                indent: 16,
                                endIndent: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        // Card(
                        //   margin: EdgeInsets.zero,
                        //   elevation: 4,
                        //   child: InkWell(
                        //       onTap: () {
                        //         _biometricsLogin();
                        //       },
                        //       borderRadius: BorderRadius.circular(8),
                        //       child: const Padding(
                        //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                        //           child: Row(
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             children: [
                        //               Icon(Icons.face),
                        //               SizedBox(
                        //                 width: 8,
                        //               ),
                        //               Text(
                        //                 "Face Recognition",
                        //                 style: TextStyle( fontFamily: "DMSans",
                        //                 fontWeight: FontWeight.bold),
                        //                 softWrap: true,
                        //               ),
                        //               Spacer(),
                        //               Icon(Icons.arrow_forward_ios_rounded, size: 18,)
                        //             ],
                        //           ))),
                        // ),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        Card(
                          color: Colors.grey[200],
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor, // Use the primary color from the theme
                              width: 0.8, // Set the border width
                            ),
                            borderRadius: BorderRadius.circular(18.0), // Adjust the radius here
                          ),
                          elevation: 1,
                          child: InkWell(
                              onTap: () {_biometricsLogin();},
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fingerprint, color: primaryColor,),
                                      Spacer(),
                                      Text(
                                        "Fingerprint Recognition",
                                        style: TextStyle(fontFamily: "DMSans",
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                        softWrap: true,
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios_rounded, size: 18, color: primaryColor,)
                                    ],
                                  ))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))));
  }

  void login(String pin) {
    authRepository.login(pin).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        if  (value.imageUrl.toString() != "[]"){
          // Parse the JSON string into a Dart object
          List<dynamic> images = jsonDecode(value.imageUrl!);
          // Extract the "Image" string from the first object in the array
          String imageString = images[0]["Image"];
          DatabaseHelper.instance.insertProfileImage(imageString);
        }
        // Get.offAll(() => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme,));

        Get.offAll(
              () => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme),
          transition: Transition.downToUp,
          duration: Duration(milliseconds: 700), // Customize duration
        );


        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => const ScreenHome()));
      } else if (value.status == '201'){
        _showAlert("Important update available!", "To ensure a smooth experience, please update your app now.", "C");
      }else if (value.status == '202'){
        if  (value.imageUrl.toString() != "[]"){
          // Parse the JSON string into a Dart object
          List<dynamic> images = jsonDecode(value.imageUrl!);
          // Extract the "Image" string from the first object in the array
          String imageString = images[0]["Image"];
          DatabaseHelper.instance.insertProfileImage(imageString);
        }
        _showAlert("New features are here!", "Update your App to explore our latest exciting features", "I");
      }
      else {
        AlertUtil.showAlertDialog(context, value.message!);
      }
    });
  }

  void _showAlert(String title, String message, String category){
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontFamily: "DMSans",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Icon(
                  Icons.update,
                  color: Colors.redAccent,
                  size: 38,
                )
              ],
            ),
          ),
          content: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "DMSans",
                  fontSize: 14
              ),
            ),
          ),
          actions: <Widget>[
            category == "I" ?
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white, // Set the blue background color
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12), // Adjust the curvature of the borders
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Optional padding
              ),
              child: const Text(
                "Maybe later",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: primaryColor,
                    fontFamily: "DMSans",
                    fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Get.offAll(() => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme,));
                Get.offAll(
                      () => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme),
                  transition: Transition.rightToLeftWithFade,
                  duration: Duration(milliseconds: 500), // Customize duration
                );

              },
            ):Container(),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: APIService.appPrimaryColor, // Set the blue background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Adjust the curvature of the borders
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Optional padding
              ),
              child: const Text(
                "Update Now",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "DMSans",
                    fontSize: 14),
              ),
              onPressed: () {
                if (Platform.isAndroid) {
                  launchUrl(
                      Uri.parse("https://play.google.com/store/apps/details?id=com.elmahousingfinanceug"),
                      mode: LaunchMode.externalApplication,
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: false,
                      ));
                } else if (Platform.isIOS) {
                  launchUrl(
                      Uri.parse("https://apps.apple.com/ug/app/housing-finance-bank-uganda/id1018758428"),
                      mode: LaunchMode.externalApplication,
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: false,
                      ));
                } // Allow back navigation
              },
            ),
          ],
        );
      },
    );
  }
}
