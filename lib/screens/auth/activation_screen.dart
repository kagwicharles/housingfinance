
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/auth/otp_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:pinput/pinput.dart';

import '../home/components/custome_phone_number_input.dart';

class ActivationScreen extends StatefulWidget {
  final bool isSkyBlueTheme;
  const ActivationScreen({required this.isSkyBlueTheme});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  bool _isLoading = false;

  final _moduleRepository = ModuleRepository();
  final _formRepository = FormsRepository();
  final _actionRepository = ActionControlRepository();
  final _authRepository = AuthRepository();


  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  TextEditingController pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String phone_number = '';
  String pin = '';


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

  @override
  Widget build(BuildContext context) {
    PhoneNumberInputController? phoneController;

    // Get the width of the device
    double deviceWidth = MediaQuery.of(context).size.width;

    // Calculate the width for each pin (based on 4 pins)
    double pinWidth = (deviceWidth - 40) / 4;
    double pinSpacing = 24.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Light icons
    ),
      child: Scaffold(
          backgroundColor: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
          body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            "Mobile Number & ",
                            style: TextStyle(
                                fontSize: 26,
                                fontFamily: "DMSans",
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "PIN",
                            style: TextStyle(
                                fontSize: 26,
                                fontFamily: "DMSans",
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Enter your Phone Number and Login PIN",
                            style: TextStyle( fontSize: 16,
                                fontFamily: "DMSans",
                                color: Colors.grey[600]),
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Enter Mobile Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomPhoneNumberInput(
                                    onChanged: (String phone) {
                                      print(phone.toString());
                                      setState(() {
                                        phone_number = phone.toString();
                                      });
                                    },
                                    locale: 'en',
                                    initialCountry: 'UG',
                                    errorText: 'Number should be 10 characters',
                                    allowPickFromContacts: false,
                                    controller: phoneController,
                                    hint: 'For example 777026164',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor)),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const Text(
                                    'Enter PIN',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 0), // No padding around the container
                                      child: Pinput(
                                        obscureText: true,
                                        length: 4,
                                        controller: pinController,
                                        defaultPinTheme: PinTheme(
                                          width: (deviceWidth - pinSpacing * 3 - 32) / 4, // Adjust width with spacing
                                          height: 48,
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                          textStyle: TextStyle(fontSize: 24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: primaryColor),
                                          ),
                                        ),
                                        focusedPinTheme: PinTheme(
                                          width: (deviceWidth - pinSpacing * 3 - 32) / 4, // Keep same width when focused
                                          height: 60,
                                          textStyle: TextStyle(fontSize: 24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: primaryColor),
                                          ),
                                        ), // Add spacing between pins
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  _isLoading
                                      ? Center(
                                      child: SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,))
                                      : GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      pin = pinController.text;
                                      debugPrint("pin>>>>${pinController.text}");
                                      String phoneValue =
                                      phone_number.replaceAll('+', '');
                                      debugPrint("phone>>>>${phoneValue}");
                                      _activate(phoneValue, pin);
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
                                        child: Center(child:Text('Activate',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        )
                                    ),
                                  )],
                              )),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),)
                  ],
                ),
                // ))
              ))),
    );
  }

   _activate(String mobileNumber, String pin) {
    _authRepository
        .activate(mobileNumber: mobileNumber, pin: pin)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("activationValue>>>${value.toString}");
      debugPrint("activationValue>>>${value.message}");
      debugPrint("activationValue>>>${value.firstName}");
      debugPrint("activationValue>>>${value.phone}");
      // debugPrint("activationValue>>>${value}");

      if (value.status == StatusCode.success.statusCode) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OTPScreen(mobile: mobileNumber, isSkyBlueTheme: widget.isSkyBlueTheme, )));
      } else {
        AlertUtil.showAlertDialog(context, "value.message!");
      }
    });
  }
}
