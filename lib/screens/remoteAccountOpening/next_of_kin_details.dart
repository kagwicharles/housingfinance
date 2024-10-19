import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/theme.dart';
import '../home/components/custome_phone_number_input.dart';

class NOKDetails extends StatefulWidget {
  final CustomerData customerData;

  NOKDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  State<NOKDetails> createState() => _NOKDetailsState();
}

class _NOKDetailsState extends State<NOKDetails> {
  TextEditingController nokFirstNameController = TextEditingController();
  TextEditingController nokMiddleNameController = TextEditingController();
  TextEditingController nokLastNameController = TextEditingController();
  TextEditingController nokPhoneController = TextEditingController();
  TextEditingController nokAltPhoneController = TextEditingController();
  String phone_number = '';
  String altPhone_number = '';

  @override
  void initState() {
    super.initState();
    final customerData = widget.customerData;

    nokFirstNameController.text = customerData.nokFName ?? '';
    nokMiddleNameController.text = customerData.nokMName ?? '';
    nokLastNameController.text = customerData.nokLName ?? '';
    nokPhoneController.text = customerData.nokPhone ?? '';
    nokPhoneController.text = customerData.nokAltPhone ?? '';

    getSavedNokFName();
    getSavedNokMName();
    getSavedNokLName();
  }
  @override
  Widget build(BuildContext context) {
    PhoneNumberInputController? phoneController;
    PhoneNumberInputController? altPhoneController;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Next of Kin\'s First Name ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: nokFirstNameController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.nokFName = value;
                  saveNokFName(value);
                });
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                hintText: "Enter your next of kin\'s First Name",
                hintStyle: const TextStyle(
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.normal,
                      fontSize: 13,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your next of kin\'s First Name';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Next of Kin\'s Middle Name *Optional',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: nokMiddleNameController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.nokMName = value;
                  saveNokMName(value);
                });
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                hintText: "Enter your next of kin\'s Middle Name",
                hintStyle: const TextStyle(
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.normal,
                      fontSize: 13,
                ),
              ),
              validator: (value) {
                // if (value == null || value.isEmpty) {
                //   return 'Please enter your next of kin\'s Middle Name';
                // }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Next of Kin\'s Last Name ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: nokLastNameController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.nokLName = value;
                  saveNokLName(value);
                });
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                hintText: "Enter your next of kin\'s Last Name",
                hintStyle: const TextStyle(
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.normal,
                      fontSize: 13,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your next of kin\'s Last Name';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Next of Kin\'s Phone Number',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomPhoneNumberInput(
              onChanged: (String phone) {
                print(phone.toString());
                setState(() {
                  phone_number = phone.toString();
                  widget.customerData.nokPhone = phone_number;
                });
              },
              locale: 'en',
              initialCountry: 'UG',
              errorText: '     Number should be 9 characters',
              allowPickFromContacts: false,
              controller: phoneController,
              hint: 'For example 777026164',
              isMandatory: false,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red)),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Next of Kin\'s Alternative Phone Number  *Optional',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomPhoneNumberInput(
              onChanged: (String phone) {
                print(phone.toString());
                setState(() {
                  altPhone_number = phone.toString();
                  widget.customerData.nokAltPhone = altPhone_number;
                });
              },
              locale: 'en',
              initialCountry: 'UG',
              errorText: '     Number should be 9 characters',
              allowPickFromContacts: false,
              isMandatory: false,
              controller: altPhoneController,
              hint: 'For example 777026164',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red)),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      )
    );
  }

  Future<void> saveNokFName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nokFName', name);
  }

  Future<String?> getSavedNokFName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nokFName');

    if (name != null) {
      setState(() {
        nokFirstNameController.text = name;
        widget.customerData.nokFName = nokFirstNameController.text;
      });
    }
    return prefs.getString('nokFName');
  }

  Future<void> saveNokMName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nokMName', name);
  }

  Future<String?> getSavedNokMName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nokMName');

    if (name != null) {
      setState(() {
        nokMiddleNameController.text = name;
        widget.customerData.nokMName = nokMiddleNameController.text;
      });
    }
    return prefs.getString('nokMName');
  }

  Future<void> saveNokLName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nokLName', name);
  }

  Future<String?> getSavedNokLName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nokLName');

    if (name != null) {
      setState(() {
        nokLastNameController.text = name;
        widget.customerData.nokLName = nokLastNameController.text;
      });
    }
    return prefs.getString('nokLName');
  }

  // Future<void> saveNokPhone(String phone) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('nokPhone', phone);
  // }
  //
  // Future<String?> getSavedNokPhone() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? phone = prefs.getString('nokPhone');
  //
  //   if (phone != null) {
  //     setState(() {
  //       nokPhoneController.text = phone;
  //       widget.customerData.nokPhone = nokPhoneController.text;
  //     });
  //   }
  //   return prefs.getString('nokPhone');
  // }
  //
  // Future<void> saveNokAltPhone(String phone) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('nokAltPhone', phone);
  // }
  //
  // Future<String?> getSavedNokAltPhone() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? phone = prefs.getString('nokAltPhone');
  //
  //   if (phone != null) {
  //     setState(() {
  //       nokAltPhoneController.text = phone;
  //       widget.customerData.nokPhone = nokAltPhoneController.text;
  //     });
  //   }
  //   return prefs.getString('nokAltPhone');
  // }
}
