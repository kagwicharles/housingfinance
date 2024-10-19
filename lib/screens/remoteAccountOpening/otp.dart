import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:pinput/pinput.dart';

import '../../theme/theme.dart';

class RaoOTP extends StatefulWidget {
  final CustomerData customerData;
  const RaoOTP({Key? key, required this.customerData}) : super(key: key);

  @override
  State<RaoOTP> createState() => _RaoOTPState();
}

class _RaoOTPState extends State<RaoOTP> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();
  TextEditingController _controller = TextEditingController();
  String completeNumber = "";
  String _countryCode = "";
  bool isVerifying = false;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();

    String number = widget.customerData.phoneNumber;
    RegExp firstPlusRegEx = RegExp(r'^\+');
    completeNumber = number.replaceFirst(firstPlusRegEx, '');

    _getOTP();
  }

  _getOTP(){
    final _api_service = APIService();
    _api_service.reqOTP(completeNumber).then((value){
      if (value.status == StatusCode.success.statusCode){
        // print("SENT");
        // setState(() {
        //   _isLoading = false;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  primaryLightVariant,
        body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Enter the One Time Pin sent to your mobile number or email",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    softWrap: true,
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
                            androidSmsAutofillMethod:  AndroidSmsAutofillMethod.smsRetrieverApi,
                            length: 6,
                            controller: _controller,
                            validator: (pin) {
                              if (pin != null) {
                                if (pin.length == 6) {
                                  setState(() {
                                    isVerifying = true;
                                  });
                                  _authRepository
                                      .standardOTPVerification(
                                      mobileNumber: completeNumber, key: _controller.text, serviceName: "RAO", merchantID: "RAO")
                                      .then((value) async => {
                                    if (value.status == StatusCode.success.statusCode)
                                      {
                                        print("Status" + value.status),
                                        setState(() {
                                          isVerified = true;
                                          // isVerifying = true;
                                        })
                                        // CommonUtils.navigateToRoute(
                                        //     context: context, widget: RAOScreen(mobileNumber: widget.mobileNumber,))
                                      }
                                    else
                                      {
                                      },
                                    setState(() {
                                      isVerifying = false;
                                    })
                                  });
                                  return null;
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      )),
                  isVerifying ?
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,),
                          SizedBox(width: 8,),
                          Text(
                            "Verifying the OTP...",
                            style: TextStyle( fontFamily: "DMSans", fontSize: 16, color: primaryColor),
                            softWrap: true,
                          ),
                        ],
                      ) :
                  isVerified
                      ? const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 40),
                      SizedBox(width: 8,),
                      Text(
                        "OTP Verified Successfully!",
                        style: TextStyle( fontFamily: "DMSans", fontSize: 15, color: Colors.green),
                      ),
                    ],
                  )
                      :
                  Text(
                    "Waiting to detect the OTP...",
                    style: TextStyle( fontFamily: "DMSans",fontSize: 15, color: Colors.grey[600]),
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              )
            )));
  }
}
