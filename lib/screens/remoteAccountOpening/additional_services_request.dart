import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/theme.dart';
import '../home/components/custome_phone_number_input.dart';

class AdditionalDetails extends StatefulWidget {
  final CustomerData customerData;

  AdditionalDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
 String? selectedMedia;
 String mediaText = '';
 String phone_number = '';

  @override
  void initState() {
    super.initState();
    getMediaType();
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
              'How did you get to know about us?',
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
                      'TV/Radio Station',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    value: 'TV/Radio Station',
                    groupValue: selectedMedia,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedMedia = value!;
                        widget.customerData.mediaType = value;
                        mediaText = 'Enter Tv/Radio Station Name';
                        saveMediaType(value);
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
                      'Social Media',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    value: 'Social Media',
                    groupValue: selectedMedia,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedMedia = value!;
                        widget.customerData.mediaType = value;
                        mediaText = 'Select Social Media Platform';
                        saveMediaType(value);
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
                      'Bank Staff',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    value: 'Bank Staff',
                    groupValue: selectedMedia,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedMedia = value!;
                        widget.customerData.mediaType = value;
                        mediaText = 'Bank Staff';
                        saveMediaType(value);
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
                      'Customer',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    value: 'Customer',
                    groupValue: selectedMedia,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedMedia = value!;
                        widget.customerData.mediaType = value;
                        mediaText = 'Customer';
                        saveMediaType(value);
                      });
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'HFB Agent',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    value: 'HFB Agent',
                    groupValue: selectedMedia,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedMedia = value!;
                        widget.customerData.mediaType = value;
                        mediaText = 'Agent';
                        saveMediaType(value);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (selectedMedia == 'TV/Radio Station')
              TvRadioForm(customerData: widget.customerData, mediaText: mediaText,),
            if (selectedMedia == 'Customer' || selectedMedia == 'Bank Staff' || selectedMedia == 'HFB Agent')
              OthersForm(customerData: widget.customerData, mediaText: mediaText,),
            if (selectedMedia == 'Social Media')
              SocialMediaForm(customerData: widget.customerData, mediaText: mediaText,),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

 Future<void> saveMediaType(String mediaType) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString('mediaType', mediaType);
 }

 Future<String?> getMediaType() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? savedMediaType = prefs.getString('mediaType');

   if (savedMediaType != null) {
     setState(() {
       selectedMedia = savedMediaType;
       widget.customerData.mediaType = selectedMedia!;
     });
   }
   return prefs.getString('mediaName');
 }
}

class TvRadioForm extends StatefulWidget {
  final CustomerData customerData;
  final String mediaText;
  const TvRadioForm({Key? key, required this.customerData, required this.mediaText}) : super(key: key);

  @override
  State<TvRadioForm> createState() => _TvRadioFormState();
}

class _TvRadioFormState extends State<TvRadioForm> {
  TextEditingController tvController = TextEditingController();

  @override
  void initState() {
    final customerData = widget.customerData;
    tvController.text = customerData.otherIncome ?? '';
    getMediaName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.mediaText,
          style: const TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: tvController,
          style: const TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.mediaName = value;
              saveMediaName(value);
            });
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              hintText: widget.mediaText
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please ${widget.mediaText}';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
      ],
    );
  }

  Future<void> saveMediaName(String mediaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mediaName', mediaName);
  }

  Future<String?> getMediaName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMediaName = prefs.getString('mediaName');

    if (savedMediaName != null) {
      setState(() {
        tvController.text = savedMediaName;
        widget.customerData.mediaName = tvController.text;
      });
    }
    return prefs.getString('mediaName');
  }

}

class SocialMediaForm extends StatefulWidget {
  final CustomerData customerData;
  final String mediaText;
  const SocialMediaForm({Key? key, required this.customerData, required this.mediaText}) : super(key: key);

  @override
  State<SocialMediaForm> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMediaForm> {
  String? selectedMedia;

  @override
  void initState() {
    final customerData = widget.customerData;
    selectedMedia = customerData.mediaName ?? '';
    getMediaName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.mediaText,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
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
                  'Facebook',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold
                  ),
                ),
                value: 'Facebook',
                groupValue: selectedMedia,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedMedia = value!;
                    widget.customerData.mediaName = value;
                    saveMediaName(value);
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
                  'X (former Twitter)',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold
                  ),
                ),
                value: 'X (former Twitter)',
                groupValue: selectedMedia,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedMedia = value!;
                    widget.customerData.mediaName = value;
                    saveMediaName(value);
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
                  'Instagram',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold
                  ),
                ),
                value: 'Instagram',
                groupValue: selectedMedia,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedMedia = value!;
                    widget.customerData.mediaName = value;
                    saveMediaName(value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> saveMediaName(String mediaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mediaName', mediaName);
  }

  Future<String?> getMediaName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMediaName = prefs.getString('mediaName');

    if (savedMediaName != null) {
      setState(() {
        selectedMedia = savedMediaName;
        widget.customerData.mediaName = selectedMedia!;
      });
    }
    return prefs.getString('mediaName');
  }
}

class OthersForm extends StatefulWidget {
  final CustomerData customerData;
  final String mediaText;
  const OthersForm({Key? key, required this.customerData, required this.mediaText}) : super(key: key);

  @override
  State<OthersForm> createState() => _OthersFormState();
}

class _OthersFormState extends State<OthersForm> {
  TextEditingController mediaNameController = TextEditingController();
  String phone_number = '';

  @override
  void initState() {
    super.initState();
    final customerData = widget.customerData;
    getMediaName();
    mediaNameController.text = customerData.mediaName;
  }

  @override
  Widget build(BuildContext context) {
    PhoneNumberInputController? phoneController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.mediaText} Name',
          style: const TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: mediaNameController,
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold
          ),
          onChanged: (value) {
            setState(() {
              widget.customerData.mediaName = value;
              saveMediaName(value);
            });
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              hintStyle: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              hintText: 'Enter ${widget.mediaText} Name'
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter ${widget.mediaText} Name';
              // return 'Please enter Name';
            }
            return null;
          },
          // onChanged and initialValue can be added as needed
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          '${widget.mediaText} Phone Number',
          style: TextStyle(
              fontSize: 13,
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomPhoneNumberInput(
          onChanged: (String phone) {
            setState(() {
              phone_number = phone.toString();
              print(phone_number);
              widget.customerData.mediaPhone = phone_number;
            });
          },
          locale: 'en',
          initialCountry: 'UG',
          errorText: '     Number should be 9 characters',
          allowPickFromContacts: false,
          controller: phoneController,
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
      ],
    );
  }

  Future<void> saveMediaName(String mediaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mediaName', mediaName);
  }

  Future<String?> getMediaName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMediaName = prefs.getString('mediaName');

    if (savedMediaName != null) {
      setState(() {
        mediaNameController.text = savedMediaName;
        widget.customerData.mediaName = mediaNameController.text;
      });
    }
    return prefs.getString('mediaName');
  }

  // Future<void> saveMediaPhone(String mediaPhone) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mediaPhone', mediaPhone);
  // }
  //
  // Future<String?> getMediaPhone() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedMediaPhone = prefs.getString('mediaPhone');
  //
  //   if (savedMediaPhone != null) {
  //     setState(() {
  //       mediaNameController.text = savedMediaPhone;
  //       widget.customerData.mediaName = mediaNameController.text;
  //     });
  //   }
  //   return prefs.getString('mediaPhone');
  // }
}
