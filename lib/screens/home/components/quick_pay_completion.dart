
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/home/components/reciept.dart';

import '../../../theme/theme.dart';
import '../headers/header_section.dart';
import 'numberFormatter.dart';

class QuickPayTrxCompletion extends StatefulWidget {
  final String TypeOfMerchant;
  final String MerchantName;
  final String Beneficiary;
  final String TrxDate;
  final int Amount;
  final String merchantID;
  final String moduleID;
  final String INFOFIELD1;
  final String INFOFIELD2;
  final String INFOFIELD3;
  final String INFOFIELD4;
  final String INFOFIELD6;
  final String INFOFIELD7;
  final String INFOFIELD9;
  final bool isSkyBlueTheme;

  const QuickPayTrxCompletion({
    required this.TypeOfMerchant,
    required this.MerchantName,
    required this.Beneficiary,
    required this.TrxDate,
    required this.merchantID,
    required this.moduleID,
    required this.INFOFIELD1,
    required this.INFOFIELD2,
    required this.INFOFIELD3,
    required this.INFOFIELD4,
    required this.INFOFIELD6,
    required this.INFOFIELD7,
    required this.INFOFIELD9,
    required this.Amount,
  required this.isSkyBlueTheme});

  @override
  State<QuickPayTrxCompletion> createState() => _quickPayTrxCompletionState();
}

class _quickPayTrxCompletionState extends State<QuickPayTrxCompletion> {
  final _bankRepository = BankAccountRepository();
  bool isSubmitting = false;
  int totalAccounts = 0;
  List<BankAccount> bankAccounts = [];
  var _currentValue;
  var bankAcc;
  final _pinController = TextEditingController();
  bool isObscured = true;

  getBankAccounts() => _bankRepository.getAllBankAccounts();

  sendQuickPayTrx() {
    final _api_service = APIService();
    _api_service.quickPay(
      widget.moduleID,
      widget.merchantID,
      widget.Beneficiary,
      widget.Amount.toString(),
      bankAcc,
      widget.INFOFIELD1,
      widget.INFOFIELD2,
      widget.INFOFIELD3,
      widget.INFOFIELD4,
      widget.INFOFIELD6,
      widget.INFOFIELD7,
      widget.INFOFIELD9,
      CryptLib.encryptField(_pinController.text),
    ).then((value) {

      setState(() {
        isSubmitting = false;
      });

      if (value.status == StatusCode.success.statusCode) {

        CommonUtils.navigateToRoute(
            context: context,
            widget: TrxReceipt(
              recieptDetails: value.receiptDetails, isSkyBlueTheme: widget.isSkyBlueTheme,
            ));
        setState(() {

        });
      }else{
        _showAlert("Alert!",  value.message.toString());
      }
    });
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

  @override
  Widget build(BuildContext context) => FutureBuilder<List<BankAccount>?>(
      future: getBankAccounts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<BankAccount>?> snapshot) {
        Widget child = SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(child: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,)),
        );
        if (snapshot.hasData) {
          totalAccounts =
              snapshot.data?.length ?? 0;
          bankAccounts = snapshot.data ?? [];

          var dropdownPicks = bankAccounts
              .fold<Map<String, dynamic>>(
              {},
                  (acc, curr) => acc
                ..[curr.bankAccountId] =
                curr.aliasName.isEmpty ? curr.bankAccountId : curr.aliasName)
              .entries
              .map((item) => DropdownMenuItem(
            value: item.key,
            child: Text(
              item.value,
              style: const TextStyle(
                fontSize: 14,
                color: primaryColor,
                fontFamily: "Manrope",
              ),
            ),
          ))
              .toList();
          dropdownPicks.toSet().toList();
          if (dropdownPicks.isNotEmpty) {
            _currentValue = dropdownPicks[0].value;
            bankAcc ??= dropdownPicks[0].value;
          }

          child = Scaffold(
            backgroundColor: primaryColor,
              body: Column(
            children: [
              const SizedBox(height: 20),
              HeaderSectionApp(header: 'Complete Transaction'),
              Expanded(child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  color: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            "Choose Account",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.zero,
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                              ),
                              iconEnabledColor: primaryColor,
                              style: const TextStyle(
                                fontFamily: "DMSans",
                                fontWeight: FontWeight.normal,
                              ),
                              borderRadius: BorderRadius.zero,
                              value: _currentValue,
                              items: dropdownPicks,
                              onChanged: (value) {
                                _currentValue = value.toString();
                                setState(() {
                                  bankAcc = value.toString();
                                });
                              }),
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
                          Card(
                            margin: EdgeInsets.zero,
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                                  child:  const Text(
                                    'Transaction Details',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Manrope", color: primaryColor),
                                  ),),
                                  const Divider(
                                    color: primaryColor,
                                  ),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Type',
                                      style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "Manrope", color: Colors.grey),
                                    ),
                                    Text(
                                      widget.MerchantName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Manrope",color: primaryColor),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Amount',
                                      style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "Manrope", color: Colors.grey),
                                    ),
                                    Text(
                                      formatAmount(widget.Amount.toString()),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Manrope", color: primaryColor),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Utility Account',
                                      style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "Manrope", color: Colors.grey),
                                    ),
                                    Text(
                                      widget.Beneficiary,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Manrope", color: primaryColor),
                                    ),
                                  ],
                                ),)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Enter Pin",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            obscureText: isObscured,
                            style: TextStyle(
                                fontFamily: "Manrope",
                                fontSize: 13,
                                color: primaryColor
                            ),
                            keyboardType: TextInputType.number,
                            controller: _pinController,
                            onChanged: (value) {
                              setState(() {
                                _pinController.text = value;
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
                              hintText: "Enter Pin",
                              suffixIcon:  IconButton(
                                icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                                color: primaryColor,
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Please enter your pin';
                              }
                              if (value != 4){
                                return "Please enter a valid pin";
                              }
                              return null;
                            },
                            // onChanged and initialValue can be added as needed
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(top: 16, bottom: 0),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Color.fromARGB(255, 219, 220, 221)),
                          //       borderRadius: BorderRadius.zero
                          //   ),
                          //   child: WidgetFactory.buildTextField(
                          //     context,
                          //     TextFormFieldProperties(
                          //       isEnabled: true,
                          //       isObscured: isObscured,
                          //       controller: _pinController,
                          //       textInputType: TextInputType.number,
                          //       inputDecoration: InputDecoration(
                          //         labelText: "PIN",
                          //         labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 80, 170), fontFamily: "Manrope"),
                          //         floatingLabelBehavior: FloatingLabelBehavior.always,
                          //         hintText: "Enter PIN",
                          //         suffixIconColor: primaryColor,
                          //         suffixIcon: IconButton(
                          //           icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                          //           onPressed: () {
                          //             setState(() {
                          //               isObscured = !isObscured;
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //         (value) {
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          isSubmitting ?
                          const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,) :
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSubmitting = true;
                              });
                              sendQuickPayTrx();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: primaryColor),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 44,
                                child: const Center(
                                  child: Text('Complete Transaction',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: "DMSans",
                                      fontWeight: FontWeight.bold,
                                    ),),
                                )
                            ),
                          )
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 50,
                          //   child: isSubmitting ?
                          //   const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,) :
                          //   WidgetFactory.buildButton(context, () {
                          //     if (_pinController.text.length < 4) {
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return AlertDialog(
                          //             title: const Text(
                          //               "Alert",
                          //               style: TextStyle(
                          //                   fontFamily: "Manrope", fontWeight: FontWeight.bold),
                          //             ),
                          //             content: const Text(
                          //               "Please enter a valid pin",
                          //               style: TextStyle(
                          //                 fontFamily: "Manrope",
                          //               ),
                          //             ),
                          //             actions: <Widget>[
                          //               TextButton(
                          //                 child: const Text(
                          //                   "OK",
                          //                   style: TextStyle(fontWeight: FontWeight.bold),
                          //                 ),
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop();
                          //                 },
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     }else{
                          //       setState(() {
                          //         isSubmitting = true;
                          //       });
                          //       sendQuickPayTrx();
                          //     }
                          //   }, "Pay",
                          //       color: const Color.fromRGBO(129, 190, 65, 1)),
                          // )
                        ],
                      ),
                    )),
                ),
              ),)
            ],
          ));
        }
        return child;
      });
}

String formatAmount(String amount){
  String formatedBal = formatCurrency(removeDecimalPointAndZeroes(amount));
  String wholeBal = formatedBal.split('.')[0];
  String finalAmount = "UGX $wholeBal";

  return finalAmount;
}

String removeDecimalPointAndZeroes(String value) {
  double parsedValue = double.tryParse(value) ?? 0.0;
  return parsedValue.toInt().toString();
}