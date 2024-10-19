import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/theme.dart';
import '../home/components/custome_phone_number_input.dart';

class AltAccountDetails extends StatefulWidget {
  final CustomerData customerData;

  AltAccountDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  _AltAccountDetailsState createState() => _AltAccountDetailsState();
}

class _AltAccountDetailsState extends State<AltAccountDetails> {
  bool isLoading = true;
  String? selectedAltAcc;
  final List<String> altAccDropdownItems = [
    'Bank Account',
    'Mobile Money',
  ];

  @override
  void initState() {
    getSavedAltAcc();
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
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
            'Select Alternative Account (Bank Account or Mobile Money)',
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
              hintText: "Select Your Alternative Account Type",
              hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
            iconEnabledColor: Colors.black,
            style: const TextStyle(
              fontFamily: "DMSans",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            value:
            selectedAltAcc, // Provide the currently selected value (can be null initially)
            onChanged: (newValue) {
              setState(() {
                selectedAltAcc = newValue;
                widget.customerData.altAccount = newValue!;
                saveSelectedAltAcc(selectedAltAcc!);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an option';
              }
              return null;
            },
            items: altAccDropdownItems.map((String item) {
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
          const SizedBox(
            height: 16,
          ),
          if (selectedAltAcc == 'Bank Account')
            BankAccountForm(customerData: widget.customerData,),
          if (selectedAltAcc == 'Mobile Money')
            MobileMoneyForm(customerData: widget.customerData,),

        ],
      ),
      ),
    );
  }

  Future<void> saveSelectedAltAcc(String altAcc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('altAcc', altAcc);
  }

  Future<String?> getSavedAltAcc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAltAcc = prefs.getString('altAcc');

    if (savedAltAcc != null) {
      setState(() {
        selectedAltAcc = savedAltAcc;
        widget.customerData.altAccount = selectedAltAcc!;
      });
    }
    return prefs.getString('altAcc');
  }
}

class BankAccountForm extends StatefulWidget {
  final CustomerData customerData;
  const BankAccountForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<BankAccountForm> createState() => _BankAccountFormState();
}

class _BankAccountFormState extends State<BankAccountForm> {
  TextEditingController altAccountController = TextEditingController();
  TextEditingController accNameController = TextEditingController();
  TextEditingController bankNameAccountController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final customerData = widget.customerData;

    altAccountController.text = customerData.altAccountNo ?? '';
    accNameController.text = customerData.altAccountName ?? '';
    branchNameController.text = customerData.altBranchName ?? '';
    bankNameAccountController.text = customerData.altBankName ?? '';

    getAltAccName();
    getAltAccNo();
    getAltBankName();
    getAltBranchName();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alternative Account Number',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: altAccountController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.altAccount = value;
              saveAltAccNo(value);
            });
          },
          keyboardType: TextInputType.number,
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
            hintText: "Enter your alternative bank account number",
            hintStyle: const TextStyle(
              fontFamily: "DMSans",
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your alternative bank account number';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Account Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: accNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.altAccountName = value;
              saveAltAccName(value);
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
            hintText: "Enter the Account Name",
            hintStyle: const TextStyle(
              fontFamily: "DMSans",
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the account name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Bank Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: bankNameAccountController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.altBankName = value;
              saveAltBankName(value);
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
              hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              hintText: "Enter bank name"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the bank name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Branch Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: branchNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.altBranchName = value;
              saveAltBranchName(value);
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
            hintText: "Enter your account\'s branch name",
            hintStyle: const TextStyle(
              fontFamily: "DMSans",
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the branch name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Future<void> saveAltAccNo(String altAccNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('altAccNo', altAccNo);
  }

  Future<String?> getAltAccNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAltAccNo = prefs.getString('altAccNo');

    if (savedAltAccNo != null) {
      setState(() {
        altAccountController.text = savedAltAccNo;
        widget.customerData.altAccountNo = altAccountController.text;
      });
    }
    return prefs.getString('altAccNo');
  }

  Future<void> saveAltAccName(String altAccName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('altAccName', altAccName);
  }

  Future<String?> getAltAccName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAltAccName = prefs.getString('altAccName');

    if (savedAltAccName != null) {
      setState(() {
        accNameController.text = savedAltAccName;
        widget.customerData.businessAddress = accNameController.text;
      });
    }
    return prefs.getString('altAccName');
  }

  Future<void> saveAltBankName(String altBankName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('altBankName', altBankName);
  }

  Future<String?> getAltBankName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAltBankName= prefs.getString('altBankName');

    if (savedAltBankName != null) {
      setState(() {
        bankNameAccountController.text = savedAltBankName;
        widget.customerData.altBankName = bankNameAccountController.text;
      });
    }
    return prefs.getString('altBankName');
  }

  Future<void> saveAltBranchName(String altBranchName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('altBranchName', altBranchName);
  }

  Future<String?> getAltBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAltBranchName = prefs.getString('altBranchName');

    if (savedAltBranchName != null) {
      setState(() {
        branchNameController.text = savedAltBranchName;
        widget.customerData.altBranchName = branchNameController.text;
      });
    }
    return prefs.getString('altBranchName');
  }
}

class MobileMoneyForm extends StatefulWidget {
  final CustomerData customerData;
  const MobileMoneyForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<MobileMoneyForm> createState() => _MobileMoneyFormState();
}

class _MobileMoneyFormState extends State<MobileMoneyForm> {
  String selectedTeleco = '';
  String selectedNumberOwnership = '';
  String altPhone_number = '';

  @override
  void initState() {
    getSelectedMM();
    getSelectedOwner();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    PhoneNumberInputController? altPhoneController;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Mobile Money Provider',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: primaryLightVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'MTN',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold
                  ),
                ),
                value: 'MTN',
                groupValue: selectedTeleco,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedTeleco = value!;
                    widget.customerData.ownerTeleco = value;
                    saveSelectedMM(selectedTeleco);
                  });
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Airtel',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold
                  ),
                ),
                value: 'Airtel',
                groupValue: selectedTeleco,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedTeleco = value!;
                    widget.customerData.ownerTeleco = value;
                    saveSelectedMM(selectedTeleco);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Is this number registered to you?',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: primaryLightVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold
                  ),
                ),
                value: 'Yes',
                groupValue: selectedNumberOwnership,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedNumberOwnership = value!;
                    widget.customerData.ownership = value;
                    saveSelectedOwner(selectedNumberOwnership);
                  });
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold
                  ),
                ),
                value: 'No',
                groupValue: selectedNumberOwnership,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedNumberOwnership = value!;
                    widget.customerData.ownership = value;
                    saveSelectedOwner(selectedNumberOwnership);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Phone Number',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomPhoneNumberInput(
          onChanged: (String phone) {
            setState(() {
              altPhone_number = phone.toString();
              widget.customerData.mobileMoneyNo = altPhone_number;
            });
          },
          locale: 'en',
          initialCountry: 'UG',
          errorText: '     Number should be 9 characters',
          allowPickFromContacts: false,
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
        if (selectedNumberOwnership == 'No')
          PhoneOwnerForm(customerData: widget.customerData,),
      ],
    );
  }

  Future<void> saveSelectedMM(String selectedMM) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedMM', selectedMM);
  }

  Future<String?> getSelectedMM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSelectedMM = prefs.getString('selectedMM');

    if (savedSelectedMM != null) {
      setState(() {
        selectedTeleco = savedSelectedMM;
        widget.customerData.ownerTeleco = selectedTeleco;
      });
    }
    return prefs.getString('selectedMM');
  }

  Future<void> saveSelectedOwner(String selectedOwner) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedOwner', selectedOwner);
  }

  Future<String?> getSelectedOwner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSelectedOwner = prefs.getString('selectedOwner');

    if (savedSelectedOwner != null) {
      setState(() {
        selectedNumberOwnership = savedSelectedOwner;
        widget.customerData.ownership = selectedNumberOwnership;
      });
    }
    return prefs.getString('selectedOwner');
  }
}

class PhoneOwnerForm extends StatefulWidget {
  final CustomerData customerData;
  const PhoneOwnerForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<PhoneOwnerForm> createState() => _PhoneOwnerFormState();
}

class _PhoneOwnerFormState extends State<PhoneOwnerForm> {
  TextEditingController ownerFNameController = TextEditingController();
  TextEditingController ownerLNameController = TextEditingController();

  @override
  void initState() {
    final customerData = widget.customerData;
    ownerFNameController.text = customerData.ownerFName ?? '';
    ownerLNameController.text = customerData.ownerLName ?? '';

    getPhoneOwnerFName();
    getPhoneOwnerLName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'First Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: ownerFNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.ownerFName = value;
              savePhoneOwnerFName(value);
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
              hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              hintText: "Enter Phone Owner\'s First Name"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the phone owner\'s first name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Last Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: ownerLNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.ownerLName = value;
              savePhoneOwnerLName(value);
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
              hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              hintText: "Enter Phone Owner\'s Last Name"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the phone owner\'s last name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }

  Future<void> savePhoneOwnerFName(String phoneOwnerFName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneOwnerFName', phoneOwnerFName);
  }

  Future<String?> getPhoneOwnerFName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhoneOwnerFName = prefs.getString('phoneOwnerFName');

    if (savedPhoneOwnerFName != null) {
      setState(() {
        ownerFNameController.text = savedPhoneOwnerFName;
        widget.customerData.ownerFName = ownerFNameController.text;
      });
    }
    return prefs.getString('phoneOwnerFName');
  }

  Future<void> savePhoneOwnerLName(String phoneOwnerLName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneOwnerLName', phoneOwnerLName);
  }

  Future<String?> getPhoneOwnerLName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhoneOwnerLName = prefs.getString('phoneOwnerLName');

    if (savedPhoneOwnerLName != null) {
      setState(() {
        ownerLNameController.text = savedPhoneOwnerLName;
        widget.customerData.ownerLName = ownerLNameController.text;
      });
    }
    return prefs.getString('phoneOwnerLName');
  }
}