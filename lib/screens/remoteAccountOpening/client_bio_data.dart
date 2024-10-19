
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/theme.dart';

class ClientDetails extends StatefulWidget {
  final CustomerData customerData;

  ClientDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  _ClientDetailsState createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final List<String> titleDropdownItems = [
    'Mr',
    'Mrs',
    'Miss',
    'Other'
  ];

  String? selectedTitle;
  bool isTitleOther = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController NINController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController IDNoController = TextEditingController();
  TextEditingController IDExpiryController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  TextEditingController otherTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with data from the CustomerData object
    final customerData = widget.customerData;

    // Check if customerData.accountType is null or not in the dropdown items.
    if (titleDropdownItems.contains(customerData.title)) {
      selectedTitle = customerData.title;
    } else {
      // Set a default value or handle it as needed.
      selectedTitle =
          titleDropdownItems.first; // You can change this default value.
    }


    firstNameController.text = customerData.firstName ?? '';
    middleNameController.text = customerData.middleName ?? '';
    lastNameController.text = customerData.lastName ?? '';
    NINController.text = customerData.NIN ?? '';
    emailController.text = customerData.email ?? '';
    IDNoController.text = customerData.cardNo ?? '';
    IDExpiryController.text = customerData.IDExpiry ?? '';
    genderController.text = customerData.gender ?? '';
    DOBController.text = customerData.DOB ?? '';
    otherTitleController.text = customerData.otherTitle ?? '';

    getSavedTitle();
    getOtherTitle();
    getSavedEmail();
  }

  @override
  Widget build(BuildContext context) {
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
              'Title',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select an option',
                hintStyle: TextStyle(
                  fontFamily: "Manrope",
                  fontSize: 12,
                  color: Colors.grey,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
              ),
              value:
              selectedTitle, // Provide the currently selected value (can be null initially)
              onChanged: (newValue) {
                setState(() {
                  selectedTitle = newValue;
                  widget.customerData.title = newValue!;
                  saveSelectedTitle(selectedTitle!);

                  if (newValue == "Other"){
                    isTitleOther = true;
                  }else{
                    isTitleOther = false;
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
              items: titleDropdownItems.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                    ),
                  ),
                );
              }).toList(),
            ),
            isTitleOther ? Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: otherTitleController,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.bold
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.customerData.otherTitle = value;
                      saveOtherTitle(value);
                    });
                  },
                  keyboardType: TextInputType.text,
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
                    hintText: "Specify title: Doctor, Honourable etc",
                    hintStyle: const TextStyle(
                      fontFamily: "DMSans",
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                  // onChanged and initialValue can be added as needed
                ),
              ],
            ) : Container(),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Surname ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              enabled: false,
              controller: lastNameController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.lastName = value;
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Given Name ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              enabled: false,
              controller: firstNameController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.firstName = value;
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'ID Number (NIN)',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              enabled: false,
              controller: NINController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.NIN = value;
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIN cannot be empty';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'ID Card Number ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              enabled: false,
              keyboardType: TextInputType.number,
              controller: IDNoController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.cardNo = value;
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Card number cannot be empty';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'ID Expiry ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              enabled: false,
              controller: IDExpiryController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.IDExpiry = value;
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ID expiry cannot be empty';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender ',
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: genderController,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.bold
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.customerData.gender = value;
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gender cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date of Birth ',
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: DOBController,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.bold
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.customerData.DOB = value;
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date of Birth ';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Email Address ',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: emailController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.email = value;
                  saveEmail(value);
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
                  EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                hintText: "Enter your Email Address",
                hintStyle: const TextStyle(
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.normal,
                      fontSize: 13,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value == null){
                  return "Please enter your email address";
                } else
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 20,
            ),
            // Add other fields and validation logic for the Name form
          ],
        ),
      ),
    );
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('raoEmail', email);
  }

  Future<String?> getSavedEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('raoEmail');

    if (email != null) {
      setState(() {
        emailController.text = email;
        widget.customerData.email = emailController.text;
      });
    }
    return prefs.getString('IDFront');
  }

  Future<void> saveSelectedTitle(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTitle', title);
  }

  Future<String?> getSavedTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTitle = prefs.getString('selectedTitle');

    if (savedTitle != null) {
      setState(() {
        selectedTitle = savedTitle;
        widget.customerData.title = selectedTitle!;


        if (selectedTitle == "Other"){
          isTitleOther = true;
        }else{
          isTitleOther = false;
        }
      });
    }
    return prefs.getString('selectedTitle');
  }

  Future<void> saveOtherTitle(String otherTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('otherTitle', otherTitle);
  }

  Future<String?> getOtherTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedOtherTitle = prefs.getString('otherTitle');

    if (savedOtherTitle != null) {
      setState(() {
        otherTitleController.text = savedOtherTitle;
        widget.customerData.otherTitle = otherTitleController.text;
      });
    }
    return prefs.getString('otherTitle');
  }
}
