import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/theme.dart';

class PEPExposure extends StatefulWidget {
  final CustomerData customerData;
  const PEPExposure({Key? key, required this.customerData}) : super(key: key);

  @override
  State<PEPExposure> createState() => _PEPExposureState();
}

class _PEPExposureState extends State<PEPExposure> {
  String selectedIsExposed = '';
  bool showPepDescription = true;

  @override
  void initState() {
    // TODO: implement initState
    getPep();
    super.initState();
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
            showPepDescription ?
            Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance, color: primaryColor, size: 28), // Add any relevant icon
                        const SizedBox(width: 8),
                        Text(
                          'PEP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '“Politically Exposed Person” means individual(s) who is or has been entrusted with prominent functions of a country, with examples under office & position description below, as well as family members or close associates of such individuals.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Manrope",
                        color: Colors.black87,
                        height: 1.5, // For line height
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            showPepDescription = false;
                          });
                        },
                        child: Text(
                          'Hide',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  showPepDescription = true;
                });
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/about.png",
                    fit: BoxFit.cover,
                    height: 24,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'View PEP Definition',
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.bold,
                      color: primaryColor
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Do you hold/have you ever held a senior government position (Executive Director of a state-owned agency, Permanent secretary), political or military position?',
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
                    groupValue: selectedIsExposed,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedIsExposed = value!;
                        widget.customerData.pepIsExposed = selectedIsExposed;
                        savePep(selectedIsExposed);
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
                    groupValue: selectedIsExposed,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedIsExposed = value!;
                        widget.customerData.pepIsExposed = selectedIsExposed;
                        savePep(selectedIsExposed);
                      });
                    },
                  ),
                ],
              ),
            ),
            if (selectedIsExposed == 'Yes')
              YesPEPForm(customerData: widget.customerData,),
            if (selectedIsExposed == 'No')
              NoPEPForm(customerData: widget.customerData,),
          ],
        ),
      ),
    );
  }

  Future<void> savePep(String pep) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pep', pep);
  }

  Future<String?> getPep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPep = prefs.getString('pep');

    if (savedPep != null) {
      setState(() {
        selectedIsExposed = savedPep;
        widget.customerData.pepIsExposed = selectedIsExposed;
      });
    }
    return prefs.getString('pep');
  }
}

class YesPEPForm extends StatefulWidget {
  final CustomerData customerData;
  const YesPEPForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<YesPEPForm> createState() => _YesPEPFormState();
}

class _YesPEPFormState extends State<YesPEPForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController startYearController = TextEditingController();
  TextEditingController endYearController = TextEditingController();
  TextEditingController specifiedPositionController = TextEditingController();
  String? selectedPosition;

  final List<String> positionDropdownItems = [
  'Head of state or head of government / President',
  'Police commissioner / Inspector General / Police Director',
  'Member of the executive council of government or member of Parliament',
  'Cabinet Ministers and their Deputies Deputy Minister',
  'Ambassador or attaché or counsellor of an ambassador ',
  'Military officer with a rank of general or above',
  'Chiefs / Kings / Cultural leader',
  'Chief Administrative officer / Town clerk / LC 5 Chairperson',
  'Director of a state-owned company or a state-owned bank / corporations',
  'Judge / Magistrate / state Attorney',
  'Leader or president of a political party',
  'Other',
  ];

  @override
  void initState() {
    final customerData = widget.customerData;
    titleController.text = customerData.pepTitle ?? '';
    countryController.text = customerData.pepCountry ?? '';
    startYearController.text = customerData.pepStartYear ?? '';
    endYearController.text = customerData.pepEndYear ?? '';
    specifiedPositionController.text = customerData.pepSpecifiedTitle ?? '';

    getPepCountry();
    getPepPosition();
    getPepStartYear();
    getPepEndYear();
    getPepTitle();
    getPepSpecPosition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Select the senior government, political or military position held',
          style: TextStyle(
              fontSize: 13,
              fontFamily: 'Manrope',
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
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            hintText: "Select Position",
            hintStyle: TextStyle(
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
          value: selectedPosition,
          onChanged: (newValue) {
            setState(() {
              selectedPosition = newValue;
              widget.customerData.pepPosition = newValue!;
              savePepPosition(selectedPosition!);
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          items: positionDropdownItems.map((String item) {
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
          selectedItemBuilder: (BuildContext context) {
            return positionDropdownItems.map((String item) {
              return Container(
                width: MediaQuery.of(context).size.width - 90,
                child:  Text(
                  item,
                  overflow: TextOverflow.ellipsis,  // Ensure ellipsis appears in selected view
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Manrope",
                  ),
                ),
              );
            }).toList();
          },
        ),
        const SizedBox(
          height: 8,
        ),
       selectedPosition == "Other" ?
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text(
                 'Kindly specify position held',
                 style: TextStyle(
                     fontSize: 13,
                     fontFamily: "Manrope",
                     fontWeight: FontWeight.normal),
               ),
               const SizedBox(
                 height: 8,
               ),
               TextFormField(
                 controller: specifiedPositionController,
                 style: TextStyle(
                     fontSize: 13,
                     fontFamily: "Manrope",
                     fontWeight: FontWeight.bold
                 ),
                 onChanged: (value) {
                   setState(() {
                     widget.customerData.pepSpecifiedTitle = value;
                     savePepSpecPosition(value);
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
                     hintText: "Position"
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Please specify the position held ';
                   }
                   return null;
                 },
                 // onChanged and initialValue can be added as needed
               ),
               const SizedBox(
                 height: 8,
               ),
             ],
           ) : Container(),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Please enter the title of the position and country where the same was held',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Title of the position held',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: titleController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepTitle = value;
              savePepTitle(value);
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
              hintText: "Title"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the title of the position held';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Country where the position was held',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: countryController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepCountry = value;
              savePepCountry(value);
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
              hintText: "Country"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the country where this role was assumed';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'During what period was the position held?',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Start Year',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: startYearController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepStartYear = value;
              savePepStartYear(value);
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
              hintText: "Year"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the year this role was assumed';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'End Year',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: endYearController,
          style: const TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepEndYear = value;
              savePepEndYear(value);
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
              hintText: "Year"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the end year of having this role';
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

  Future<void> savePepPosition(String pepPosition) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepPosition', pepPosition);
  }

  Future<String?> getPepPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepPosition = prefs.getString('pepPosition');

    if (savedPepPosition != null) {
      setState(() {
        selectedPosition = savedPepPosition;
        widget.customerData.pepPosition = selectedPosition!;
      });
    }
    return prefs.getString('pepPosition');
  }

  Future<void> savePepSpecPosition(String pepSpecPosition) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepSpecPosition', pepSpecPosition);
  }

  Future<String?> getPepSpecPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepSpecPosition = prefs.getString('pepSpecPosition');

    if (savedPepSpecPosition != null) {
      setState(() {
        specifiedPositionController.text = savedPepSpecPosition;
        widget.customerData.pepSpecifiedTitle = specifiedPositionController.text;
      });
    }
    return prefs.getString('pepSpecPosition');
  }

  Future<void> savePepTitle(String pepTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepTitle', pepTitle);
  }

  Future<String?> getPepTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepTitle = prefs.getString('pepTitle');

    if (savedPepTitle != null) {
      setState(() {
        titleController.text = savedPepTitle;
        widget.customerData.pepTitle = titleController.text;
      });
    }
    return prefs.getString('pepTitle');
  }

  Future<void> savePepCountry(String pepCountry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepCountry', pepCountry);
  }

  Future<String?> getPepCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepCountry = prefs.getString('pepCountry');

    if (savedPepCountry != null) {
      setState(() {
        countryController.text = savedPepCountry;
        widget.customerData.pepCountry = countryController.text;
      });
    }
    return prefs.getString('pepCountry');
  }

  Future<void> savePepStartYear(String startYear) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('startYear', startYear);
  }

  Future<String?> getPepStartYear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepStartYear = prefs.getString('startYear');

    if (savedPepStartYear != null) {
      setState(() {
        startYearController.text = savedPepStartYear;
        widget.customerData.pepStartYear = startYearController.text;
      });
    }
    return prefs.getString('startYear');
  }

  Future<void> savePepEndYear(String endYear) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('endYear', endYear);
  }

  Future<String?> getPepEndYear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepEndYear = prefs.getString('endYear');

    if (savedPepEndYear != null) {
      setState(() {
        endYearController.text = savedPepEndYear;
        widget.customerData.pepEndYear = endYearController.text;
      });
    }
    return prefs.getString('endYear');
  }

}

class NoPEPForm extends StatefulWidget {
  final CustomerData customerData;
  const NoPEPForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<NoPEPForm> createState() => _NoPEPFormState();
}

class _NoPEPFormState extends State<NoPEPForm> {
  String selectedHasExposedRelative = '';
  @override
  void initState() {
    getHasPepRel();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Are you connected to a person who holds or has held a senior government position (Executive Director of a state-owned agency, Permanent secretary), political or military position?',
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
                groupValue: selectedHasExposedRelative,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedHasExposedRelative = value!;
                    widget.customerData.hasPepRelative = value;
                    saveHasPepRel(selectedHasExposedRelative);
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
                groupValue: selectedHasExposedRelative,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedHasExposedRelative = value!;
                    widget.customerData.hasPepRelative = value;
                    saveHasPepRel(selectedHasExposedRelative);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        if (selectedHasExposedRelative == 'Yes')
          YesRelativePEPForm(customerData: widget.customerData,),
      ],
    );
  }


  Future<void> saveHasPepRel(String hasPepRel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hasPepRel', hasPepRel);
  }

  Future<String?> getHasPepRel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedHasPepRel = prefs.getString('hasPepRel');

    if (savedHasPepRel != null) {
      setState(() {
        selectedHasExposedRelative = savedHasPepRel;
        widget.customerData.hasPepRelative = selectedHasExposedRelative;
      });
    }
    return prefs.getString('hasPepRel');
  }
}

class YesRelativePEPForm extends StatefulWidget {
  final CustomerData customerData;
  const YesRelativePEPForm({Key? key, required this.customerData}) : super(key: key);

  @override
  State<YesRelativePEPForm> createState() => _YesRelativePEPFormState();
}

class _YesRelativePEPFormState extends State<YesRelativePEPForm> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController initalController = TextEditingController();
  TextEditingController pepRelationshipController = TextEditingController();
  TextEditingController specifiedRelationshipController = TextEditingController();
  String? selectedRelationship;

  final List<String> relationshipDropdownItems = [
  'Close relative – Mother /Father / Child ',
  'Father',
  'Child',
  'close associate',
  'Spouse or Common-Law Partner',
  'Mother or Father of a spouse to a PEP',
  'Sibling (Brother, Sister, Half-Sibling, Stepsibling, Adoptive Sibling)',
  'Other',
  ];

  @override
  void initState() {
    final customerData = widget.customerData;
    fNameController.text = customerData.pepRFName ?? '';
    lNameController.text = customerData.pepRLName ?? '';
    initalController.text = customerData.pepInitial ?? '';

    getPepRelFName();
    getPepRelIn();
    getPepRelLName();
    getPepRlshp();
    getPepSpecRlshp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Select your relationship with the politically exposed family member or close associate',
          style: TextStyle(
              fontSize: 13,
              fontFamily: 'Manrope',
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
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            hintText: "Select Relationship",
            hintStyle: TextStyle(
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
          value: selectedRelationship,
          onChanged: (newValue) {
            setState(() {
              selectedRelationship = newValue;
              widget.customerData.pepRelationship = newValue!;
              savePepRlshp(newValue);
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          items: relationshipDropdownItems.map((String item) {
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
          selectedItemBuilder: (BuildContext context) {
            return relationshipDropdownItems.map((String item) {
              return Container(
                width: MediaQuery.of(context).size.width - 90,
                child:  Text(
                  item,
                  overflow: TextOverflow.ellipsis,  // Ensure ellipsis appears in selected view
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Manrope",
                  ),
                ),
              );
            }).toList();
          },
        ),
        const SizedBox(
          height: 8,
        ),
        selectedRelationship == "Other" ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kindly specify your relationship with the politically exposed person',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: specifiedRelationshipController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.pepSpecifiedRelationship = value;
                  savePepSpecRlshp(value);
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
                  hintText: "Relationship"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please specify your relationship with the PEP';
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ) : Container(),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'What is the name of the politically exposed person you are a related to?',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'First Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: fNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepRFName = value;
              savePepRelFName(value);
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
              hintText: "Relative\'s First Name"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter relative\'s first name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Last Name',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: lNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepRLName = value;
              savePepRelLName(value);
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
              hintText: "Relative\'s Last Name"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your relative\'s last name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Initial',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: initalController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.pepInitial = value;
              savePepRelIn(value);
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
              hintText: "Relative\'s Initials"
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your relative\'s initials';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        YesPEPForm(customerData: widget.customerData)
      ],
    );
  }

  Future<void> savePepRlshp(String pepRlshp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepRlshp', pepRlshp);
  }

  Future<String?> getPepRlshp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepRlshp = prefs.getString('pepRlshp');

    if (savedPepRlshp != null) {
      setState(() {
        selectedRelationship = savedPepRlshp;
        widget.customerData.pepRelationship = selectedRelationship!;
      });
    }
    return prefs.getString('pepRlshp');
  }

  Future<void> savePepSpecRlshp(String pepSpecRlshp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepSpecRlshp', pepSpecRlshp);
  }

  Future<String?> getPepSpecRlshp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepSpecRlshp = prefs.getString('pepSpecRlshp');

    if (savedPepSpecRlshp != null) {
      setState(() {
        specifiedRelationshipController.text = savedPepSpecRlshp;
        widget.customerData.pepSpecifiedRelationship = specifiedRelationshipController.text;
      });
    }
    return prefs.getString('pepSpecRlshp');
  }

  Future<void> savePepRelFName(String pepRelFName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepRelFName', pepRelFName);
  }

  Future<String?> getPepRelFName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepRelFName = prefs.getString('pepRelFName');

    if (savedPepRelFName != null) {
      setState(() {
        fNameController.text = savedPepRelFName;
        widget.customerData.pepRFName = fNameController.text;
      });
    }
    return prefs.getString('pepRelFName');
  }

  Future<void> savePepRelLName(String pepRelLName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepRelLName', pepRelLName);
  }

  Future<String?> getPepRelLName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepRelLName = prefs.getString('pepRelLName');

    if (savedPepRelLName != null) {
      setState(() {
        lNameController.text = savedPepRelLName;
        widget.customerData.pepRLName = lNameController.text;
      });
    }
    return prefs.getString('pepRelLName');
  }

  Future<void> savePepRelIn(String pepRelIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pepRelIn', pepRelIn);
  }

  Future<String?> getPepRelIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPepRelIn = prefs.getString('pepRelIn');

    if (savedPepRelIn != null) {
      setState(() {
        initalController.text = savedPepRelIn;
        widget.customerData.pepInitial = initalController.text;
      });
    }
    return prefs.getString('pepRelIn');
  }
}