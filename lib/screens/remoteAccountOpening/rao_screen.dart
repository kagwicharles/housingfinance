import 'dart:io';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/remoteAccountOpening/pep_exposure.dart';
import 'package:hfbbank/screens/remoteAccountOpening/personal_details.dart';
import 'package:hfbbank/screens/remoteAccountOpening/privacy.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_loading.dart';
import 'package:hfbbank/screens/remoteAccountOpening/success_display.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/theme.dart';
import 'customer_type.dart';
import 'additional_services_request.dart';
import 'alt_account_details.dart';
import 'client_bio_data.dart';
import 'employment_details.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


import 'next_of_kin_details.dart';
import 'otp.dart';

class RAOScreen extends StatefulWidget {
  final bool isSkyBlueTheme;

  const RAOScreen({required this.isSkyBlueTheme});

  @override
  _RAOScreenState createState() => _RAOScreenState();
}

class _RAOScreenState extends State<RAOScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerDataScreen(isSkyBlueTheme: widget.isSkyBlueTheme,),
    );
  }
}

class CustomerData {
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String title = '';
  String currency = '';
  String accountType = '';
  String termsUrl = '';
  String branch = '';
  String maritalStatus = '';
  String NIN = '';
  String email = '';
  String cardNo = '';
  String IDExpiry = '';
  String gender = '';
  String DOB = '';
  String altAccount = '';
  String altAccountNo = '';
  String altAccountName = '';
  String altBranchName = '';
  String altBankName = '';
  String accName = '';
  String bankName = '';
  String occupation = '';
  String otherOccupation = '';
  String designation = '';
  String employmentType = '';
  String workingSince = '';
  String company = '';
  String income = '';
  String otherIncome = '';
  String customerPhoto = '';
  String idFrontPhoto = '';
  String idBackPhoto = '';
  String signaturePhoto = '';
  String nokFName = '';
  String nokMName = '';
  String nokLName = '';
  String nokPhone = '';
  String nokAltPhone = '';
  String country = 'Uganda';
  String address = '';
  String period = '';
  String duration = '';
  String businessAddress = '';
  String nob = '';
  String empName = '';
  String ownerFName = '';
  String ownerLName = '';
  String ownerTeleco = '';
  String ownership = '';
  String pepIsExposed = '';
  String pepTitle = '';
  String pepPosition = '';
  String pepSpecifiedTitle = '';
  String pepSpecifiedRelationship = '';
  String pepCountry = '';
  String pepStartYear = '';
  String pepEndYear = '';
  String pepRFName = '';
  String hasPepRelative = '';
  String pepRelationship = '';
  String pepRLName = '';
  String pepInitial = '';
  String phoneNumber = '';
  String altPhoneNumber = '';
  String mobileMoneyNo = '';
  String mediaName = '';
  String mediaType = '';
  String mediaPhone = '';
  bool termsAccepted = false;
  bool mobileBanking = true;
  bool termsConditions = false;
  String otherTitle = '';
  File? customerImageFile;
  File? idFrontImageFile;
  File? idBackImageFile;
  File? signatureImageFile;
  List<dynamic>? raoParams;
  late List<Map<String, dynamic>> branches;
  late List<Map<String, dynamic>> products;
  late List<Map<String, dynamic>> cities;
  late List<Map<String, dynamic>> designations;
  late List<Map<String, dynamic>> occupations;
  late List<Map<String, dynamic>> companyTypes;
  String accountTypeName = "";
  String? branchName;
  String? cityName;
  String? occupationName;
  String? designationName;
  String? empTypeName;
  String? districtName;
  String? countyName;
  String? subCountyName;
  String? parishName;
  String? villageName;
}

class CustomerDataScreen extends StatefulWidget {
  final bool isSkyBlueTheme;

  const CustomerDataScreen({required this.isSkyBlueTheme});

  @override
  _CustomerDataScreenState createState() => _CustomerDataScreenState();
}

class _CustomerDataScreenState extends State<CustomerDataScreen> {
  int currentStep = 0;
  String currentForm = "Customer Type & Product";
  final CustomerData customerData = CustomerData();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String kfd = "";
  List<Map<String, dynamic>> branchData = [];
  List<Map<String, dynamic>> productData = [];
  List<Map<String, dynamic>> paramData = [];
  bool isLoading = true;
  bool isSubmitting = false;

  List<Widget> getForms() {
    return [
      isLoading ? RaoLoading() :
      AccountDetails(customerData: customerData),
      PersonalDetails(customerData: customerData),
      ClientDetails(customerData: customerData),
      NOKDetails(customerData: customerData),
      EmploymentDetails(customerData: customerData),
      TermsnConditions(customerData: customerData,),
      AltAccountDetails(customerData: customerData),
      PEPExposure(customerData: customerData),
      AdditionalDetails(customerData: customerData),
      RaoOTP(customerData: customerData),
    ];
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final branchDataResult = await fetchBranchData();
      final productDataResult = await fetchProductData();

      setState(() {
        customerData.branches = branchDataResult;
        customerData.products = productDataResult;
        isLoading = false;
      });
    } catch (error) {
      // Handle errors appropriately
      // print('Error fetching data: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBranchData() async {
    final api_service = APIService();
    final value = await api_service.reqRAOParams();
    if (value.status == StatusCode.success.statusCode) {
      setState(() {
        branchData = value.dynamicList!
            .where((item) => item.containsKey("BranchCode"))
            .map((branch) {
          return {
            "BRANCHID": branch["BranchCode"],
            "BRANCHNAME": branch["BranchName"],
          };
        }).toList();

      });
      return branchData; // Return the branchData or an empty list if it's null
    }
    throw Exception(
        'Failed to fetch branch data'); // Handle errors appropriately
  }

  Future<List<Map<String, dynamic>>> fetchProductData() async {
    final api_service = APIService();
    final value = await api_service.reqRAOProducts();
    if (value.status == StatusCode.success.statusCode) {
      setState(() {
        productData = value.dynamicList!
            .where((item) => item.containsKey("ProductID"))
            .map((product) {
          return {
            "PRODUCTID": product["ProductID"],
            "PRODUCTNAME": product["ProductName"],
            "PRODUCTURL": product["Urls"],
            "PRODUCTDESC": product["ProductDescription"],
            "PRODUCTTERMSURL": product["TermsUrl"],
          };
        }).toList();
      });
      return productData;
    }
    throw Exception(
        'Failed to fetch branch data');
  }

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {

        if (currentStep == 0 && customerData.termsConditions == false){
          _showAlert("Oops!", "You need to Agree to the account\'s Terms of use in the Key Facts Document in order to open an account with us");
        } else if (currentStep == 1) {
          if (customerData.customerPhoto.isEmpty ||
              customerData.signaturePhoto.isEmpty ||
              customerData.idBackPhoto.isEmpty ||
              customerData.idFrontPhoto.isEmpty) {
            _showAlert("Notice!", "Please Capture all the images");
          }
          else if (customerData.IDExpiry.isNotEmpty){
            DateTime now = DateTime.now();
            DateTime date = DateFormat("yyyy-MM-dd").parse(customerData.IDExpiry);
            DateTime oneYearAfterExpiry = DateTime(date.year + 1, date.month, date.day);
            if (oneYearAfterExpiry.isBefore(now)) {
              _showAlert("Notice!",  "The ID used is Expired.");
            } else {
              currentStep++;
              updateCurrentForm();
            }
          }
        } else if (currentStep == 4){
          if (customerData.employmentType == "Employed/Salary" && customerData.duration != "Years" && customerData.duration != "Months"){
            print("Duration" + customerData.duration);
            _showAlert("Alert!", "Please confirm if you have been working at ${customerData.empName} for ${customerData.period} Years or ${customerData.period} Months");
          } else {
            currentStep++;
            updateCurrentForm();
          }
        } else if(currentStep == 5){
          if (customerData.termsAccepted){
            currentStep++;
            updateCurrentForm();
          } else {
            _showAlert("Oops!", "You need to Agree to our Terms & Conditions in order to open an account with us");
          }
        } else if (currentStep == 6){
          if (customerData.altAccount == "Mobile Money" && (customerData.ownerTeleco != 'MTN' && customerData.ownerTeleco != 'Airtel')){
            _showAlert("Alert!", "Please select your Mobile Money Provider");
          } else if (customerData.altAccount == "Mobile Money" && (customerData.ownership != 'Yes' && customerData.ownership != 'No')){
            _showAlert("Alert!", "Please confirm if the number is registered in your name");
          } else {
            currentStep++;
            updateCurrentForm();
          }
        } else if (currentStep == 7){
          if (customerData.pepIsExposed != 'Yes' && customerData.pepIsExposed != 'No'){
            _showAlert("Alert!", "Please select your political exposure status");
          } else if (customerData.pepIsExposed == 'No' && (customerData.hasPepRelative != 'Yes' && customerData.hasPepRelative != 'No')){
            _showAlert("Alert!", "Please confirm if you have a politically exposed relative");
          } else if ((customerData.pepStartYear.isNotEmpty && customerData.pepEndYear.isNotEmpty) && (int.parse(customerData.pepStartYear) > int.parse(customerData.pepEndYear))){
            _showAlert("Oops!", "The Start Year cannot be greater than the End year");
          }  else {
            currentStep++;
            updateCurrentForm();
          }
        } else if(currentStep == 8){
          if (customerData.mediaType.isEmpty){
            _showAlert("Alert!", "Please let us know how you got to know about us by selecting an option");
          } else if (customerData.mediaType == "Social Media" && ( customerData.mediaName != "Facebook" &&
              customerData.mediaName != "X (former Twitter)" && customerData.mediaName != "Instagram")){
            _showAlert("Alert!", "Please select a social media platform");
          } else {
            currentStep++;
            updateCurrentForm();
          }
        }
        else if (currentStep < getForms().length - 1) {
          currentStep++;
          updateCurrentForm();
        }
      });
    }
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
        updateCurrentForm();
      }
    });
  }

  Widget _buildText(String label, String? value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label   ",
            style: const TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black, // Set the color for hardcoded text
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontFamily: "Manrope",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: primaryColor, // Set the color for variable text
            ),
          ),
        ],
      ),
    );
  }

  void confirmationStep() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Please confirm your details below",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Manrope", fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText("Title:", customerData.title),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Surname:", customerData.lastName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Given name:", customerData.firstName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("ID Number (NIN):", customerData.NIN),
                const SizedBox(
                  height: 8,
                ),
                _buildText("ID Card Number:", customerData.cardNo),
                const SizedBox(
                  height: 8,
                ),
                _buildText("ID EXpiry:", customerData.IDExpiry),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Date Of Birth:", customerData.DOB),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Account Type:", customerData.accountTypeName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Branch:", customerData.branchName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Mobile Number:", "widget.mobileNumber"),
                const SizedBox(
                  height: 8,
                ),
                _buildText(
                    "Sales Officer Account:", customerData.maritalStatus),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Residential Address:", customerData.nokLName),
                const SizedBox(
                  height: 5,
                ),
                _buildText("Employment/Business Address:", customerData.gender),
                const SizedBox(
                  height: 8,
                ),
                _buildText("City:", customerData.cityName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("District:", customerData.districtName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("County:", customerData.countyName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Sub-County:", customerData.subCountyName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Parish:", customerData.parishName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Village:", customerData.villageName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Employment Type:", customerData.empTypeName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Occupation:", customerData.occupationName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Designation:", customerData.designationName),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Working Since:", customerData.workingSince),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Company Name:", customerData.company),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Gross Monthly Income:", customerData.income),
                const SizedBox(
                  height: 8,
                ),
                _buildText("Apply for Mobile Banking?",
                    customerData.mobileBanking ? "YES" : "NO"),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Manrope",
                    fontSize: 16,
                    color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Submit",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Manrope",
                    fontSize: 16,
                    color: secondaryAccent),
              ),
              onPressed: () {
                setState(() {
                  isSubmitting = true; // Show the loading indicator
                });

                openAccount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

    String number = customerData.phoneNumber;
    String altNo = customerData.altPhoneNumber;
    String nokNo = customerData.nokPhone;
    String nokAltNo = customerData.nokAltPhone;
    String mmNumber  =  customerData.mobileMoneyNo;
    RegExp firstPlusRegEx = RegExp(r'^\+');
    phoneNumber = number.replaceFirst(firstPlusRegEx, '');
    altPhoneNumber = altNo.replaceFirst(firstPlusRegEx, '');
    nokPhoneNumber = nokNo.replaceFirst(firstPlusRegEx, '');
    nokAltPhoneNumber = nokAltNo.replaceFirst(firstPlusRegEx, '');
    mmNo = mmNumber.replaceFirst(firstPlusRegEx, '');

    RegExp regExp = RegExp(r'^.{3}');
    zipCode = regExp.stringMatch(phoneNumber) ?? "";

    switch(customerData.gender){
      case "M":
        gender = "Male";
        break;
      case "F":
        gender = "Female";
        break;
    }

    if (customerData.title == "Other"){
      title =  customerData.otherTitle;
    } else {
      title = customerData.title;
    }

    if  (customerData.hasPepRelative == "Yes"){
      pepFName = customerData.pepRFName;
      pepLName = customerData.pepRLName;
      pepRelationship = customerData.pepRelationship;

      if (customerData.pepRelationship == "Other"){
        pepRelationship = customerData.pepRelationship + " - " + customerData.pepSpecifiedRelationship;
      }
    } else {
      pepFName = customerData.firstName;
      pepLName = customerData.lastName;
      pepRelationship = "SELF";
    }

    if (customerData.pepPosition == "Other"){
      customerData.pepPosition = customerData.pepPosition + " - " + customerData.pepSpecifiedTitle;
    }

    switch(customerData.mediaType){
      case "TV/Radio Station":
        recommendation = customerData.mediaType + " - " + customerData.mediaName;
        break;
      case "Customer":
      case "Bank Staff":
      case "HFB Agent":
        recommendation = customerData.mediaType + " - " + customerData.mediaName + " - " + customerData.mediaPhone;
        break;
      case "Social Media":
        recommendation = customerData.mediaType + " - " + customerData.mediaName;
        break;
    }

    if (customerData.altAccount == "Bank Account") {
      Infofield1 = "ACCOUNTID|" + "" + "|CUSTOMER_CATEGORY|" + CustomerCategory + "|ACCOUNT_TYPE|" + customerData.accountTypeName + "|FIRST_NAME|" + customerData.firstName +
          "|MIDDLE_NAME|" + customerData.middleName + "|LAST_NAME|" + customerData.lastName + "|DOB|" + customerData.DOB + "|NATIONALID|" + customerData.NIN +
          "|PHONE_NUMBER|" + phoneNumber + "|ALTERNATE_PHONE_NUMBER|" + altPhoneNumber + "|EMAIL_ADDRESS|" + customerData.email + "|GENDER|" + gender + "|TITLE|" + title + "|CURRENCY|" + customerData.currency + "|BRANCH|" + customerData.branch + "|PRODUCTID|" + customerData.accountType + "|ALTERNATE_ACCOUNT_NUMBER|" + customerData.altAccountNo + "|ALTERNATE_ACCOUNT_NAME|" + customerData.altAccountName + "|ALTERNATE_BANKNAME|" + customerData.altBankName + "|ALTERNATE_BRANCHNAME|" + customerData.altBranchName + "|MOBILE_MONEY_PROVIDER|" + "N/A" + "|MOBILE_MONEY_PHONE_OWNER|" + "N/A" + "|MOBILE_MONEY_PHONE_NUMBER|" + "N/A";
    } else if (customerData.altAccount == "Mobile Money" && customerData.ownership == "No") {
      Infofield1 = "ACCOUNTID|" + "" + "|CUSTOMER_CATEGORY|" + CustomerCategory + "|ACCOUNT_TYPE|" + customerData.accountTypeName + "|FIRST_NAME|" + customerData.firstName +
          "|MIDDLE_NAME|" + customerData.middleName + "|LAST_NAME|" + customerData.lastName + "|DOB|" + customerData.DOB + "|NATIONALID|" + customerData.NIN +
          "|PHONE_NUMBER|" + phoneNumber + "|ALTERNATE_PHONE_NUMBER|" + altPhoneNumber + "|EMAIL_ADDRESS|" + customerData.email + "|GENDER|" + gender + "|TITLE|" + title + "|CURRENCY|" + customerData.currency  + "|BRANCH|" + customerData.branch + "|PRODUCTID|" + customerData.accountType + "|ALTERNATE_ACCOUNT_NUMBER|" + "N/A" + "|ALTERNATE_ACCOUNT_NAME|" + "N/A" + "|ALTERNATE_BANKNAME|" + "N/A" + "|ALTERNATE_BRANCHNAME|" + "N/A" + "|MOBILE_MONEY_PROVIDER|" + customerData.ownerTeleco + "|MOBILE_MONEY_PHONE_OWNER|" + customerData.ownerFName + " " + customerData.ownerLName + "|MOBILE_MONEY_PHONE_NUMBER|" + mmNo;
    } else {
      Infofield1 = "ACCOUNTID|" + "" + "|CUSTOMER_CATEGORY|" + CustomerCategory + "|ACCOUNT_TYPE|" + customerData.accountTypeName + "|FIRST_NAME|" + customerData.firstName +
          "|MIDDLE_NAME|" + customerData.middleName + "|LAST_NAME|" + customerData.lastName + "|DOB|" + customerData.DOB + "|NATIONALID|" + customerData.NIN +
          "|PHONE_NUMBER|" + phoneNumber + "|ALTERNATE_PHONE_NUMBER|" + altPhoneNumber + "|EMAIL_ADDRESS|" + customerData.email + "|GENDER|" + gender + "|TITLE|" + title + "|CURRENCY|" + customerData.currency  + "|BRANCH|" + customerData.branch + "|PRODUCTID|" + customerData.accountType + "|ALTERNATE_ACCOUNT_NUMBER|" + "N/A" + "|ALTERNATE_ACCOUNT_NAME|" + "N/A" + "|ALTERNATE_BANKNAME|" + "N/A" + "|ALTERNATE_BRANCHNAME|" + "N/A" + "|MOBILE_MONEY_PROVIDER|" + customerData.ownerTeleco + "|MOBILE_MONEY_PHONE_OWNER|" + "N/A" + "|MOBILE_MONEY_PHONE_NUMBER|" + mmNo;
    }

    Infofield2 = "FATHER_FIRST_NAME|" + "" + "|FATHER_MIDDLE_NAME|" + "" + "|FATHER_LAST_NAME|" + "" + "|MOTHER_FIRST_NAME|" + "" + "|MOTHER_MIDDLE_NAME|" + "" + "|MOTHER_LAST_NAME|" + "";

    Infofield3 = "CURRENT_LOCATION|" + "" + "|ADDRESS|" + customerData.address + "|HOME_DISTRICT|" + "" + "|YEARS_AT_ADDRESS|" + "- Years" +
        "|POLITICALLY_EXPOSED|" + customerData.pepIsExposed + "|POLITICALLY_EXPOSED_FIRSTNAME|" + pepFName + "|POLITICALLY_EXPOSED_LASTNAME|" + pepLName + "|POLITICALLY_EXPOSED_POSITION|" + customerData.pepPosition + "|POLITICALLY_EXPOSED_INITIAL|" + customerData.pepInitial + "|POLITICALLY_EXPOSED_RELATIONSHIP|" + pepRelationship + "|POLITICALLY_EXPOSED_TITLE|" + customerData.pepTitle + "|POLITICALLY_EXPOSED_COUNTRY|" + customerData.pepCountry + "|POLITICALLY_EXPOSED_START_YEAR|" + customerData.pepStartYear + "|POLITICALLY_EXPOSED_END_YEAR|" + customerData.pepEndYear +
        "|MARITALSTATUS|" + customerData.maritalStatus + "|ZIPCODE|" + zipCode;

    if (customerData.employmentType == "Self-employed/Business") {
      Infofield4 = "INCOME_PER_ANUM|" + customerData.income + "|EMPLOYMENT_TYPE|" + customerData.employmentType + "|OCCUPATION|" + "N/A" + "|PLACE_OF_WORK|" + "N/A" + "|NATURE_OF_BUSINESS_SECTOR|" + customerData.nob + "|PERIOD_OF_EMPLOYMENT|" + "N/A" + "|EMPLOYER_NAME|" + "N/A" + "|NATURE|" + "N/A" + "|BUSINESS_ADDRESS|" + customerData.businessAddress;
    } else if (customerData.employmentType == "Employed/Salary") {
      Infofield4 = "INCOME_PER_ANUM|" + customerData.income + "|EMPLOYMENT_TYPE|" + customerData.employmentType + "|OCCUPATION|" + customerData.occupation + "|PLACE_OF_WORK|" + customerData.empName + "|NATURE_OF_BUSINESS_SECTOR|" + customerData.businessAddress + "|PERIOD_OF_EMPLOYMENT|" + customerData.period + " " + customerData.duration + "|EMPLOYER_NAME|" + customerData.empName + "|NATURE|" + "N/A" + "|BUSINESS_ADDRESS|" + customerData.businessAddress;
    } else {
      Infofield4 = "INCOME_PER_ANUM|" + customerData.income + "|EMPLOYMENT_TYPE|" + customerData.employmentType + "|OCCUPATION|" + "N/A" + "|PLACE_OF_WORK|" + "N/A" + "|NATURE_OF_BUSINESS_SECTOR|" + "N/A" + "|PERIOD_OF_EMPLOYMENT|" + "N/A" + "|EMPLOYER_NAME|" + "N/A" + "|NATURE|" + "N/A" + "|BUSINESS_ADDRESS|" + "N/A";
    }

    Infofield5 = "NEXT_OF_KIN_FIRST_NAME|" + customerData.nokFName + "|NEXT_OF_KIN_MIDDLE_NAME|" + customerData.nokMName + "|NEXT_OF_KIN_LAST_NAME|" + customerData.nokLName + "|NEXT_OF_KIN_PHONE_NUMBER|" + nokPhoneNumber + "|NEXT_OF_KIN_ALTERNATE_PHONE_NUMBER|" + nokAltPhoneNumber + "|NEXT_OF_KIN_ADDRESS|" + "null" + "|OTHER_SERVICES_REQUIRED|" + "" + "|RECOMMENDED_BY|" + recommendation;


    final _api_service = APIService();
    _api_service
        .rao(
      Infofield1,
      Infofield2,
      Infofield3,
      Infofield4,
      Infofield5,
            customerData.idFrontPhoto,
            customerData.idBackPhoto,
            customerData.customerPhoto,
            customerData.signaturePhoto,
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
          merchant:  "RAONEW", isSkyBlueTheme: widget.isSkyBlueTheme,));
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


  void updateCurrentForm() {
    switch (currentStep) {
      case 0:
        currentForm = "Customer Type & Product";
        break;
      case 1:
        currentForm = "Personal Details";
        break;
      case 2:
        currentForm = "Confirm ID Details";
        break;
      case 3:
        currentForm = "Next Of Kin";
        break;
      case 4:
        currentForm = "Source of Income";
        break;
      case 5:
        currentForm = "Terms & Conditions";
        break;
      case 6:
        currentForm = "Alternative Account";
        break;
      case 7:
        currentForm = "Political Exposure";
        break;
      case 8:
        currentForm = "Recommendation";
        break;
      case 9:
        currentForm = "OTP Verification";
        break;
      // Add cases for other forms as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
        body: ModalProgressHUD(
            inAsyncCall:
            isSubmitting, // Set this variable to true when you want to show the loading indicator
            opacity:
            0.5, // Customize the opacity of the background when the loading indicator is displayed
            progressIndicator:
            const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,), // Customize the loading indicator (you can use any widget)
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(onTap: (){
                              Navigator.of(context, rootNavigator: true)
                                  .pop(context);
                              // Navigator.of(context).pop();
                            },child: Icon(Icons.arrow_back_sharp, size: 24,color: Colors.white,)),
                            Spacer(),
                            const Text(
                              "Open Account",
                              style: TextStyle(fontSize: 15,
                                  fontFamily: "DMSans",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(width: 32,),
                            Spacer(),
                          ],
                        ))),
                Expanded(child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    child: Container(
                        color: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  currentForm,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor: secondaryAccent,
                              value: (currentStep + 1) /
                                  getForms().length, // Calculate progress
                            ),
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: getForms()[currentStep],
                              ),
                            ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: primaryColor,
                        child: Row(
                          children: [
                            // Previous Section
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  currentStep > 0 ? previousStep() : null;
                                },
                                splashColor: Colors.white.withOpacity(0.3), // Visible splash color
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage("assets/images/backA.png"),
                                      width: 32,
                                      color: currentStep > 0
                                          ? Colors.white
                                          : primaryColor,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Previous',
                                      style: TextStyle(
                                        color: currentStep > 0
                                                          ? Colors.white
                                                          : primaryColor,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                  ],
                                ),
                              ),
                            ),

                            // Vertical Divider
                            Container(
                              color: Colors.white,
                              width: 1,
                              height: 32,
                            ),

                            // Next Section
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  currentStep < getForms().length - 1
                                            ? nextStep()
                                      : openAccount();
                                            // : confirmationStep();
                                },
                                splashColor: Colors.white.withOpacity(0.3), // Visible splash color
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 32),
                                    Text(
                                      currentStep == getForms().length - 2 ||
                                          currentStep == getForms().length - 3 ||
                                          currentStep == getForms().length - 4
                                                      ? 'Accept'
                                                      : 'Next',
                                      style: TextStyle(
                                        color: currentStep == 9
                                            ? primaryColor
                                            : Colors.white,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Image(
                                      image: AssetImage("assets/images/forward.png"),
                                      width: 32,
                                      color: currentStep == 9
                                          ? primaryColor
                                          : Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          ],
                        ))),)
              ],
            )) );
  }
}
