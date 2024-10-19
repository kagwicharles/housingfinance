import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:intl/intl.dart';
import '../../../theme/theme.dart';
import '../headers/header_section.dart';
import 'UpdateStandingOrder.dart';

class StandingOrderScreen extends StatefulWidget {
  final bool isSkyBlueTheme;
  const StandingOrderScreen({required this.isSkyBlueTheme});
  @override
  State<StatefulWidget> createState() => _StandingOrderState();
}

class _StandingOrderState extends State<StandingOrderScreen> {
  bool querySuccess = false;
  bool queryHasData = true;
  bool isLoading = false;
  final _bankRepository = BankAccountRepository();
  final _pinController = TextEditingController();
  late Future<List<BankAccount>?> bankAccountsFuture;
  List<BankAccount> bankAccounts = [];
  int totalAccounts = 0;
  var _currentValue;
  var bankAcc;
  late List<Map<String, dynamic>> results;
  bool isSubmitting = false;
  bool isObscured = true;
  bool isLoaded = true;
  bool hideButton = false;

  getBankAccounts() => _bankRepository.getAllBankAccounts();

  _getSIList(String account) {
    final _api_service = APIService();
    _api_service.getSO(account).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        results =
            List<Map<String, dynamic>>.from(value.dynamicList as Iterable);
        setState(() {
          if (results.length == 0) {
            queryHasData = false;
          } else {
            queryHasData = true;
          }
          isSubmitting = false;
          querySuccess = true;
          isLoaded = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Manrope", fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Failed to fetch Standing Order details. Please try again later",
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  String extractValue(String input, String pattern) {
    RegExp regExp = RegExp(pattern);
    Match? match = regExp.firstMatch(input);
    if (match != null) {
      return match.group(1) ?? 'Not Found';
    } else {
      return 'Not Found';
    }
  }

  String removeDecimalPointAndZeroes(String value) {
    double parsedValue = double.tryParse(value) ?? 0.0;
    return parsedValue.toInt().toString();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<BankAccount>?>(
      future: getBankAccounts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<BankAccount>?> snapshot) {
        Widget child = SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(child: LoadUtil()),
        );
        if (snapshot.hasData) {
          totalAccounts = snapshot.data?.length ?? 0;
          bankAccounts = snapshot.data ?? [];

          var dropdownPicks = bankAccounts
              .fold<Map<String, dynamic>>(
                  {},
                  (acc, curr) => acc
                    ..[curr.bankAccountId] = curr.aliasName.isEmpty
                        ? curr.bankAccountId
                        : curr.aliasName)
              .entries
              .map((item) => DropdownMenuItem(
                    value: item.key,
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            color: primaryColor),
                        const SizedBox(width: 20),
                        Text(
                          item.value, // You can customize the displayed text
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontFamily: "DMSans",
                          ),
                        ),
                      ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  HeaderSectionApp(header: 'View Standing Order'),
                  Expanded(
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30)),
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              color: widget.isSkyBlueTheme
                                  ? primaryLight
                                  : primaryLightVariant,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 30),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        " Choose Account",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Manrope",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.white),
                                              borderRadius: BorderRadius.zero,
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 0),
                                          ),
                                          iconEnabledColor: primaryColor,
                                          style: const TextStyle(
                                            fontFamily: "DMSans",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.zero,
                                          value: _currentValue,
                                          items: dropdownPicks,
                                          onChanged: (value) {
                                            _currentValue = value.toString();
                                            setState(() {
                                              bankAcc = value.toString();
                                              // _getSIList(bankAcc);
                                              hideButton = false;
                                              // isLoaded = false;
                                            });
                                          }),
                                      const SizedBox(height: 16),
                                      querySuccess
                                          ?
                                      Padding(padding: EdgeInsets.only(bottom: 16),
                                        child: const Text(
                                          'Transactions',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),) :
                                      isLoading
                                          ? const SpinKitSpinningLines(
                                        color: primaryColor,
                                        duration: Duration(milliseconds: 2000),
                                        size: 30,)
                                          : GestureDetector(
                                        onTap: () {
                                          _getSIList(bankAcc);
                                          hideButton = true;
                                          isLoaded = false;
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
                                              child: Text('View Standing Order',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontFamily: "DMSans",
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            )
                                        ),
                                      ),
                                      // isLoading
                                      //     ? const SpinKitSpinningLines(
                                      //   color: primaryColor,
                                      //   duration:
                                      //   Duration(milliseconds: 2000),
                                      //   size: 30,
                                      // )
                                      //     : GestureDetector(
                                      //   onTap: () {
                                      //     _getSIList(bankAcc);
                                      //     hideButton = true;
                                      //     isLoaded = false;
                                      //   },
                                      //   child: Container(
                                      //     margin: EdgeInsets.symmetric(horizontal: 6),
                                      //       decoration: BoxDecoration(
                                      //           borderRadius:
                                      //           BorderRadius.circular(12),
                                      //           color: primaryColor),
                                      //       width: MediaQuery.of(context)
                                      //           .size
                                      //           .width,
                                      //       height: 44,
                                      //       child: const Center(
                                      //         child: Text(
                                      //           'View Standing Order',
                                      //           style: TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 13,
                                      //             fontFamily: "DMSans",
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       )),
                                      // ),
                                    ],
                                  ),),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  querySuccess
                                      ?
                                  Expanded(child: Container(
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        child: Column(
                                          children: [
                                            querySuccess
                                                ? Expanded(child: ListView.builder(
                                              itemCount:
                                              results.length,
                                              itemBuilder:
                                                  (BuildContext
                                              context,
                                                  index) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      top: 16.0,
                                                      left: 5.0,
                                                      right:
                                                      5.0),
                                                  child: Card(
                                                    margin:
                                                    EdgeInsets
                                                        .zero,
                                                    surfaceTintColor:
                                                    Colors
                                                        .white,
                                                    elevation: 2,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .zero),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(
                                                          16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'Standing Order #${index + 1}',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                15,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const Divider(
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                          const Text(
                                                            'Debit Account',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          Text(
                                                            '${results[index]['debitAccountID']}',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                              8),
                                                          const Text(
                                                            'Credit Account',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          Text(
                                                            '${results[index]['creditAccountID']}',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                              8),
                                                          const Text(
                                                            'Amount',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          Text(
                                                            '${results[index]['amount']}',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                              8),
                                                          const Text(
                                                            'Frequency',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          Text(
                                                            '${results[index]['trfFrequencyID']}' ==
                                                                'W'
                                                                ? 'Weekly'
                                                                : '${results[index]['trfFrequencyID']}' == 'D'
                                                                ? 'Daily'
                                                                : '${results[index]['trfFrequencyID']}' == 'Y'
                                                                ? 'Yearly'
                                                                : '${results[index]['trfFrequencyID']}' == 'O'
                                                                ? 'One Time'
                                                                : '${results[index]['trfFrequencyID']}' == 'Q'
                                                                ? 'Quarterly'
                                                                : '${results[index]['trfFrequencyID']}' == 'F'
                                                                ? 'Fortnightly'
                                                                : '${results[index]['trfFrequencyID']}' == 'H'
                                                                ? 'Half Yearly'
                                                                : '${results[index]['trfFrequencyID']}' == 'M'
                                                                ? 'Monthly'
                                                                : '',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                              8),
                                                          const Text(
                                                            'Next Execution Date',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          Text(
                                                            '${results[index]['nextExecutionDate']}',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                              8),
                                                          const Text(
                                                            'Number of Executions',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                Colors.grey),
                                                          ),
                                                          Text(
                                                            '${results[index]['noOfExecutions']}',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontFamily:
                                                                "Manrope",
                                                                color:
                                                                primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                              16),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                130,
                                                                height:
                                                                50,
                                                                child:
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    String ref = results[index]['ReferenceNo'];
                                                                    String siid = results[index]['SIID'];
                                                                    String dbAcc = results[index]['debitAccountID'];
                                                                    String crAcc = results[index]['creditAccountID'];
                                                                    String amount = results[index]['amount'];
                                                                    String trFreqID = results[index]['trfFrequencyID'];
                                                                    String nextExDate = results[index]['nextExecutionDate'];
                                                                    String noOfEx = results[index]['noOfExecutions'];
                                                                    String firstEx = results[index]['firstExecutionDate'];
                                                                    String lastEx = results[index]['lastExecutionDate'];
                                                                    String regEx = results[index]['regularExecutionDay'];
                                                                    CommonUtils.navigateToRoute(
                                                                      context: context,
                                                                      widget: UpdateStandingOrder(
                                                                        dbAcc: dbAcc,
                                                                        crAcc: crAcc,
                                                                        amount: amount,
                                                                        siid: siid,
                                                                        noOfEx: noOfEx,
                                                                        trFrqID: trFreqID,
                                                                        nextEx: _formatDate(nextExDate),
                                                                        firstEx: _formatDate(firstEx),
                                                                        lastEx: _formatDate(lastEx),
                                                                        regEx: regEx,
                                                                      ),
                                                                    );
                                                                    print(
                                                                      'Update button pressed for SIID: ${results[index]['SIID']}',
                                                                    );
                                                                  },
                                                                  child: const Text('Update'),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                130,
                                                                height:
                                                                50,
                                                                child:
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        String reason = ''; // Initialize the reason variable

                                                                        return StatefulBuilder(
                                                                          builder: (BuildContext context, StateSetter setState) {
                                                                            return AlertDialog(
                                                                              title: const Text(
                                                                                "Alert",
                                                                                style: TextStyle(fontFamily: "Manrope", color: primaryColor, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  const Text(
                                                                                    "Are you sure you want to Terminate this Standing order?",
                                                                                    style: TextStyle(fontFamily: "Manrope"),
                                                                                  ),
                                                                                  const SizedBox(height: 16),
                                                                                  TextField(
                                                                                    onChanged: (value) {
                                                                                      setState(() {
                                                                                        reason = value; // Update the reason variable when the text changes
                                                                                      });
                                                                                    },
                                                                                    decoration: const InputDecoration(
                                                                                      hintText: 'Enter reason for termination',
                                                                                      border: OutlineInputBorder(),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  WidgetFactory.buildTextField(
                                                                                    context,
                                                                                    TextFormFieldProperties(
                                                                                      isEnabled: true,
                                                                                      isObscured: isObscured,
                                                                                      controller: _pinController,
                                                                                      textInputType: TextInputType.number,
                                                                                      inputDecoration: InputDecoration(
                                                                                        hintText: "Enter PIN",
                                                                                        suffixIconColor: primaryColor,
                                                                                        suffixIcon: IconButton(
                                                                                          icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                                                                                          onPressed: () {
                                                                                            setState(() {
                                                                                              isObscured = !isObscured;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                        (value) {},
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  child: const Text(
                                                                                    "Cancel",
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: reason.isEmpty
                                                                                      ? null // Disable the button if the reason is empty
                                                                                      : () {
                                                                                    if (_pinController.text.length < 4) {
                                                                                      Fluttertoast.showToast(
                                                                                        msg: "Please enter a valid pin",
                                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                                        gravity: ToastGravity.BOTTOM,
                                                                                        timeInSecForIosWeb: 1,
                                                                                        backgroundColor: Colors.red,
                                                                                        textColor: Colors.white,
                                                                                        fontSize: 16.0,
                                                                                      );
                                                                                    } else {
                                                                                      String ref = results[index]['ReferenceNo'];
                                                                                      String siid = results[index]['SIID'];
                                                                                      String dbAcc = results[index]['debitAccountID'];
                                                                                      String noOfEx = results[index]['noOfExecutions'];

                                                                                      _deleteSO(dbAcc, noOfEx, siid, ref, reason);
                                                                                      setState(() {
                                                                                        isLoaded = false;
                                                                                      });
                                                                                      Navigator.of(context).pop();
                                                                                    }
                                                                                  },
                                                                                  child: const Text(
                                                                                    "Proceed",
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: const Text('Terminate'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ))
                                                : const EmptyUtil()
                                          ],
                                        ),
                                      )
                                  )) : SizedBox(width: 0, height: 470,)
                                  // Container(
                                  //     height: 600,
                                  //     color: const Color.fromARGB(
                                  //         255, 219, 220, 221),
                                  //     child: Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             left: 15, right: 15, top: 10),
                                  //         child: isLoaded
                                  //             ? querySuccess
                                  //                 ? queryHasData
                                  //                     ? ListView.builder(
                                  //                         itemCount:
                                  //                             results.length,
                                  //                         itemBuilder:
                                  //                             (BuildContext
                                  //                                     context,
                                  //                                 index) {
                                  //                           return Padding(
                                  //                             padding:
                                  //                                 const EdgeInsets
                                  //                                     .only(
                                  //                                     top: 16.0,
                                  //                                     left: 5.0,
                                  //                                     right:
                                  //                                         5.0),
                                  //                             child: Card(
                                  //                               margin:
                                  //                                   EdgeInsets
                                  //                                       .zero,
                                  //                               surfaceTintColor:
                                  //                                   Colors
                                  //                                       .white,
                                  //                               elevation: 2,
                                  //                               shape: const RoundedRectangleBorder(
                                  //                                   borderRadius:
                                  //                                       BorderRadius
                                  //                                           .zero),
                                  //                               child: Padding(
                                  //                                 padding:
                                  //                                     const EdgeInsets
                                  //                                         .all(
                                  //                                         16.0),
                                  //                                 child: Column(
                                  //                                   crossAxisAlignment:
                                  //                                       CrossAxisAlignment
                                  //                                           .start,
                                  //                                   children: [
                                  //                                     Text(
                                  //                                       'Standing Order #${index + 1}',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontSize:
                                  //                                               15,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     Divider(
                                  //                                       color: Colors
                                  //                                           .grey,
                                  //                                     ),
                                  //                                     const Text(
                                  //                                       'Debit Account',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .normal,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               Colors.grey),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${results[index]['debitAccountID']}',
                                  //                                       style: const TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                         height:
                                  //                                             8),
                                  //                                     const Text(
                                  //                                       'Credit Account',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .normal,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               Colors.grey),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${results[index]['creditAccountID']}',
                                  //                                       style: const TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                         height:
                                  //                                             8),
                                  //                                     const Text(
                                  //                                       'Amount',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .normal,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               Colors.grey),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${results[index]['amount']}',
                                  //                                       style: const TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                         height:
                                  //                                             8),
                                  //                                     const Text(
                                  //                                       'Frequency',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .normal,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               Colors.grey),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${results[index]['trfFrequencyID']}' ==
                                  //                                               'W'
                                  //                                           ? 'Weekly'
                                  //                                           : '${results[index]['trfFrequencyID']}' == 'D'
                                  //                                               ? 'Daily'
                                  //                                               : '${results[index]['trfFrequencyID']}' == 'Y'
                                  //                                                   ? 'Yearly'
                                  //                                                   : '${results[index]['trfFrequencyID']}' == 'O'
                                  //                                                       ? 'One Time'
                                  //                                                       : '${results[index]['trfFrequencyID']}' == 'Q'
                                  //                                                           ? 'Quarterly'
                                  //                                                           : '${results[index]['trfFrequencyID']}' == 'F'
                                  //                                                               ? 'Fortnightly'
                                  //                                                               : '${results[index]['trfFrequencyID']}' == 'H'
                                  //                                                                   ? 'Half Yearly'
                                  //                                                                   : '${results[index]['trfFrequencyID']}' == 'M'
                                  //                                                                       ? 'Monthly'
                                  //                                                                       : '',
                                  //                                       style: const TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                         height:
                                  //                                             8),
                                  //                                     const Text(
                                  //                                       'Next Execution Date',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .normal,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               Colors.grey),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${results[index]['nextExecutionDate']}',
                                  //                                       style: const TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                         height:
                                  //                                             8),
                                  //                                     const Text(
                                  //                                       'Number of Executions',
                                  //                                       style: TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .normal,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               Colors.grey),
                                  //                                     ),
                                  //                                     Text(
                                  //                                       '${results[index]['noOfExecutions']}',
                                  //                                       style: const TextStyle(
                                  //                                           fontWeight: FontWeight
                                  //                                               .bold,
                                  //                                           fontFamily:
                                  //                                               "Manrope",
                                  //                                           color:
                                  //                                               primaryColor),
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                         height:
                                  //                                             16),
                                  //                                     Row(
                                  //                                       mainAxisAlignment:
                                  //                                           MainAxisAlignment.spaceBetween,
                                  //                                       children: [
                                  //                                         SizedBox(
                                  //                                           width:
                                  //                                               130,
                                  //                                           height:
                                  //                                               50,
                                  //                                           child:
                                  //                                               ElevatedButton(
                                  //                                             onPressed: () {
                                  //                                               String ref = results[index]['ReferenceNo'];
                                  //                                               String siid = results[index]['SIID'];
                                  //                                               String dbAcc = results[index]['debitAccountID'];
                                  //                                               String crAcc = results[index]['creditAccountID'];
                                  //                                               String amount = results[index]['amount'];
                                  //                                               String trFreqID = results[index]['trfFrequencyID'];
                                  //                                               String nextExDate = results[index]['nextExecutionDate'];
                                  //                                               String noOfEx = results[index]['noOfExecutions'];
                                  //                                               String firstEx = results[index]['firstExecutionDate'];
                                  //                                               String lastEx = results[index]['lastExecutionDate'];
                                  //                                               String regEx = results[index]['regularExecutionDay'];
                                  //                                               CommonUtils.navigateToRoute(
                                  //                                                 context: context,
                                  //                                                 widget: UpdateStandingOrder(
                                  //                                                   dbAcc: dbAcc,
                                  //                                                   crAcc: crAcc,
                                  //                                                   amount: amount,
                                  //                                                   siid: siid,
                                  //                                                   noOfEx: noOfEx,
                                  //                                                   trFrqID: trFreqID,
                                  //                                                   nextEx: _formatDate(nextExDate),
                                  //                                                   firstEx: _formatDate(firstEx),
                                  //                                                   lastEx: _formatDate(lastEx),
                                  //                                                   regEx: regEx,
                                  //                                                 ),
                                  //                                               );
                                  //                                               print(
                                  //                                                 'Update button pressed for SIID: ${results[index]['SIID']}',
                                  //                                               );
                                  //                                             },
                                  //                                             child: const Text('Update'),
                                  //                                           ),
                                  //                                         ),
                                  //                                         SizedBox(
                                  //                                           width:
                                  //                                               130,
                                  //                                           height:
                                  //                                               50,
                                  //                                           child:
                                  //                                               ElevatedButton(
                                  //                                             onPressed: () {
                                  //                                               showDialog(
                                  //                                                 context: context,
                                  //                                                 builder: (BuildContext context) {
                                  //                                                   String reason = ''; // Initialize the reason variable
                                  //
                                  //                                                   return StatefulBuilder(
                                  //                                                     builder: (BuildContext context, StateSetter setState) {
                                  //                                                       return AlertDialog(
                                  //                                                         title: const Text(
                                  //                                                           "Alert",
                                  //                                                           style: TextStyle(fontFamily: "Manrope", color: primaryColor, fontWeight: FontWeight.bold),
                                  //                                                         ),
                                  //                                                         content: Column(
                                  //                                                           mainAxisSize: MainAxisSize.min,
                                  //                                                           children: [
                                  //                                                             const Text(
                                  //                                                               "Are you sure you want to Terminate this Standing order?",
                                  //                                                               style: TextStyle(fontFamily: "Manrope"),
                                  //                                                             ),
                                  //                                                             const SizedBox(height: 16),
                                  //                                                             TextField(
                                  //                                                               onChanged: (value) {
                                  //                                                                 setState(() {
                                  //                                                                   reason = value; // Update the reason variable when the text changes
                                  //                                                                 });
                                  //                                                               },
                                  //                                                               decoration: const InputDecoration(
                                  //                                                                 hintText: 'Enter reason for termination',
                                  //                                                                 border: OutlineInputBorder(),
                                  //                                                               ),
                                  //                                                             ),
                                  //                                                             const SizedBox(
                                  //                                                               height: 5,
                                  //                                                             ),
                                  //                                                             WidgetFactory.buildTextField(
                                  //                                                               context,
                                  //                                                               TextFormFieldProperties(
                                  //                                                                 isEnabled: true,
                                  //                                                                 isObscured: isObscured,
                                  //                                                                 controller: _pinController,
                                  //                                                                 textInputType: TextInputType.number,
                                  //                                                                 inputDecoration: InputDecoration(
                                  //                                                                   hintText: "Enter PIN",
                                  //                                                                   suffixIconColor: primaryColor,
                                  //                                                                   suffixIcon: IconButton(
                                  //                                                                     icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                                  //                                                                     onPressed: () {
                                  //                                                                       setState(() {
                                  //                                                                         isObscured = !isObscured;
                                  //                                                                       });
                                  //                                                                     },
                                  //                                                                   ),
                                  //                                                                 ),
                                  //                                                               ),
                                  //                                                               (value) {},
                                  //                                                             ),
                                  //                                                           ],
                                  //                                                         ),
                                  //                                                         actions: <Widget>[
                                  //                                                           TextButton(
                                  //                                                             child: const Text(
                                  //                                                               "Cancel",
                                  //                                                               style: TextStyle(fontWeight: FontWeight.bold),
                                  //                                                             ),
                                  //                                                             onPressed: () {
                                  //                                                               Navigator.of(context).pop();
                                  //                                                             },
                                  //                                                           ),
                                  //                                                           TextButton(
                                  //                                                             child: const Text(
                                  //                                                               "Proceed",
                                  //                                                               style: TextStyle(fontWeight: FontWeight.bold),
                                  //                                                             ),
                                  //                                                             onPressed: reason.isEmpty
                                  //                                                                 ? null // Disable the button if the reason is empty
                                  //                                                                 : () {
                                  //                                                                     if (_pinController.text.length < 4) {
                                  //                                                                       Fluttertoast.showToast(
                                  //                                                                         msg: "Please enter a valid pin",
                                  //                                                                         toastLength: Toast.LENGTH_SHORT,
                                  //                                                                         gravity: ToastGravity.BOTTOM,
                                  //                                                                         timeInSecForIosWeb: 1,
                                  //                                                                         backgroundColor: Colors.red,
                                  //                                                                         textColor: Colors.white,
                                  //                                                                         fontSize: 16.0,
                                  //                                                                       );
                                  //                                                                     } else {
                                  //                                                                       String ref = results[index]['ReferenceNo'];
                                  //                                                                       String siid = results[index]['SIID'];
                                  //                                                                       String dbAcc = results[index]['debitAccountID'];
                                  //                                                                       String noOfEx = results[index]['noOfExecutions'];
                                  //
                                  //                                                                       _deleteSO(dbAcc, noOfEx, siid, ref, reason);
                                  //                                                                       setState(() {
                                  //                                                                         isLoaded = false;
                                  //                                                                       });
                                  //                                                                       Navigator.of(context).pop();
                                  //                                                                     }
                                  //                                                                   },
                                  //                                                           ),
                                  //                                                         ],
                                  //                                                       );
                                  //                                                     },
                                  //                                                   );
                                  //                                                 },
                                  //                                               );
                                  //                                             },
                                  //                                             child: const Text('Terminate'),
                                  //                                           ),
                                  //                                         )
                                  //                                       ],
                                  //                                     ),
                                  //                                   ],
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                           );
                                  //                         },
                                  //                       )
                                  //                     : const Center(
                                  //                         child: Column(
                                  //                           mainAxisAlignment:
                                  //                               MainAxisAlignment
                                  //                                   .center,
                                  //                           crossAxisAlignment:
                                  //                               CrossAxisAlignment
                                  //                                   .center,
                                  //                           children: [
                                  //                             Image(
                                  //                               image: AssetImage(
                                  //                                   "assets/images/sad.png"),
                                  //                             ),
                                  //                             SizedBox(
                                  //                               height: 20,
                                  //                             ),
                                  //                             Text(
                                  //                               "Nothing to show",
                                  //                               textAlign:
                                  //                                   TextAlign
                                  //                                       .center,
                                  //                               style: TextStyle(
                                  //                                   fontFamily:
                                  //                                       "Manrope",
                                  //                                   fontSize:
                                  //                                       18,
                                  //                                   height: 1.1,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .normal,
                                  //                                   color: Colors
                                  //                                       .black),
                                  //                             ),
                                  //                             SizedBox(
                                  //                               height: 100,
                                  //                             ),
                                  //                           ],
                                  //                         ),
                                  //                       )
                                  //                 : SizedBox()
                                  //             : LoadUtil())),
                                ],
                              )))),
                ],
              ));
        }
        return child;
      });

  _deleteSO(
      String account, String noOfEx, String siid, String ref, String reason) {
    final _api_service = APIService();
    _api_service
        .deleteStandingOrder(account, noOfEx, siid, ref, reason,
            CryptLib.encryptField(_pinController.text))
        .then((value) {
      if (value.status == StatusCode.success.statusCode) {
        _showDialogue(value.message.toString(), account);
        setState(() {
          isSubmitting = false;
        });
      } else {
        _showDialogue(value.message.toString(), account);
      }
    });
  }

  _showDialogue(String msg, String account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(
                fontFamily: "Manrope", fontWeight: FontWeight.bold),
          ),
          content: Text(
            msg,
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
                isSubmitting = true;
                _getSIList(account);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _formatDate(String date) {
    // Parse the original date string into a DateTime object
    DateFormat originalFormat = DateFormat("MM/dd/yyyy hh:mm:ss a");
    DateTime dateTime = originalFormat.parse(date);

    // Format the DateTime object into the desired format
    DateFormat newFormat = DateFormat("dd/MM/yyyy");
    String formattedDateString = newFormat.format(dateTime);

    return formattedDateString;
  }
}
