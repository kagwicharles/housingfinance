import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttercontactpicker/src/interface.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../theme/theme.dart';
import '../headers/header_section.dart';
import 'Data_Purchase.dart';

class Data extends StatefulWidget {
  final bool isSkyBlueTheme;
  const Data({Key? key, required this.isSkyBlueTheme}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  DataBundle? selectedDataBundle;
  DataFreq? selectedDataFreq;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  bool isLoading = true;
  TextEditingController accountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aliasController = TextEditingController();
  List<DataFreq> DataFreqs = [];
  List<DataBundle> DataBundles = [];
  String _selectedDirection = 'Beneficiary';
  final _benRepository = BeneficiaryRepository();
  List<Beneficiary> beneficiaries = [];
  getBeneficiaries() => _benRepository.getBeneficiariesByMerchantID("MTNDB");
  int totalBens = 0;
  var ben;
  var _currentValue;
  bool isBenSelected = true;
  var selectedBeneficiary;

  @override
  void initState() {
    getDataFreqs();
    super.initState();
  }

  getDataFreqs() {
    final _api_service = APIService();
    _api_service.getDataFreqs().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        var filteredList = value.dynamicList!
            .where((item) => item['RelationID'] != 'MMoney')
            .toList();
        setState(() {
          DataFreqs =
              filteredList.map((item) => DataFreq.fromJson(item)).toList();
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  getDataBundles(String DataFreq) {
    final _api_service = APIService();
    _api_service.getDataBundles(DataFreq).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          DataBundles = value.dynamicList!
              .map((item) => DataBundle.fromJson(item))
              .toList();
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  valData(String ID, String category, String mobile, String description) {
    final _api_service = APIService();
    _api_service.dataValidation(category, ID, mobile).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        List? results = value.display;
        print(results);
        String amount = results?[0]['Bill Amount'];

        CommonUtils.navigateToRoute(
            context: context,
            widget: DataPurchase(
              ID: ID,
              category: category,
              mobile: mobile,
              amount: amount,
              description: description,
              isSkyBlueTheme: widget.isSkyBlueTheme,
            ));
        setState(() {
          isSubmitting = false;
        });
      } else {
        _showDialogue(value.message.toString());
        setState(() {
          isSubmitting = false;
        });
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

  _showDialogue(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(fontFamily: "Manrope", fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Manrope",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
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
    return FutureBuilder<List<Beneficiary>?>(
        future: getBeneficiaries(),
    builder: (BuildContext context,
    AsyncSnapshot<List<Beneficiary>?> snapshot) {
    Widget child = SizedBox(
    height: MediaQuery.of(context).size.height,
    child: Center(child: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,)),
    );
    if (snapshot.hasData) {
      totalBens = snapshot.data?.length ?? 0;
      beneficiaries = snapshot.data ?? [];


      var dropdownPicks = beneficiaries
          .fold<Map<String, dynamic>>(
          {},
              (acc, curr) => acc
            ..[curr.accountID] = curr.accountAlias.isEmpty
                ? curr.accountID
                : curr.accountAlias)
          .entries
          .map((item) => DropdownMenuItem(
        value: item.key,
        child: Text(
          item.value,
          style: const TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontFamily: "Manrope",
          ),
        ),
      ))
          .toList();
      dropdownPicks.toSet().toList();
      if (dropdownPicks.isNotEmpty) {
        _currentValue = dropdownPicks[0].value;
        ben ??= dropdownPicks[0].value;
      }
      child = Scaffold(
        backgroundColor: primaryColor,
          body: ModalProgressHUD(
              inAsyncCall:
              isLoading, // Set this variable to true when you want to show the loading indicator
              opacity:
              0.5, // Customize the opacity of the background when the loading indicator is displayed
              progressIndicator: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,),
            child: Column(
              children: [
                const SizedBox(height: 20),
                HeaderSectionApp(header: 'MTN Data'),
                Expanded(child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        color: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: SingleChildScrollView(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                  "Choose receipient",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: "Manrope",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _selectedDirection =
                                                            'Beneficiary';
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _selectedDirection ==
                                                              'Beneficiary'
                                                              ? primaryColor
                                                              : Colors
                                                              .white, // Use primary color for active button
                                                          shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(12),
                                                              ),
                                                              side: BorderSide(
                                                                  color:
                                                                  primaryColor)),
                                                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                                                        ),
                                                        child: Text(
                                                          'Select Beneficiary',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily: 'Manrope',
                                                            fontWeight: FontWeight.bold,
                                                            color: _selectedDirection ==
                                                                'Beneficiary'
                                                                ? Colors.white
                                                                : primaryColor, // Change text color based on _selectedDirection
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 7),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _selectedDirection =
                                                            'Other';
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: _selectedDirection ==
                                                              'Beneficiary'
                                                              ? Colors.white
                                                              : primaryColor, // Use primary color for active button
                                                          shape:
                                                          const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(12),
                                                              ),
                                                              side: BorderSide(
                                                                  color:
                                                                  primaryColor)),
                                                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                                                        ),
                                                        child: Text(
                                                          'Others',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily: 'Manrope',
                                                            fontWeight: FontWeight.bold,
                                                            color: _selectedDirection ==
                                                                'Beneficiary'
                                                                ? primaryColor
                                                                : Colors
                                                                .white, // Change text color based on _selectedDirection
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
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
                                                  "Select Bundle Validity",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: "Manrope",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                 DropdownButtonFormField<DataFreq>(
                                                    decoration: const InputDecoration(
                                                        fillColor: Colors.white,
                                                        border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.white),
                                                          borderRadius: BorderRadius.zero,
                                                        ),
                                                        contentPadding:
                                                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                        hintText: "Select Bundle Validity"
                                                    ),
                                                    iconEnabledColor: primaryColor,
                                                    value:
                                                    selectedDataFreq, // Provide the currently selected value (can be null initially)
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedDataFreq =
                                                            newValue;
                                                        selectedDataBundle = null;
                                                        accountController.text =
                                                        "";
                                                        aliasController.text = "";
                                                        getDataBundles(
                                                            selectedDataFreq!
                                                                .category);
                                                        isLoading = true;
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select an option';
                                                      }
                                                      return null;
                                                    },
                                                    items: DataFreqs.map(
                                                            (DataFreq item) {
                                                          return DropdownMenuItem<
                                                              DataFreq>(
                                                            value: item,
                                                            child: Text(
                                                              item.category,
                                                              style: const TextStyle(
                                                                  color: primaryColor,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                  "Manrope",
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                            ),
                                                          );
                                                        }).toList(),
                                                  ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                const Text(
                                                  "Select Bundle",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: "Manrope",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                DropdownButtonFormField<
                                                      DataBundle>(
                                                    decoration: const InputDecoration(
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.white),
                                                      borderRadius: BorderRadius.zero,
                                                    ),
                                                    contentPadding:
                                                    EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                    hintText: "Select Bundle"
                                                ),
                                                    iconEnabledColor: primaryColor,
                                                    value:
                                                    selectedDataBundle, // Provide the currently selected value (can be null initially)
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedDataBundle =
                                                            newValue;
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select an option';
                                                      }
                                                      return null;
                                                    },
                                                    items: DataBundles.map(
                                                            (DataBundle item) {
                                                          return DropdownMenuItem<
                                                              DataBundle>(
                                                            value: item,
                                                            child: Text(
                                                              item.description,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: primaryColor,
                                                                  fontFamily:
                                                                  "Manrope",
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                            ),
                                                          );
                                                        }).toList(),
                                                  ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                _selectedDirection == "Beneficiary" ?
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Select Beneficiary",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily: "Manrope",
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    DropdownButtonFormField<String>(
                                                      decoration: const InputDecoration(
                                                          fillColor: Colors.white,
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.white),
                                                            borderRadius: BorderRadius.zero,
                                                          ),
                                                          contentPadding:
                                                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                          hintText: "Select Beneficiary"
                                                      ),
                                                      iconEnabledColor: primaryColor,
                                                      style: TextStyle(fontSize: 12, fontFamily: 'Manrope', color: Colors.black, fontWeight: FontWeight.normal),
                                                      value: selectedBeneficiary,
                                                      items: beneficiaries.map<DropdownMenuItem<String>>((Beneficiary beneficiary) {
                                                        return DropdownMenuItem<String>(
                                                          value: beneficiary.accountID,
                                                          child: Text(
                                                            beneficiary.accountAlias.isNotEmpty ? beneficiary.accountAlias : beneficiary.accountID,
                                                            style: TextStyle(fontSize: 12, color: primaryColor, fontFamily: 'Manrope'),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? value) {
                                                        setState(() {
                                                          selectedBeneficiary = value!;
                                                          print('Selected beneficiary: $selectedBeneficiary');
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ) :
                                                Column(
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
                                                      keyboardType:
                                                      TextInputType.phone,
                                                      controller: phoneController,
                                                      style: TextStyle(
                                                          fontFamily: "Manrope",
                                                          fontSize: 13,
                                                          color: primaryColor
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          phoneController.text =
                                                              value;
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
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                isSubmitting
                                                    ? const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,)
                                                    : WidgetFactory.buildButton(
                                                    context, () {
                                                  if (_formKey
                                                      .currentState!
                                                      .validate()) {
                                                    String mobile = "";
                                                    if (_selectedDirection == "Beneficiary"){
                                                      mobile = selectedBeneficiary;
                                                    } else {
                                                      mobile = phoneController
                                                          .text;
                                                    }
                                                    valData(
                                                        selectedDataBundle!
                                                            .ID,
                                                        selectedDataFreq!
                                                            .category,
                                                        mobile,
                                                        selectedDataBundle!
                                                            .description);
                                                    setState(() {
                                                      isSubmitting = true;
                                                    });
                                                  }
                                                }, "Submit",
                                                    color: primaryColor),
                                              ],
                                            )),
                                      ],
                                    ))
                            )))),
              ],
            )
          )
          );
    }
    return child;
    });



  }
}


class DataFreq {
  final String category;
  // final String relationID;

  DataFreq({required this.category});

  factory DataFreq.fromJson(Map<String, dynamic> json) {
    return DataFreq(
      category: json['Category'],
      // relationID: json['RelationID'],
    );
  }
}

class DataBundle {
  final String description;
  final String ID;

  DataBundle({required this.description, required this.ID});

  factory DataBundle.fromJson(Map<String, dynamic> json) {
    return DataBundle(
      description: json['Desciption'],
      ID: json['ID'],
    );
  }
}
