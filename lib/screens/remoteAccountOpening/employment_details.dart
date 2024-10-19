import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/theme.dart';

class EmploymentDetails extends StatefulWidget {
  final CustomerData customerData;

  EmploymentDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  _EmploymentDetailsState createState() => _EmploymentDetailsState();
}

class _EmploymentDetailsState extends State<EmploymentDetails> {
  String? selectedEmpType;

  Future<void> saveSelectedEmpType(String empType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedEmpType', empType);
  }


  Future<String?> getSavedEmpType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedEmpType');
  }

  @override
  void initState() {
    super.initState();
    getSavedEmpTyp();
  }


  final List<String> empTypeDropdownItems = [
    'Self-Employed/Business',
    'Employed/Salary',
    'Others',
  ];

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
              'Employment Type',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Manrope",
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
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
                hintText: "Select Your Occupation Type",
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
              selectedEmpType, // Provide the currently selected value (can be null initially)
              onChanged: (newValue) {
                setState(() {
                  selectedEmpType = newValue;
                  widget.customerData.employmentType = newValue!;
                  saveSelectedEmpTyp(selectedEmpType!);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
              items: empTypeDropdownItems.map((String item) {
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
            if (selectedEmpType == 'Self-Employed/Business')
              SelfEmployedForm(customerData: widget.customerData,),
            if (selectedEmpType == 'Employed/Salary')
              EmployedForm(customerData: widget.customerData,),
            if (selectedEmpType == 'Others')
              OthersForm(customerData: widget.customerData,),
          ],
        ),
      ),
    );
  }

  Future<void> saveSelectedEmpTyp(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedEmpTyp', status);
  }

  Future<String?> getSavedEmpTyp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmpTyp = prefs.getString('selectedEmpTyp');

    if (savedEmpTyp != null) {
      setState(() {
        selectedEmpType = savedEmpTyp;
        widget.customerData.employmentType = selectedEmpType!;
      });
    }
    return prefs.getString('selectedEmpTyp');
  }
}

class SelfEmployedForm extends StatefulWidget {
  final CustomerData customerData;
  const SelfEmployedForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<SelfEmployedForm> createState() => _SelfEmployedFormState();
}

class _SelfEmployedFormState extends State<SelfEmployedForm> {
  TextEditingController nobController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

  @override
  void initState() {
    final customerData = widget.customerData;
    incomeController.text = customerData.income ?? '';

    getBAddress();
    getIncome();
    getNOB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Income',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: incomeController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.income = value;
              saveIncome(value);
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _AmountTextInputFormatter(), // Custom formatter for adding commas
          ],
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
              hintText: "Enter Monthly Income"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your monthly income';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Business Address',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: businessAddressController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.businessAddress = value;
              saveBAddress(value);
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
            hintText: "Enter your business\'s address",
            hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business address';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Nature of Business/Activity Sector',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: nobController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.nob = value;
              saveNOB(value);
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
            hintText: "Enter the nature of your business",
            hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                  fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the nature of your business';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
      ],
    );
  }
  
  Future<void> saveIncome(String income) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('income', income);
  }

  Future<String?> getIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedIncome = prefs.getString('income');

    if (savedIncome != null) {
      setState(() {
        incomeController.text = savedIncome;
        widget.customerData.income = incomeController.text;
      });
    }
    return prefs.getString('income');
  }

  Future<void> saveBAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bAddress', address);
  }

  Future<String?> getBAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedBAddress = prefs.getString('bAddress');

    if (savedBAddress != null) {
      setState(() {
        businessAddressController.text = savedBAddress;
        widget.customerData.businessAddress = businessAddressController.text;
      });
    }
    return prefs.getString('bAddress');
  }

  Future<void> saveNOB(String nob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nob', nob);
  }

  Future<String?> getNOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNob = prefs.getString('nob');

    if (savedNob != null) {
      setState(() {
        nobController.text = savedNob;
        widget.customerData.nob = nobController.text;
      });
    }
    return prefs.getString('nob');
  }
}

class EmployedForm extends StatefulWidget {
  final CustomerData customerData;
  const EmployedForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<EmployedForm> createState() => _EmployedFormState();
}

class _EmployedFormState extends State<EmployedForm> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  String? selectedDuration;

  @override
  void initState() {
    final customerData = widget.customerData;
    incomeController.text = customerData.income ?? '';

    getSalary();
    getEmpName();
    getEmpAddress();
    getOccupation();
    getPOE();
    getDuration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Employer\'s Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: employerController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.empName = value;
              saveEmpName(value);
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
            hintText: "Enter your employer\'s name",
            hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                  fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your employer\'s name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Employer Address',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: businessAddressController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.businessAddress = value;
              saveEmpAddress(value);
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
            hintText: "Enter your current country of residence",
            hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                  fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your employer\'s address';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Monthly Salary',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: incomeController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.income = value;
              saveSalary(value);
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _AmountTextInputFormatter(), // Custom formatter for adding commas
          ],
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
              hintText: "Enter your monthly Salary"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your monthly salary';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Occupation',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: occupationController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.occupation = value;
              saveOccupation(value);
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
            hintText: "Enter your occupation",
            hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                  fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your occupation';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Period Of Employment',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: periodController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.period = value;
              savePOE(value);
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
            hintText: "Enter how long you have been working here",
            hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                  fontSize: 13,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your period of employment';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDuration = "Years";
                    widget.customerData.duration = selectedDuration!;
                    saveDuration(selectedDuration!);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDuration == "Years" ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Years',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: selectedDuration == "Years" ? Colors.white : primaryColor,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDuration = "Months";
                    widget.customerData.duration = selectedDuration!;
                    saveDuration(selectedDuration!);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDuration == "Months" ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Months',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: selectedDuration == "Months" ? Colors.white : primaryColor,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Future<void> saveEmpName(String empName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('empName', empName);
  }

  Future<String?> getEmpName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmpName = prefs.getString('empName');

    if (savedEmpName != null) {
      setState(() {
        employerController.text = savedEmpName;
        widget.customerData.empName = employerController.text;
      });
    }
    return prefs.getString('empName');
  }

  Future<void> saveEmpAddress(String empAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('empAddress', empAddress);
  }

  Future<String?> getEmpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmpAddress = prefs.getString('empAddress');

    if (savedEmpAddress != null) {
      setState(() {
        businessAddressController.text = savedEmpAddress;
        widget.customerData.businessAddress = businessAddressController.text;
      });
    }
    return prefs.getString('empAddress');
  }

  Future<void> saveSalary(String salary) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('salary', salary);
  }

  Future<String?> getSalary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSalary = prefs.getString('salary');

    if (savedSalary != null) {
      setState(() {
        incomeController.text = savedSalary;
        widget.customerData.income = incomeController.text;
      });
    }
    return prefs.getString('salary');
  }

  Future<void> saveOccupation(String occupation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('occupation', occupation);
  }

  Future<String?> getOccupation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedOccupation = prefs.getString('occupation');

    if (savedOccupation != null) {
      setState(() {
        occupationController.text = savedOccupation;
        widget.customerData.occupation = occupationController.text;
      });
    }
    return prefs.getString('occupation');
  }

  Future<void> savePOE(String poe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('poe', poe);
  }

  Future<String?> getPOE() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPoe = prefs.getString('poe');

    if (savedPoe != null) {
      setState(() {
        periodController.text = savedPoe;
        widget.customerData.period = periodController.text;
      });
    }
    return prefs.getString('poe');
  }

  Future<void> saveDuration(String duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('duration', duration);
  }

  Future<String?> getDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDoe = prefs.getString('duration');

    if (savedDoe != null) {
      setState(() {
        selectedDuration = savedDoe;
        widget.customerData.duration = selectedDuration!;
      });
    }
    return prefs.getString('duration');
  }
}

class OthersForm extends StatefulWidget {
  final CustomerData customerData;
  const OthersForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<OthersForm> createState() => _OthersFormState();
}

class _OthersFormState extends State<OthersForm> {
  TextEditingController otherController = TextEditingController();

  @override
  void initState() {
    final customerData = widget.customerData;
    otherController.text = customerData.otherIncome ?? '';
    getOtherIncome();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kindly Specify',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: otherController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.otherIncome = value;
              saveOtherIncome(value);
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _AmountTextInputFormatter(), // Custom formatter for adding commas
          ],
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
              hintText: "Allowance"
          ),
          validator: (value) {
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
      ],
    );
  }

  Future<void> saveOtherIncome(String otherIncome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('otherIncome', otherIncome);
  }

  Future<String?> getOtherIncome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedOtherIncome = prefs.getString('otherIncome');

    if (savedOtherIncome != null) {
      setState(() {
        otherController.text = savedOtherIncome;
        widget.customerData.otherIncome = otherController.text;
      });
    }
    return prefs.getString('otherIncome');
  }
  
}

class _AmountTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final double amount = double.parse(newValue.text.replaceAll(',', ''));

    final formatter = NumberFormat("#,##0", "en_US");
    final newText = formatter.format(amount);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
