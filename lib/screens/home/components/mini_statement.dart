import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';
import '../../../theme/theme.dart';
import 'numberFormatter.dart';

class Ministatement extends StatefulWidget {
  final bool isSkyBlueTheme;
  final List<BankAccount> accounts;
  const Ministatement({required this.isSkyBlueTheme, required this.accounts});

  @override
  State<Ministatement> createState() => _MinistatementState();
}

class _MinistatementState extends State<Ministatement> {
  final _bankAccountRepository = BankAccountRepository();
  final _profileRepository = ProfileRepository();
  bool _isLoading = false;
  bool querySuccess = false;
  var _currentValue, ministatement;
  List<bool> booleans = [];
  List<BankAccount> bankAccounts = [];
  bool showTransactionList = false;
  String account = "";

  Future<List<BankAccount>?> getBankAccounts() =>
      _bankAccountRepository.getAllBankAccounts();

  getMiniStatement(String account) async {
    await _profileRepository
        .checkMiniStatement(account, merchantID: "MINISTATEMENT")
        .then((value) {
      debugPrint('ministmst${value?.dynamicList}');
      if (value?.status == StatusCode.success.statusCode) {
        print("MINI_STAT " + value.toString());

        setState(() {
          showTransactionList = true;
          _isLoading = false;
          if (value?.dynamicList != []) {
            querySuccess = true;
            ministatement = value?.dynamicList;
          }
        });

        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: ((context) =>
        //         Statement(ministatement: value?.accountStatement))));
      } else {
        AlertUtil.showAlertDialog(context, value?.message ?? "Error");
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dropdownPicks = widget.accounts
        .fold<Map<String, dynamic>>(
        {},
            (acc, curr) =>
        acc
          ..[curr.bankAccountId] =
          curr.aliasName.isEmpty ? curr.bankAccountId : curr.aliasName)
        .entries
        .map((item) =>
        DropdownMenuItem(
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
    }
    // Generate dropdown items based on fetched bank accounts
    // var dropdownPicks = bankAccounts
    //     .map((account) => DropdownMenuItem(
    //   value: account.bankAccountId,
    //   child: Row(
    //     children: [
    //       Icon(Icons.account_balance_wallet_outlined,
    //           color: primaryColor),
    //       const SizedBox(width: 20),
    //       Text(
    //         account.bankAccountId, // You can customize the displayed text
    //         style: const TextStyle(
    //           fontSize: 12,
    //           color: primaryColor,
    //           fontFamily: "DMSans",
    //         ),
    //       ),
    //     ],
    //   ),
    // ))
    //     .toList();

    // Initialize the first bank account as the default value, if available
    if (_currentValue == null && dropdownPicks.isNotEmpty) {
      _currentValue = dropdownPicks[0].value;
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          const SizedBox(height: 20),
          HeaderSectionApp(header: 'Mini-statement'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
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
                            setState(() {
                              _currentValue = value.toString();
                              showTransactionList = false;
                              account = _currentValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        showTransactionList
                            ?
                        Padding(padding: EdgeInsets.only(bottom: 16),
                          child: Align(
                            alignment: Alignment.center,
                            child: const Text(
                              'Transactions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          )
                          ,) :
                        _isLoading
                            ? const SpinKitSpinningLines(
                          color: primaryColor,
                          duration: Duration(milliseconds: 2000),
                          size: 30,)
                            : GestureDetector(
                          onTap: () {
                            getMiniStatement(account);

                            setState(() {
                              _isLoading = true;
                            });
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
                                child: Text('Check Mini-Statement',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: "DMSans",
                                    fontWeight: FontWeight.bold,
                                  ),),
                              )
                          ),
                        )
                      ],
                    ),),
                  showTransactionList
                      ?
                  Expanded(child: Container(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          children: [
                            querySuccess
                                ? Expanded(child: TransactionsList(
                              miniStatement: ministatement,
                            ))
                                : const EmptyUtil()
                          ],
                        ),
                      )
                  )) : SizedBox(width: 0, height: 490,)
                ],
              ),
            ),
          ),)
        ],
      ),
    );
  }
}

class TransactionsList extends StatelessWidget {
  final List<dynamic> miniStatement;
  List<Transaction> transactionList = [];

  TransactionsList({required this.miniStatement}) {
    addTransactions(list: miniStatement);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8),
      shrinkWrap: true,
      itemCount: transactionList.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: Card(
            margin: EdgeInsets.zero,
            surfaceTintColor: transactionList[index].trxType == "D"
                ? Colors.yellow[50]
                : Color.fromRGBO(214, 228, 255, 1),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child:                   Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ImageIcon(
                          AssetImage(transactionList[index].trxType == "D" ? "assets/images/outcome.png" : "assets/images/income.png"),
                          size: 28,
                          color: transactionList[index].trxType == "C" ? primaryColor : secondaryAccent,// Adjust the size as needed
                        ),
                      ),
                      SizedBox(width: 16,),
                      Flexible(child: Text(
                        // 'Transaction #${index + 1}',
                        transactionList[index].desc,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "DMSans", color: Colors.black),
                      ),)
                    ],
                  ),),
                  Divider(
                    color: transactionList[index].trxType == "D"
                        ? secondaryAccent
                        : primaryColor,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Description',
                        style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "DMSans", color: Colors.grey,),
                      ),
                      Text(
                        transactionList[index].narration,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "DMSans", color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: transactionList[index].trxType == "D"
                              ? secondaryAccent
                              : primaryColor,),
                          SizedBox(width: 16,),
                          Text(
                            transactionList[index].date,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontFamily: "DMSans",color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, color: transactionList[index].trxType == "D"
                              ? secondaryAccent
                              : primaryColor,),
                          SizedBox(width: 16,),
                          Text(
                            transactionList[index].beneficiary,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontFamily: "DMSans",color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Transaction Reference',
                        style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "DMSans", color: Colors.grey),
                      ),
                      Text(
                        transactionList[index].Ref,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "DMSans", color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                transactionList[index].trxType == "D"
                                    ? "Debit"
                                    : "Credit",
                                style: TextStyle(
                                  fontFamily: "DMSans",
                                  fontWeight: FontWeight.bold,
                                  color: transactionList[index].trxType == "D"
                                      ? secondaryAccent
                                      : primaryColor,
                                ),
                              ),
                              Text(
                                formatAmount(transactionList[index].amount.toString()),
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontFamily: "DMSans",
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addTransactions({required List<dynamic> list}) {
    transactionList = list.map((item) => Transaction.fromJson(item)).toList();
  }
}

class Transaction {
  String date;
  String amount;
  String narration;
  String trxType;
  String Ref;
  String desc;
  String beneficiary;

  Transaction({required this.date,
    required this.amount,
    required this.trxType,
    required this.narration,
    required this.desc,
    required this.beneficiary,
    required this.Ref});

  Transaction.fromJson(Map<String, dynamic> json)
      : date = json["TrxDate"],
        amount = json["LocalCurrency"],
        desc = json["Trx"],
        beneficiary = json["AccountNumber"],
        Ref = json["ReferenceNumber"],
        trxType = json["TransactionType"],
        narration = json["ModuleDesc"];

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
