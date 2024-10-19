
import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/theme.dart';

class AccountDetails extends StatefulWidget {
  final CustomerData customerData;


  AccountDetails({Key? key, required this.customerData}) : super(key: key);

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late ProgressDialog progressDialog;

  bool _isLoading = true;
  String? selectedAccount;
  String? selectedBranch;
  String? selectedCurrency;
  TextEditingController accountNumberController = TextEditingController();
  bool isAgreed = false;
  bool isAccountSelected = false;
  bool showAccountDescription = true;
  String progressbarTitle = "";
  String progressbarMessage = "Processing...";
  String processID = "";
  String productDesc = "";
  String productUrl = "";
  String productTermsUrl = "";
  String productName = "";

  List<Map<String, dynamic>> branchData = [];
  List<Map<String, dynamic>> productData = [];

  Map<String, String> branchIdToName = {};
  Map<String, String> productIDToName = {};
  Map<String, String> productIDToURL = {};
  Map<String, String> productIDToTermsURL = {};
  Map<String, String> productIDToDesc = {};

  final List<String> currencyDropdownItems = [
    'UGX',
    'USD',
    'GBP',
    'EUR',
  ];


  Future<void> saveSelectedBranch(String branch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBranch', branch);
  }
  Future<void> saveSelectedProduct(String product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProduct', product);
  }
  Future<void> saveSelectedCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
  }

  @override
  void initState() {
    super.initState();
    final customerData = widget.customerData;

    _loadPreferences();
    branchData = customerData.branches;
    productData = customerData.products;

    // Initialize the selectedBranch from SharedPreferences if available
    getSavedBranch().then((savedBranch) {
      setState(() {
        selectedBranch = savedBranch ?? branchIdToName[0];
        customerData.branch = savedBranch!;
        customerData.branchName = branchIdToName[savedBranch];
      });
    });

    getSavedProduct().then((savedProduct) {
      setState(() {
        selectedAccount = savedProduct ?? productIDToName[0];
        customerData.accountType = savedProduct!;
        customerData.accountTypeName = productIDToName[savedProduct]!;
      });
    });

    getSavedCurrency();

    // In the initState method
    branchData.forEach((branch) {
      String branchName = branch["BRANCHNAME"];
      String branchID = branch["BRANCHID"];
      branchIdToName[branchID] = branchName;
    });

    productData.forEach((product) {
      String productName = product["PRODUCTNAME"];
      String productID = product["PRODUCTID"];
      String productURL = product["PRODUCTURL"];
      String productDesc= product["PRODUCTDESC"];
      String productTermsUrl= product["PRODUCTTERMSURL"];
      productIDToName[productID] = productName;
      productIDToDesc[productID] = productDesc;
      productIDToURL[productID] = productURL;
      productIDToTermsURL[productID] = productTermsUrl;
    });
  }

  Future<String?> getSavedBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedBranch');
  }

  Future<String?> getSavedProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedProduct');
  }

  Future<String?> getSavedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCurrency = prefs.getString('selectedCurrency');

    if (savedCurrency != null) {
      setState(() {
        selectedCurrency = savedCurrency;
        widget.customerData.currency = selectedCurrency!;
      });
    }

    return prefs.getString('selectedCurrency');
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAccountSelected = prefs.getBool('raoAccSelected') ?? false;
      productUrl = prefs.getString('raoProductUrl') ?? '';
      productDesc = prefs.getString('raoProductDesc') ?? '';
      productName = prefs.getString('raoProductName') ?? '';
      productTermsUrl = prefs.getString('raoProductTermsUrl') ?? '';

      widget.customerData.termsUrl = productTermsUrl;
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('raoAccSelected', isAccountSelected);
    await prefs.setString('raoProductName', productName);
    await prefs.setString('raoProductUrl', productUrl);
    await prefs.setString('raoProductDesc', productDesc);
    await prefs.setString('raoProductTermsUrl', productTermsUrl);
  }


  void ErrorAlert(String message) {
    // Implement your error alert logic here
  }

  void _launchTermsUrl(String url) async {
    launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ?
    Container(
      color: primaryLightVariant,
      child: Center(
        child: SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,),
      ),
    ) :
    SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isAccountSelected ?
            showAccountDescription ?
            Card(
              margin: EdgeInsets.only(top: 16),
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
                          productName,
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
                      productDesc,
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
                            showAccountDescription = false;
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
                  showAccountDescription = true;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16),
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
                      'View Account Description',
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
            ) : Container(),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Account Type',
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
                hintText: "Select Your Preferred Account Type",
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
              value:
              selectedAccount,
              onChanged: (newValue) {
                setState(() {
                  selectedAccount = newValue;
                  widget.customerData.accountType = newValue!;
                  widget.customerData.accountTypeName = getProductNameFromId(newValue)!;
                  saveSelectedProduct(newValue);
                  productName = getProductNameFromId(newValue)!;
                  productUrl = getProductURLFromId(newValue)!;
                  productDesc = getProductDescFromId(newValue)!;
                  productTermsUrl = getProductTermsUrlFromId(newValue)!;
                  widget.customerData.termsUrl = getProductTermsUrlFromId(newValue)!;
                  isAccountSelected = true;
                  _savePreferences();
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
              items: productIDToName.keys.map((productName) {
                return DropdownMenuItem(
                  value: productName,
                  child: Text(
                    productIDToName[productName]!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                    ),
                  ),
                );
              }).toList() ?? [],
            ),
            const SizedBox(
              height: 16,
            ),
            isAccountSelected ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Currency',
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
                    hintText: "Select Account Currency",
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
                  selectedCurrency, // Provide the currently selected value (can be null initially)
                  onChanged: (newValue) {
                    setState(() {
                      selectedCurrency = newValue;
                      widget.customerData.currency = newValue!;
                      saveSelectedCurrency(newValue);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                  items: currencyDropdownItems.map((String item) {
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
                  'Preferred Branch',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    fillColor: Colors.black,
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
                    hintText: "Select Your Preferred HFB Branch",
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
                  value:
                  selectedBranch, // Provide the currently selected value (can be null initially)
                  onChanged: (newValue) {
                    setState(() {
                      selectedBranch = newValue;
                      widget.customerData.branchName = getBranchNameFromId(newValue!);
                      saveSelectedBranch(newValue);
                      widget.customerData.branch = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                  items: branchIdToName.keys.map((branchName) {
                    return DropdownMenuItem(
                      value: branchName,
                      child: Text(
                        branchIdToName[branchName]!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "Manrope",
                        ),
                      ),
                    );
                  }).toList() ?? [],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: primaryLightVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Before proceeding, please read and agree to the Key Facts Document Terms of Use.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(right: 16, left: 8),
                        child: GestureDetector(
                          onTap: (){
                            _launchTermsUrl(productUrl);
                          },
                          child: Text(
                            'View Key Facts Document for ${productName}',
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 13,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: isAgreed,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                isAgreed = value ?? false;
                                widget.customerData.termsConditions = isAgreed;
                              });
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'I agree to the terms of use',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                )
              ],
            ) : Container(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String? getBranchNameFromId(String branchID) {
    return branchIdToName[branchID]; // Use the branchIdToName map
  }

  String? getProductNameFromId(String productID) {
    return productIDToName[productID]; // Use the branchIdToName map
  }

  String? getProductURLFromId(String productID) {
    return productIDToURL[productID]; // Use the branchIdToName map
  }
  String? getProductDescFromId(String productID) {
    return productIDToDesc[productID]; // Use the branchIdToName map
  }
  String? getProductTermsUrlFromId(String productID) {
    return productIDToTermsURL[productID]; // Use the branchIdToName map
  }
}
