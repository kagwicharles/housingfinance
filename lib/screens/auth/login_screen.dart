import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/home/components/home_screen_bottom_nav.dart';
import 'package:hfbbank/screens/home/home_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authRepository = AuthRepository();
  final _sharedPref= CommonSharedPref();
  bool _isLoading = false;
  _biometricsLogin() {

    _sharedPref.getLanguageID();

    authRepository.biometricLogin(_pinController).then((value) {

      if (value) {
        Get.off(() => ScreenHome());

      }
      _pinController.clear();
    });
  }

  @override
  void initState() {
    _biometricsLogin();
    // TODO: implement initState
    super.initState();
  }

  // String pin=
  TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isTwoPane = MediaQuery.of(context).size.width < 600;

    return isTwoPane
        ? AnnotatedRegion(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
                body: SafeArea(
                    child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 34,
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Let’s Sign You In",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Welcome back, you’ve been missed!",
                    style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 54,
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
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot PIN ?",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              )),
                          const SizedBox(
                            height: 28,
                          ),
                          _isLoading
                              ? CircularProgressIndicator(
                                  color: primaryColor,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_pinController.text.isEmpty) {
                                      Get.snackbar('Alert', 'PIN Required');
                                    } else {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      login(_pinController.text);
                                    }
                                  },
                                  child: const Text("Login"))
                        ],
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  Card(
                    elevation: 4,
                    child: InkWell(
                        onTap: () {
                          _biometricsLogin();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                            padding: EdgeInsets.all(28),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.face),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Face Recognition",
                                  style: TextStyle(fontSize: 18),
                                  softWrap: true,
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ))),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    elevation: 4,
                    child: InkWell(
                        onTap: () {_biometricsLogin();},
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                            padding: EdgeInsets.all(28),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.fingerprint),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Fingerprint Recognition",
                                  style: TextStyle(fontSize: 18),
                                  softWrap: true,
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ))),
                  )
                ],
              ),
            ))))
        : AnnotatedRegion(
            value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark),
            child: Scaffold(
                backgroundColor: primaryLightVariant,
                body: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.only(
                        bottom: 50, left: 200, right: 200, top: 50),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // Ensure both sides take the full height
                        children: [
                          Expanded(
                            flex: 0, // Adjust the flex values as needed
                            child: Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  // Adjust the radius as needed
                                  bottomLeft: Radius.circular(20.0),
                                ),
                                child:
                                    // Container(color: primaryColor,)
                                    Image.asset(
                                        'assets/images/hfb.jpg'), // Your image widget
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          Expanded(
                              //   flex: 3, // Adjust the flex values as needed
                              child: Center(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                // Adjust the radius as needed
                                bottomLeft: Radius.circular(20.0),
                              ), // Color for the form side
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 100,
                                        child: Image.asset(
                                            'assets/images/main_logo.png')),
                                    const SizedBox(
                                      height: 50,
                                    ),

                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 150, right: 150),
                                        child: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'PLEASE LOGIN TO CONTINUE',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  height: 35,
                                                ),
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    // Padding inside the TextFormField
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0),
                                                      // Define the border color and width
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Define the border radius
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0),
                                                      // Define the focused border color and width
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Define the focused border radius
                                                    ),
                                                    labelText: 'Email',
                                                    // Add a label if needed
                                                    hintText:
                                                        'Email', // Add a hint text if needed
                                                  ),
                                                  controller: null,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Email Required";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    // Padding inside the TextFormField
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0),
                                                      // Define the border color and width
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Define the border radius
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0),
                                                      // Define the focused border color and width
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Define the focused border radius
                                                    ),
                                                    labelText: 'Password',
                                                    // Add a label if needed
                                                    hintText:
                                                        'Password', // Add a hint text if needed
                                                  ),
                                                  obscureText: true,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Password is Required";
                                                    }
                                                    return null;
                                                  },
                                                  controller: null,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                if (_isLoading)
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color:
                                                                  primaryColor))
                                                else
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            debugPrint(
                                                                'logintoken>${token}');
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomeBottomNav()));
                                                            //
                                                            // _login(
                                                            //
                                                            //   // _usernameController
                                                            //   //     .text,
                                                            //   // _passwordController
                                                            //   //     .text,
                                                            //     token!);
                                                          },
                                                          child: const Center(
                                                              child: Text(
                                                            'Login',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))))
                                              ],
                                            ))),

                                    const SizedBox(
                                      height: 50,
                                    ),
                                    // Container(
                                    //     decoration: BoxDecoration(
                                    //         color: const Color(0xffF2F2F2),
                                    //         borderRadius: BorderRadius.circular(10)),
                                    //     margin: const EdgeInsets.only(
                                    //         left: 150, right: 150),
                                    //     width: MediaQuery.of(context).size.width,
                                    //     height: 50,
                                    //     child: GestureDetector(
                                    //         onTap: () {},
                                    //         child: const Center(
                                    //             child: Text(
                                    //           'First Time Login',
                                    //           style: TextStyle(
                                    //               color: Colors.black,
                                    //               fontSize: 20,
                                    //               fontWeight: FontWeight.bold),
                                    //         ))))
                                    // Add more form fields as needed
                                  ],
                                ),
                              ),
                            ),
                          ))
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
        Get.offAll(() => ScreenHome());
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => const ScreenHome()));
      } else {
        AlertUtil.showAlertDialog(context, value.message!);
      }
    });
  }
}
