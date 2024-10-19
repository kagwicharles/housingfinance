import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../theme/theme.dart';
import '../home/components/custome_phone_number_input.dart';

class PersonalDetails extends StatefulWidget {
  final CustomerData customerData;
  const PersonalDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  File? customerImageFile;
  File? idFrontImageFile;
  File? idBackImageFile;
  File? signatureImageFile;
  String? currentPhoto;
  late ProgressDialog progressDialog;
  late TextRecognizer textRecognizer;

  String phone_number = '';
  String altPhone_number = '';
  String recognizedText = "";
  String? selectedStatus;
  String? customerPhoto;
  String? idFrontPhoto;
  String? idBackPhoto;
  String? signaturePhoto;
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String progressbarTitle = "";
  String progressbarMessage = "Processing...";
  String imageURL = "";
  String processID = "";
  String nationality = "";
  String sex = "";
  String CardNumber = "";
  String DateOfExpiry = "";
  String dob = "";
  String NIN = "";
  String Name = "";
  String surName = "";

  final List<String> maritalDropdownItems = [
    'Married',
    'Single',
    'Divorced',
    'Separated',
    'Widowed/Widower'
  ];

  @override
  void initState() {
    super.initState();
    final customerData = widget.customerData;
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    countryController.text = customerData.country ?? '';
    addressController.text = customerData.address ?? '';
    customerImageFile = customerData.customerImageFile;
    idFrontImageFile = customerData.idFrontImageFile;
    idBackImageFile = customerData.idBackImageFile;
    signatureImageFile = customerData.signatureImageFile;

    customerPhoto = customerData.customerPhoto;
    idFrontPhoto = customerData.idFrontPhoto;
    idBackPhoto = customerData.idBackPhoto;
    signaturePhoto = customerData.signaturePhoto;

    progressDialog = ProgressDialog(context);
    progressDialog.style(
        message: progressbarMessage,
        messageTextStyle: const TextStyle(fontSize: 16, color: primaryColor),
        progressWidget: SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,)
    );
    loadSavedData();
  }

  loadSavedData() async {
   await getSavedMaritalStatus();
   await  getSavedPhone();
   await  getSavedAltPhone();
   await  getSavedAddress();
   await getSavedIDFront();
   await  getSavedIDBack();
   await  getSavedSelfie();
   await  getSavedSignature();
   idFrontImageFile = await getImage("IDFront");
   idBackImageFile = await getImage("IDBack");
   customerImageFile = await getImage("customer");
   signatureImageFile = await getImage("signature");

   if (idFrontPhoto!.length > 1){
     frontIDOCR(imageFile: idFrontImageFile);
   }
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
              'Marital Status',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
                hintText: "Select Your Marital Status",
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
              selectedStatus, // Provide the currently selected value (can be null initially)
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue;
                  widget.customerData.maritalStatus = newValue!;
                  saveSelectedMaritalStatus(newValue);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
              items: maritalDropdownItems.map((String item) {
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
                print(phone.toString());
                setState(() {
                  phone_number = phone.toString();
                  widget.customerData.phoneNumber = phone_number;
                  savePhone(phone_number);
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
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Alternative Phone Number *Optional',
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
                  widget.customerData.altPhoneNumber = altPhone_number;
                  saveAltPhone(altPhone_number);
                });
              },
              locale: 'en',
              initialCountry: 'UG',
              errorText: '     Number should be 9 characters',
              allowPickFromContacts: false,
              controller: altPhoneController,
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
              'Country Of Residence',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: countryController,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.country = value;
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
                hintText: "Enter your current country of residence",
                hintStyle: TextStyle(
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
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Current Address',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: addressController,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold
              ),
              onChanged: (value) {
                setState(() {
                  widget.customerData.address = value;
                  saveAddress(widget.customerData.address);
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
                hintText: "Enter your current address",
                hintStyle: const TextStyle(
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.normal,
                      fontSize: 13,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value == null){
                  return "Please enter your current address";
                }
                return null;
              },
              // onChanged and initialValue can be added as needed
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Please provide the following documents',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 4), // Same margin as before
                        height: 120,
                        decoration: BoxDecoration(
                          color: primaryLightVariant,
                          borderRadius: BorderRadius.circular(12), // Border radius of 12
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: idFrontImageFile == null
                            ? Center(
                          child: GestureDetector(
                            onTap: () {
                              currentPhoto = "IDFront";
                              _showImageSourceDialog();
                            },
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/add.png"),
                                  width: 30,
                                  height: 25,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "National ID Front Photo",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            currentPhoto = "IDFront";
                            _showImageSourceDialog();
                          },
                          child: Image.file(
                            idFrontImageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 4), // Same margin as before
                        height: 120,
                        decoration: BoxDecoration(
                          color: primaryLightVariant,
                          borderRadius: BorderRadius.circular(12), // Border radius of 12
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: idBackImageFile == null
                            ? Center(
                          child: GestureDetector(
                            onTap: () {
                              currentPhoto = "IDBack";
                              _showImageSourceDialog();
                            },
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/add.png"),
                                  width: 30,
                                  height: 25,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "National ID Back Photo",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            currentPhoto = "IDBack";
                            _showImageSourceDialog();
                          },
                          child: Image.file(
                            idBackImageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 4), // 16 margin on the left and 8 margin between
                        height: 120,
                        decoration: BoxDecoration(
                          color: primaryLightVariant,
                          borderRadius: BorderRadius.circular(12), // Border radius of 12
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: customerImageFile == null
                            ? Center(
                          child: GestureDetector(
                            onTap: () {
                              currentPhoto = "customer";
                              _showImageSourceDialog();
                            },
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/add.png"),
                                  width: 30,
                                  height: 25,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "PassPort Photo/Selfie",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            currentPhoto = "customer";
                            _showImageSourceDialog();
                          },
                          child: Image.file(
                            customerImageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 4), // 8 margin between and 16 margin on the right
                        height: 120,
                        decoration: BoxDecoration(
                          color: primaryLightVariant,
                          borderRadius: BorderRadius.circular(12), // Border radius of 12
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: signatureImageFile == null
                            ? Center(
                          child: GestureDetector(
                            onTap: () {
                              currentPhoto = "signature";
                              _showImageSourceDialog();
                            },
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("assets/images/add.png"),
                                  width: 30,
                                  height: 25,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Signature Photo",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "No ThumbPrint allowed! Signature should not be in Upper case",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            currentPhoto = "signature";
                            _showImageSourceDialog();
                          },
                          child: Image.file(
                            signatureImageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // Vertical spacing between rows
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }

  _cropImage(filePath) async {
    File croppedImage = (await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 3.0, ratioY: 2.0)
    )) as File;

    if(currentPhoto == "customer"){
      customerImageFile = croppedImage;
      widget.customerData.customerImageFile = croppedImage;
      final Uint8List imageBytes = await croppedImage.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      customerPhoto = base64Image;
      widget.customerData.customerPhoto = base64Image;
      saveImage(customerImageFile!, "customer");
      saveSelfie(customerPhoto!);

    } else if(currentPhoto == "IDFront"){
      idFrontImageFile = croppedImage;
      widget.customerData.idFrontImageFile = croppedImage;
      final Uint8List imageBytes = await croppedImage.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      idFrontPhoto = base64Image;
      frontIDOCR(imageFile: idFrontImageFile);
      widget.customerData.idFrontPhoto = base64Image;
      saveImage(idFrontImageFile!, "IDFront");
      saveIDFront(idFrontPhoto!);

    }else if(currentPhoto == "IDBack"){
      idBackImageFile = croppedImage;
      widget.customerData.idBackImageFile = croppedImage;
      final Uint8List imageBytes = await croppedImage.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      idBackPhoto = base64Image;
      widget.customerData.idBackPhoto = base64Image;
      saveImage(idBackImageFile!, "IDBack");
      saveIDBack(idBackPhoto!);

    }else if(currentPhoto == "signature"){
      signatureImageFile = croppedImage;
      widget.customerData.signatureImageFile = croppedImage;
      final Uint8List imageBytes = await croppedImage.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      signaturePhoto = base64Image;
      widget.customerData.signaturePhoto = base64Image;
      saveImage(signatureImageFile!, "signature");
      saveSignature(signaturePhoto!);
    }

    setState(() {});
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _getFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void frontIDOCR({required File? imageFile}) async {

    progressDialog.show();

    try {
      final inputImage = InputImage.fromFile(imageFile!);
      final RecognizedText recognisedText =
      await textRecognizer.processImage(inputImage);

      recognizedText = "";

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text} |";
        }
      }

      print("RECCC: " + recognizedText);
      if (recognizedText.startsWith("REPUBLIC OF UGANDA |NATIONAL")) {
        print("The string starts with 'REPUBLIC OF UGANDA |NATIONAL'");
      } else {
        print("The string does not start with 'REPUBLIC OF UGANDA |NATIONAL'");
      }

      RegExp dateRegex = RegExp(r'\d{2}\.\d{2}\.\d{4}');
      RegExp surnameRegex = RegExp(r'(?<=\|SURNAME \|)[A-Z]+');
      RegExp givenNameRegex = RegExp(r'(?<=\|GIVEN\s+N\w+ \|)[A-Z]+');
      // RegExp dobRegex = RegExp(r'(?<=\|DATE OF BIRTH \|)\d{2}\.\d{2}\.\d{4}');
      RegExp dobRegex = RegExp(r'(?<=\|DATE OF B[^|]*\|)\d{2}\.\d{2}\.\d{4}');
      RegExp cardNoRegex = RegExp(r'(?<=\|CARD N(?:O\.|o\.|o)\s*\|\s*)\d+');
      RegExp ninPattern = RegExp(r'\|(?:CF|CM)[^\|]{13,}\|');
      RegExp genderPattern = RegExp(r'\|([MF])\s*\|');
      RegExp nationalityRegex = RegExp(r'(?<=\|NATIONALITY \|)[A-Z]+');

      Iterable<Match> genderMatches = genderPattern.allMatches(recognizedText);
      Iterable<Match> ninMatches = ninPattern.allMatches(recognizedText);

      for (Match match in ninMatches) {
        String matchString = match.group(0) ?? "";
        // Remove spaces and check if length is at least 14 characters
        String matchWithoutPipesAndSpaces = matchString.replaceAll("|", "").replaceAll(" ", "");
        NIN = matchWithoutPipesAndSpaces.replaceAll(" ", "");
        if (NIN.length >= 14) {
          print("Match found: $matchString");
        }
      }

      for (Match match in genderMatches) {
        sex = match.group(1) ?? "";
      }

      // print("OtherName" + givenNameRegex.firstMatch(recognizedText)!.group(1).toString());

      String idExpDateStr = dateRegex.firstMatch(recognizedText)?.group(0) ?? "";
      surName = surnameRegex.firstMatch(recognizedText)?.group(0) ?? "";
      Name = givenNameRegex.firstMatch(recognizedText)?.group(0) ?? "";
      String birthDateStr = dobRegex.firstMatch(recognizedText)?.group(0) ?? "";
      CardNumber = cardNoRegex.firstMatch(recognizedText)?.group(0) ?? "";
      nationality = nationalityRegex.firstMatch(recognizedText)?.group(0) ?? "";

      DateTime birthDate = DateFormat("dd.MM.yyyy").parse(birthDateStr);
      String formattedBirthDate = DateFormat("yyyy-MM-dd").format(birthDate);
      dob = formattedBirthDate;

      DateTime idExpDate = DateFormat("dd.MM.yyyy").parse(idExpDateStr);
      String formattedIdExpDate = DateFormat("yyyy-MM-dd").format(idExpDate);
      DateOfExpiry = formattedIdExpDate;

      print(surName);
      print(Name);
      print(NIN);
      print(dob);
      print(CardNumber);
      print(sex);
      print(DateOfExpiry);

      if (surName.isNotEmpty && Name.isNotEmpty && CardNumber.isNotEmpty && nationality.isNotEmpty && dob.isNotEmpty &&
          DateOfExpiry.isNotEmpty && sex.isNotEmpty && NIN.isNotEmpty) {

        widget.customerData.firstName = Name;
        widget.customerData.lastName = surName;
        widget.customerData.NIN = NIN;
        widget.customerData.DOB = dob;
        widget.customerData.IDExpiry = DateOfExpiry;
        widget.customerData.cardNo = CardNumber;
        widget.customerData.gender = sex;
      } else {
        setState(() {
          idFrontImageFile = null;
        });
        Fluttertoast.showToast(
          msg: "ID not properly captured\n\nPlease make sure you are in a well lit environment and capture your NATIONAL ID again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      progressDialog.hide();
    } catch (e) {
      if (!mounted) {
        return;
      }
      progressDialog.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Alert!",
              style: TextStyle(
                  fontFamily: "Manrope", fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Error processing your details. \n \nPlease make sure you are using an original Ugandan National ID\n \nAlso make sure you're in a well lit environment",
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
                  setState(() {
                    idFrontImageFile = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      // setState(() {
      //   isRecognizing = false;
      // });
    }
  }

  void ErrorAlert(String message) {
    // Implement your error alert logic here
  }


  Future<List<int>> fileToByteArray(File? file) async {
    if (file == null) {
      return [];
    }

    List<int> byteArray = await file.readAsBytes();
    return byteArray;
  }

  Future<void> saveSelectedMaritalStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedMaritalStatus', status);
  }

  Future<String?> getSavedMaritalStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMarStatus = prefs.getString('selectedMaritalStatus');

    if (savedMarStatus != null) {
      setState(() {
        selectedStatus = savedMarStatus;
        widget.customerData.maritalStatus = selectedStatus!;
      });
    }
    return prefs.getString('selectedMaritalStatus');
  }

  Future<void> savePhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
  }

  Future<String?> getSavedPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString('phone');

    if (savedPhone != null) {
      setState(() {
        phone_number = savedPhone;
        widget.customerData.phoneNumber = phone_number;
      });
    }
    return prefs.getString('phone');
  }

  Future<void> saveIDFront(String imageString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('IDFront', imageString);
  }

  Future<String?> getSavedIDFront() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedIDFront = prefs.getString('IDFront');

    if (savedIDFront != null) {
      setState(() {
        idFrontPhoto = savedIDFront;
        widget.customerData.idFrontPhoto = idFrontPhoto!;
      });
    }
    return prefs.getString('IDFront');
  }

  Future<void> saveIDBack(String imageString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('IDBack', imageString);
  }

  Future<String?> getSavedIDBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedIDBack = prefs.getString('IDBack');

    if (savedIDBack != null) {
      setState(() {
        idBackPhoto = savedIDBack;
        widget.customerData.idBackPhoto = idBackPhoto!;
      });
    }
    return prefs.getString('IDBack');
  }


  Future<void> saveSignature(String imageString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('signature', imageString);
  }

  Future<String?> getSavedSignature() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSignature = prefs.getString('signature');

    if (savedSignature != null) {
      setState(() {
        signaturePhoto = savedSignature;
        widget.customerData.signaturePhoto = signaturePhoto!;
      });
    }
    return prefs.getString('signature');
  }


  Future<void> saveAltPhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('altPhone', phone);
  }

  Future<String?> getSavedAltPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAltPhone = prefs.getString('altPhone');

    if (savedAltPhone != null) {
      setState(() {
        altPhone_number = savedAltPhone;
        widget.customerData.altAccount = altPhone_number;
      });
    }
    return prefs.getString('altPhone');
  }

  Future<void> saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', address);
  }

  Future<String?> getSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAddress = prefs.getString('address');

    if (savedAddress != null) {
      setState(() {
        addressController.text = savedAddress;
        widget.customerData.address = savedAddress;
      });
    }
    return prefs.getString('address');
  }

  Future<void> saveSelfie(String imageString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selfie', imageString);
  }

  Future<String?> getSavedSelfie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSelfie = prefs.getString('selfie');

    if (savedSelfie != null) {
      setState(() {
        customerPhoto = savedSelfie;
        widget.customerData.customerPhoto = customerPhoto!;
      });
    }
    return prefs.getString('selfie');
  }


// Function to save the file
  Future<File> saveImage(File imageFile, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory(); // Get the directory for saving
      final path = directory.path;
      final file = File('$path/$fileName'); // Create the path for the file
      return await imageFile.copy(file.path); // Copy the file to the new path
    } catch (e) {
      print("Error saving file: $e");
      rethrow;
    }
  }

  Future<File?> getImage(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory(); // Get the directory
      final filePath = '${directory.path}/$fileName';
      File file = File(filePath);

      // Check if the file exists
      if (await file.exists()) {
        return file;
      } else {
        return null; // Return null if the file doesn't exist
      }
    } catch (e) {
      print("Error retrieving file: $e");
      return null;
    }
  }

}
