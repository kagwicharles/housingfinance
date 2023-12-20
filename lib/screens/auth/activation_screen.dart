
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/screens/auth/otp_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:pinput/pinput.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

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
  Widget build(BuildContext context) {
    final isTwoPane = MediaQuery
        .of(context)
        .size
        .width > 600;

    PhoneNumberInputController? phoneController;
    return
        Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        "Mobile Number & ",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "PIN",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Enter your Phone Number and Login PIN",
                        style: TextStyle(fontSize: 24, color: Colors.grey[600]),
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
                              PhoneNumberInput(
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
                                hint: 'For example 7654321572',
                              ),
                              const SizedBox(
                                height: 16,
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
                              Pinput(
                                obscureText: true,
                                length: 4,
                                controller: pinController,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _isLoading
                                  ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ))
                                  : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: primaryColor),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height:50,
                                child: GestureDetector(onTap: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  pin = pinController.text;
                                  debugPrint("pin>>>>${pinController.text}");
                                  String phoneValue =
                                  phone_number.replaceAll('+', '');
                                  debugPrint("phone>>>>${phoneValue}");
                                  _activate(phoneValue, pin);
                                  // activateApp(phoneValue, pin);
                                }, child: Center(child:Text('Activate'),),


                              )

                              )],
                          )),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                // ))
        )));
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
            builder: (context) => OTPScreen(mobile: mobileNumber)));
      } else {
        AlertUtil.showAlertDialog(context, "value.message!");
      }
    });
  }
}
