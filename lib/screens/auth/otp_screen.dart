import 'dart:convert';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/screens/auth/login_screen.dart';
import 'package:hfbbank/screens/home/home_screen.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final mobile;

  const OTPScreen({super.key, this.mobile});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _authRepository = AuthRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isTwoPane = MediaQuery.of(context).size.width > 600;

    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                "Confirm OTP",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Enter OTP sent to your registered phone number",
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
                        length: 6,
                        controller: _controller,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            debugPrint("otp>>>${_controller.text}");
                            validateOTP(_controller.text, widget.mobile);
                          },
                          child: const Text("Verify OTP"))
                    ],
                  )),
              const SizedBox(
                height: 24,
              ),
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
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        AlertUtil.showAlertDialog(context, value.message!);
      }
    });
  }
}
