import 'dart:convert';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/auth/login_screen.dart';
import 'package:pinput/pinput.dart';

import '../../theme/theme.dart';

class OTPScreen extends StatefulWidget {
  final mobile;
  final bool isSkyBlueTheme;

  const OTPScreen({super.key, this.mobile, required this.isSkyBlueTheme});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _authRepository = AuthRepository();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // AppSignature: lIiFU8i6azu

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/images/arrleft.png",
                  fit: BoxFit.cover,
                  width: 24,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Align(alignment: Alignment.centerLeft,
                  child: const Text(
                    "Confirm OTP",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Enter OTP sent to your registered phone number",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                            androidSmsAutofillMethod:  AndroidSmsAutofillMethod.smsRetrieverApi,
                            length: 6,
                            controller: _controller,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          isLoading ?
                          SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,) :
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isLoading = true;
                              });
                              debugPrint("otp>>>${_controller.text}");
                              validateOTP(_controller.text, widget.mobile);
                            },child:  Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: primaryColor),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height:46,
                              child: Center(child:Text('Verify OTP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),),
                              )

                          ),
                          )
                          // ElevatedButton(
                          //     onPressed: () {
                          //       debugPrint("otp>>>${_controller.text}");
                          //       validateOTP(_controller.text, widget.mobile);
                          //     },
                          //     child: const Text("Verify OTP"))
                        ],
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),)
            ],
          ),
        ))));
  }

  void validateOTP(String otp, String mobileNumber) {
    _authRepository
        .verifyOTP(mobileNumber: mobileNumber, otp: otp)
        .then((value) {
      if (value.status == StatusCode.success.statusCode) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen(isSkyBlueTheme: widget.isSkyBlueTheme,)));
      } else {
        AlertUtil.showAlertDialog(context, value.message!);
      }
    });
  }
}
