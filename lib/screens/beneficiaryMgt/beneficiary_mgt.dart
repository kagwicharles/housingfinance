import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/beneficiaryMgt/view_beneficiaries.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/test.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:fluttercontactpicker/src/interface.dart';
import '../home/components/custom_drawer.dart';
import '../home/components/success_view.dart';
import '../home/home_header.dart';

class BeneficiaryMgt extends StatefulWidget {
  final bool isSkyBlueTheme;
  const BeneficiaryMgt({required this.isSkyBlueTheme});

  @override
  State<BeneficiaryMgt> createState() => _BeneficiaryMgtState();
}

class _BeneficiaryMgtState extends State<BeneficiaryMgt> {
  BillerName? selectedBillerName;
  BillerType? selectedBillerType;
  String selectedBiller = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  bool isMMoney = false;
  bool isLoading = true;
  TextEditingController accountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aliasController = TextEditingController();
  List<BillerType> billerTypes = [];
  List<BillerName> billerNames = [];
  final _moduleRepository = ModuleRepository();

  @override
  void initState() {
    getBillerTypes();
    super.initState();
  }

  getBillerTypes() {
    final _api_service = APIService();
    _api_service.getBillerTypes().then((value) {
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          billerTypes = value.dynamicList!
              .map((item) => BillerType.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  getBillerNames(String billerType) {
    final _api_service = APIService();
    _api_service.getBillerNames(billerType).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          billerNames = value.dynamicList!
              .map((item) => BillerName.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  saveBen(String billerType, String billerName, String alias, String account) {
    final _api_service = APIService();
    _api_service.saveBen(billerType, billerName, alias, account).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        CommonUtils.navigateToRoute(
            context: context,
            widget: SuccessView(message: value.message.toString(), isSkyBlueTheme: widget.isSkyBlueTheme,));
        setState(() {
          isSubmitting = false;
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  void showCustomSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  validatePhone(String phoneNumber, String moduleID, String merchantID) {
    setState(() {
      isSubmitting = true;
    });

    final _api_service = APIService();
    _api_service.mmValidate(moduleID, merchantID, phoneNumber).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        List<dynamic>? dataList =value.display;
        String? name;

        if (dataList != null && dataList.isNotEmpty) {
          Map<String, dynamic>? data = dataList[0] as Map<String, dynamic>?;
          if (data != null) {
            name = data['Name'];
          }
        }
        setState(() {
          aliasController.text = name!;
          accountController.text = phoneNumber;
          isMMoney = false;
        });
      } else {
        _showDialogue(value.message.toString());
      }

      setState(() {
        isSubmitting = false;
      });
    });
  }

  _showDialogue(String message){
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
                const Text(
                  "Alert",
                  style: TextStyle(
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
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Manrope",
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
                "OK",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  pickPhoneContact() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    setState(() {
      phoneController.text = formatPhone(contact.phoneNumber?.number ?? "")
          .replaceAll(RegExp(r'^0'), '');
    });
  }

  String formatPhone(String phone) {
    return phone.replaceAll(RegExp(r'\+\d{1,3}'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(isSkyTheme: widget.isSkyBlueTheme),
      backgroundColor: primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.navigate(
                ViewBeneficiaries(isSkyBlueTheme: widget.isSkyBlueTheme,));

          },
          backgroundColor: primaryColor,
          child: Icon(Icons.visibility), // Icon to indicate viewing
        ),
      body: ModalProgressHUD(
        inAsyncCall:
        isLoading, // Set this variable to true when you want to show the loading indicator
        opacity:
        0.5, // Customize the opacity of the background when the loading indicator is displayed
        progressIndicator: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          HomeHeaderSectionApp(
            header: "Beneficiary Management",
            name: '',
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color:  widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Add Beneficiary",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Text(
                            "*or press the eye icon to view saved beneficiaries",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Manrope",
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            color: secondaryAccent,
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Select Biller Type",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<BillerType>(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.zero,
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                hintText: "Select Biller Type"
                            ),
                            iconEnabledColor: primaryColor,
                            style: const TextStyle(
                              fontFamily: "DMSans",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.zero,
                            value:
                            selectedBillerType, // Provide the currently selected value (can be null initially)
                            onChanged: (newValue) {
                              setState(() {
                                selectedBillerType = newValue;
                                selectedBillerName = null;
                                accountController.text = "";
                                aliasController.text = "";
                                phoneController.text = "";
                                getBillerNames(
                                    selectedBillerType!.relationID);
                                isLoading = true;
                                if (selectedBillerType?.description ==
                                    "Mobile Money") {
                                  isMMoney = true;
                                } else {
                                  isMMoney = false;
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                            items: billerTypes.map((BillerType item) {
                              return DropdownMenuItem<BillerType>(
                                value: item,
                                child: Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Manrope",
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Text(
                            "Select BillerName",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<BillerName>(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.zero,
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                              hintText: "Select Biller Name"
                            ),
                            iconEnabledColor: primaryColor,
                            style: const TextStyle(
                              fontFamily: "DMSans",
                              fontWeight: FontWeight.normal,
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.zero,
                            value:
                            selectedBillerName,
                            onChanged: (newValue) {
                              setState(() {
                                selectedBillerName = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                            items: billerNames.map((BillerName item) {
                              return DropdownMenuItem<BillerName>(
                                value: item,
                                child: Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Manrope",
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          isMMoney
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Enter Phone Number",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: TextStyle(
                                    fontFamily: "Manrope",
                                    fontSize: 13,
                                    color: primaryColor
                                ),
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                onChanged: (value) {
                                  setState(() {
                                    phoneController.text = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                    suffixIcon: IconButton(
                                        onPressed: pickPhoneContact,
                                        icon:
                                        const Icon(Icons.contacts, color: primaryColor)),
                                  hintText: "Enter Phone number"
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter the phone number';
                                  }
                                  return null;
                                },
                                // onChanged and initialValue can be added as needed
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              isSubmitting
                                  ? const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,)
                                  : WidgetFactory.buildButton(
                                  context, () {

                                RegExp regExp = RegExp(r'^256');
                                String noSpaceNumber = phoneController.text.replaceAll(' ', '');
                                String noSpecialXtersNo = noSpaceNumber.replaceAll(RegExp(r'^\+'), '');
                                String phoneNumber = noSpecialXtersNo.replaceAll(RegExp(r'^0'), '256');

                                if (!regExp.hasMatch(phoneNumber)) {
                                  // If not, add '256' to the beginning of the phone number
                                  phoneNumber = '256$phoneNumber';
                                }

                                if (phoneNumber.isEmpty){
                                  showCustomSnackbar(context, 'Please Enter the phone number');
                                } else  {
                                  if (selectedBillerName?.description ==
                                      "Airtel Money") {
                                    String moduleID = "AIRTELMONEY";
                                    String merchantID = "007001016";
                                    validatePhone(phoneNumber,
                                        moduleID, merchantID);
                                  } else if (selectedBillerName?.description ==
                                      "MTN Money"){
                                    String moduleID = "MTNMONEY";
                                    String merchantID = "007001017";
                                    validatePhone(phoneNumber,
                                        moduleID, merchantID);
                                  } else {
                                    showCustomSnackbar(context, 'Please select a Biller Name');
                                  }
                                }

                              }, "Validate",
                                  color: primaryColor),
                            ],
                          )
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Enter Beneficiary Number",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: TextStyle(
                                  fontFamily: "Manrope",
                                  fontSize: 13,
                                  color: primaryColor
                                ),
                                keyboardType: TextInputType.number,
                                controller: accountController,
                                onChanged: (value) {
                                  setState(() {
                                    accountController.text = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                    hintText: "Enter Account Number",
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter the account number';
                                  }
                                  return null;
                                },
                                // onChanged and initialValue can be added as needed
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const Text(
                                "Enter Beneficiary Name",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: TextStyle(
                                    fontFamily: "Manrope",
                                    fontSize: 13,
                                    color: primaryColor
                                ),
                                keyboardType: TextInputType.text,
                                controller: aliasController,
                                onChanged: (value) {
                                  setState(() {
                                    print(value);
                                  });
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                    hintText: "Enter Beneficiary Name"
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter the Beneficiary Name';
                                  }
                                  return null;
                                },
                                // onChanged and initialValue can be added as needed
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              isSubmitting
                                  ? const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,)
                                  : WidgetFactory.buildButton(
                                  context, () {
                                if (_formKey.currentState!
                                    .validate()) {
                                  saveBen(
                                      selectedBillerType!
                                          .relationID,
                                      selectedBillerName!
                                          .subCodeID,
                                      aliasController.text,
                                      accountController.text);
                                  setState(() {
                                    isSubmitting = true;
                                  });
                                }
                              }, "Save Beneficiary",
                                  color: primaryColor),
                            ],
                          )
                        ],
                      )),
                )
              ),
            ),)
        ],
      ),)
    );
  }
}
class BillerType {
  final String description;
  final String relationID;

  BillerType({required this.description, required this.relationID});

  factory BillerType.fromJson(Map<String, dynamic> json) {
    return BillerType(
      description: json['Description'],
      relationID: json['RelationID'],
    );
  }
}

class BillerName {
  final String description;
  final String subCodeID;

  BillerName({required this.description, required this.subCodeID});

  factory BillerName.fromJson(Map<String, dynamic> json) {
    return BillerName(
      description: json['Description'],
      subCodeID: json['SubCodeID'],
    );
  }
}
