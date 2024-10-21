import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:hfbbank/screens/remoteAccountOpening/success_display.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isVerifying = false;
  bool isVerified = false;
  bool isSubmitting = false;

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
        Fluttertoast.showToast(
          msg: "OTP sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // You can change the position
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Oops! OTP sending failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // You can change the position
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[800],
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  primaryLightVariant,
        body: SafeArea(
            child: isSubmitting ?
        Container(
          color: primaryLightVariant,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,),
                SizedBox(height: 16,),
                Text(
                  "Submitting account details...",
                  style: TextStyle( fontFamily: "DMSans",fontSize: 15, color: primaryColor),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ) :
            SingleChildScrollView(
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
                                          setState(() {
                                            isVerified = true;
                                            otpResult();
                                            // isVerifying = true;
                                          })

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

  void otpResult(){
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isSubmitting = true;
      });
      openAccount();
    });
  }

  void openAccount() {
    String Infofield1 = "";
    String Infofield2 = "";
    String Infofield3 = "";
    String Infofield4 = "";
    String Infofield5 = "";
    String CustomerCategory = "New Customer";
    String pepFName = "";
    String pepLName = "";
    String pepRelationship = "";
    String phoneNumber = "";
    String altPhoneNumber = "";
    String nokPhoneNumber = "";
    String nokAltPhoneNumber = "";
    String mmNo = "";
    String zipCode;
    String title = "";
    String gender = "";
    String recommendation = "";

    String number = widget.customerData.phoneNumber;
    String altNo = widget.customerData.altPhoneNumber;
    String nokNo = widget.customerData.nokPhone;
    String nokAltNo = widget.customerData.nokAltPhone;
    String mmNumber  =  widget.customerData.mobileMoneyNo;
    RegExp firstPlusRegEx = RegExp(r'^\+');
    phoneNumber = number.replaceFirst(firstPlusRegEx, '');
    altPhoneNumber = altNo.replaceFirst(firstPlusRegEx, '');
    nokPhoneNumber = nokNo.replaceFirst(firstPlusRegEx, '');
    nokAltPhoneNumber = nokAltNo.replaceFirst(firstPlusRegEx, '');
    mmNo = mmNumber.replaceFirst(firstPlusRegEx, '');

    RegExp regExp = RegExp(r'^.{3}');
    zipCode = regExp.stringMatch(phoneNumber) ?? "";

    switch(widget.customerData.gender){
      case "M":
        gender = "Male";
        break;
      case "F":
        gender = "Female";
        break;
    }

    if (widget.customerData.title == "Other"){
      title =  widget.customerData.otherTitle;
    } else {
      title = widget.customerData.title;
    }

    if  (widget.customerData.hasPepRelative == "Yes"){
      pepFName = widget.customerData.pepRFName;
      pepLName = widget.customerData.pepRLName;
      pepRelationship = widget.customerData.pepRelationship;

      if (widget.customerData.pepRelationship == "Other"){
        pepRelationship = widget.customerData.pepRelationship + " - " + widget.customerData.pepSpecifiedRelationship;
      }
    } else {
      pepFName = widget.customerData.firstName;
      pepLName = widget.customerData.lastName;
      pepRelationship = "SELF";
    }

    if (widget.customerData.pepPosition == "Other"){
      widget.customerData.pepPosition = widget.customerData.pepPosition + " - " + widget.customerData.pepSpecifiedTitle;
    }

    switch(widget.customerData.mediaType){
      case "TV/Radio Station":
        recommendation = widget.customerData.mediaType + " - " + widget.customerData.mediaName;
        break;
      case "Customer":
      case "Bank Staff":
      case "HFB Agent":
        recommendation = widget.customerData.mediaType + " - " + widget.customerData.mediaName + " - " + widget.customerData.mediaPhone;
        break;
      case "Social Media":
        recommendation = widget.customerData.mediaType + " - " + widget.customerData.mediaName;
        break;
    }

    if (widget.customerData.altAccount == "Bank Account") {
      Infofield1 = "ACCOUNTID|" + "" + "|CUSTOMER_CATEGORY|" + CustomerCategory + "|ACCOUNT_TYPE|" + widget.customerData.accountTypeName + "|FIRST_NAME|" + widget.customerData.firstName +
          "|MIDDLE_NAME|" + widget.customerData.middleName + "|LAST_NAME|" + widget.customerData.lastName + "|DOB|" + widget.customerData.DOB + "|NATIONALID|" + widget.customerData.NIN +
          "|PHONE_NUMBER|" + phoneNumber + "|ALTERNATE_PHONE_NUMBER|" + altPhoneNumber + "|EMAIL_ADDRESS|" + widget.customerData.email + "|GENDER|" + gender + "|TITLE|" + title + "|CURRENCY|" + widget.customerData.currency + "|BRANCH|" + widget.customerData.branch + "|PRODUCTID|" + widget.customerData.accountType + "|ALTERNATE_ACCOUNT_NUMBER|" + widget.customerData.altAccountNo + "|ALTERNATE_ACCOUNT_NAME|" + widget.customerData.altAccountName + "|ALTERNATE_BANKNAME|" + widget.customerData.altBankName + "|ALTERNATE_BRANCHNAME|" + widget.customerData.altBranchName + "|MOBILE_MONEY_PROVIDER|" + "N/A" + "|MOBILE_MONEY_PHONE_OWNER|" + "N/A" + "|MOBILE_MONEY_PHONE_NUMBER|" + "N/A";
    } else if (widget.customerData.altAccount == "Mobile Money" && widget.customerData.ownership == "No") {
      Infofield1 = "ACCOUNTID|" + "" + "|CUSTOMER_CATEGORY|" + CustomerCategory + "|ACCOUNT_TYPE|" + widget.customerData.accountTypeName + "|FIRST_NAME|" + widget.customerData.firstName +
          "|MIDDLE_NAME|" + widget.customerData.middleName + "|LAST_NAME|" + widget.customerData.lastName + "|DOB|" + widget.customerData.DOB + "|NATIONALID|" + widget.customerData.NIN +
          "|PHONE_NUMBER|" + phoneNumber + "|ALTERNATE_PHONE_NUMBER|" + altPhoneNumber + "|EMAIL_ADDRESS|" + widget.customerData.email + "|GENDER|" + gender + "|TITLE|" + title + "|CURRENCY|" + widget.customerData.currency  + "|BRANCH|" + widget.customerData.branch + "|PRODUCTID|" + widget.customerData.accountType + "|ALTERNATE_ACCOUNT_NUMBER|" + "N/A" + "|ALTERNATE_ACCOUNT_NAME|" + "N/A" + "|ALTERNATE_BANKNAME|" + "N/A" + "|ALTERNATE_BRANCHNAME|" + "N/A" + "|MOBILE_MONEY_PROVIDER|" + widget.customerData.ownerTeleco + "|MOBILE_MONEY_PHONE_OWNER|" + widget.customerData.ownerFName + " " + widget.customerData.ownerLName + "|MOBILE_MONEY_PHONE_NUMBER|" + mmNo;
    } else {
      Infofield1 = "ACCOUNTID|" + "" + "|CUSTOMER_CATEGORY|" + CustomerCategory + "|ACCOUNT_TYPE|" + widget.customerData.accountTypeName + "|FIRST_NAME|" + widget.customerData.firstName +
          "|MIDDLE_NAME|" + widget.customerData.middleName + "|LAST_NAME|" + widget.customerData.lastName + "|DOB|" + widget.customerData.DOB + "|NATIONALID|" + widget.customerData.NIN +
          "|PHONE_NUMBER|" + phoneNumber + "|ALTERNATE_PHONE_NUMBER|" + altPhoneNumber + "|EMAIL_ADDRESS|" + widget.customerData.email + "|GENDER|" + gender + "|TITLE|" + title + "|CURRENCY|" + widget.customerData.currency  + "|BRANCH|" + widget.customerData.branch + "|PRODUCTID|" + widget.customerData.accountType + "|ALTERNATE_ACCOUNT_NUMBER|" + "N/A" + "|ALTERNATE_ACCOUNT_NAME|" + "N/A" + "|ALTERNATE_BANKNAME|" + "N/A" + "|ALTERNATE_BRANCHNAME|" + "N/A" + "|MOBILE_MONEY_PROVIDER|" + widget.customerData.ownerTeleco + "|MOBILE_MONEY_PHONE_OWNER|" + "N/A" + "|MOBILE_MONEY_PHONE_NUMBER|" + mmNo;
    }

    Infofield2 = "FATHER_FIRST_NAME|" + "" + "|FATHER_MIDDLE_NAME|" + "" + "|FATHER_LAST_NAME|" + "" + "|MOTHER_FIRST_NAME|" + "" + "|MOTHER_MIDDLE_NAME|" + "" + "|MOTHER_LAST_NAME|" + "";

    Infofield3 = "CURRENT_LOCATION|" + "" + "|ADDRESS|" + widget.customerData.address + "|HOME_DISTRICT|" + "" + "|YEARS_AT_ADDRESS|" + "- Years" +
        "|POLITICALLY_EXPOSED|" + widget.customerData.pepIsExposed + "|POLITICALLY_EXPOSED_FIRSTNAME|" + pepFName + "|POLITICALLY_EXPOSED_LASTNAME|" + pepLName + "|POLITICALLY_EXPOSED_POSITION|" + widget.customerData.pepPosition + "|POLITICALLY_EXPOSED_INITIAL|" + widget.customerData.pepInitial + "|POLITICALLY_EXPOSED_RELATIONSHIP|" + pepRelationship + "|POLITICALLY_EXPOSED_TITLE|" + widget.customerData.pepTitle + "|POLITICALLY_EXPOSED_COUNTRY|" + widget.customerData.pepCountry + "|POLITICALLY_EXPOSED_START_YEAR|" + widget.customerData.pepStartYear + "|POLITICALLY_EXPOSED_END_YEAR|" + widget.customerData.pepEndYear +
        "|MARITALSTATUS|" + widget.customerData.maritalStatus + "|ZIPCODE|" + zipCode;

    if (widget.customerData.employmentType == "Self-employed/Business") {
      Infofield4 = "INCOME_PER_ANUM|" + widget.customerData.income + "|EMPLOYMENT_TYPE|" + widget.customerData.employmentType + "|OCCUPATION|" + "N/A" + "|PLACE_OF_WORK|" + "N/A" + "|NATURE_OF_BUSINESS_SECTOR|" + widget.customerData.nob + "|PERIOD_OF_EMPLOYMENT|" + "N/A" + "|EMPLOYER_NAME|" + "N/A" + "|NATURE|" + "N/A" + "|BUSINESS_ADDRESS|" + widget.customerData.businessAddress;
    } else if (widget.customerData.employmentType == "Employed/Salary") {
      Infofield4 = "INCOME_PER_ANUM|" + widget.customerData.income + "|EMPLOYMENT_TYPE|" + widget.customerData.employmentType + "|OCCUPATION|" + widget.customerData.occupation + "|PLACE_OF_WORK|" + widget.customerData.empName + "|NATURE_OF_BUSINESS_SECTOR|" + widget.customerData.businessAddress + "|PERIOD_OF_EMPLOYMENT|" + widget.customerData.period + " " + widget.customerData.duration + "|EMPLOYER_NAME|" + widget.customerData.empName + "|NATURE|" + "N/A" + "|BUSINESS_ADDRESS|" + widget.customerData.businessAddress;
    } else {
      Infofield4 = "INCOME_PER_ANUM|" + widget.customerData.income + "|EMPLOYMENT_TYPE|" + widget.customerData.employmentType + "|OCCUPATION|" + "N/A" + "|PLACE_OF_WORK|" + "N/A" + "|NATURE_OF_BUSINESS_SECTOR|" + "N/A" + "|PERIOD_OF_EMPLOYMENT|" + "N/A" + "|EMPLOYER_NAME|" + "N/A" + "|NATURE|" + "N/A" + "|BUSINESS_ADDRESS|" + "N/A";
    }

    Infofield5 = "NEXT_OF_KIN_FIRST_NAME|" + widget.customerData.nokFName + "|NEXT_OF_KIN_MIDDLE_NAME|" + widget.customerData.nokMName + "|NEXT_OF_KIN_LAST_NAME|" + widget.customerData.nokLName + "|NEXT_OF_KIN_PHONE_NUMBER|" + nokPhoneNumber + "|NEXT_OF_KIN_ALTERNATE_PHONE_NUMBER|" + nokAltPhoneNumber + "|NEXT_OF_KIN_ADDRESS|" + "null" + "|OTHER_SERVICES_REQUIRED|" + "" + "|RECOMMENDED_BY|" + recommendation;


    final _api_service = APIService();
    _api_service
        .rao(
      Infofield1,
      Infofield2,
      Infofield3,
      Infofield4,
      Infofield5,
      widget.customerData.idFrontPhoto,
      widget.customerData.idBackPhoto,
      widget.customerData.customerPhoto,
      widget.customerData.signaturePhoto,
    )
        .then((value) async {
      setState(() {
        isSubmitting = false; // Show the loading indicator
      });
      if (value.status == StatusCode.success.statusCode) {

        // Extract the account number from the results
        String accountNumber = value.message.toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.remove('selfie');
        await prefs.remove('signature');
        await prefs.remove('IDBack');
        await prefs.remove('IDFront');
        await prefs.remove('selectedBranch');
        await prefs.remove('selectedProduct');
        await prefs.remove('resAddress');
        await prefs.remove('empAddress');
        await prefs.remove('selectedTitle');
        await prefs.remove('raoEmail');
        await prefs.remove('income');
        await prefs.remove('company');
        await prefs.remove('workingSince');
        await prefs.remove('otherOccupation');
        await prefs.remove('selectedEmpType');
        await prefs.remove('selectedDesignation');
        await prefs.remove('selectedOccupation');
        await prefs.remove('nokPhone');
        await prefs.remove('nokName');
        await deleteAllImages();

        // print(results);
        CommonUtils.navigateToRoute(
            context: context, widget: SuccessDisplayWidget(accountNumber: accountNumber,
          merchant:  "RAONEW", isSkyBlueTheme: false,));
      }else {
        // AlertUtil.showAlertDialog(context, value.message ?? "Error");

        _showAlert("Error!", value.message.toString());
      }
    });
  }

  Future<void> deleteAllImages() async {
    List<String> fileNames = ["IDFront", "IDBack", "customer", "signature"];

    for (String fileName in fileNames) {
      await deleteImage(fileName); // Call the deleteImage function for each file
    }
  }

  Future<void> deleteImage(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      File file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        print("$fileName deleted successfully");
      } else {
        print("$fileName does not exist");
      }
    } catch (e) {
      print("Error deleting $fileName: $e");
    }
  }

  void _showAlert(String title, String message){
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
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 38,
                )
              ],
            ),
          ),
          content: Container(
            padding: EdgeInsets.only(top: 12),
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
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: APIService.appPrimaryColor, // Set the blue background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Adjust the curvature of the borders
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 34.0), // Optional padding
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
                Navigator.of(context).pop(); // Allow back navigation
              },
            ),
          ],
        );
      },
    );
  }
}
