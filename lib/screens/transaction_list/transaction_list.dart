import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theme/theme.dart';
import '../home/components/custom_drawer.dart';
import '../home/components/numberFormatter.dart';
import '../home/home_header.dart';

class MyTransactions extends StatefulWidget {
  final bool isSkyBlueTheme;
  const MyTransactions({required this.isSkyBlueTheme});

  @override
  State<MyTransactions> createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyTransactions> {
bool isLoading = false;
var transactions;
bool querySuccess = false;

@override
void initState() {
  getTrxList();
  super.initState();
}

  getTrxList() {
    setState(() {
      isLoading = false;
    });
    final _api_service = APIService();
    _api_service.checkMyTrx().then((value) {

      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          isLoading = true;
          querySuccess = true;
          if (value.dynamicList != []) {
            querySuccess = true;
            transactions = value.dynamicList;
          }
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(isSkyTheme: widget.isSkyBlueTheme,),
      backgroundColor: primaryColor,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          // HomeHeaderSectionApp(
          //   header: "Transaction History",
          //   name: '',
          // ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // SizedBox(width: 8,),
                      InkWell(onTap: (){
                        Scaffold.of(context).openDrawer();

                      },child: Icon(Icons.menu, size: 24,color: Colors.white,)),
                      Spacer(),

                      Text(
                        "Transaction History" ,
                        style: TextStyle(fontSize: 15,
                            fontFamily: "DMSans",
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child:       GestureDetector(
                          onTap: (){
                            getTrxList();
                          },
                          child: Image.asset(
                            "assets/images/refresh.png",
                            fit: BoxFit.cover,
                            width: 18,
                            color: Colors.white,
                          ),
                        ),),
                      // SizedBox(width: 4,),
                    ],
                  ))),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: primaryLightVariant,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        isLoading
                            ? querySuccess
                            ? Expanded(
                          child: TransactionsList(
                            transactions: transactions, isSkyBluTheme: widget.isSkyBlueTheme,
                          ),
                        )
                            : const EmptyUtil()
                            : Expanded(
                          child: Center(
                            child: SpinKitSpinningLines(
                              color: primaryColor,
                              duration: const Duration(milliseconds: 2000),
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

_showDialogue(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Alert",
          style: TextStyle(fontFamily: "DMSans", fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: "DMSans",
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
}

class TransactionsList extends StatelessWidget {
  final List<dynamic> transactions;
  List<Transaction> transactionList = [];
  final bool isSkyBluTheme;

  TransactionsList({required this.transactions, required this.isSkyBluTheme}) {
    addTransactions(list: transactions);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
      itemCount: transactionList.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0, ),
          child: Card(
            margin: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ImageIcon(
                          AssetImage(transactionList[index].trxType == "D" ? "assets/images/income.png":"assets/images/outcome.png" ),
                          size: 28,
                          color: transactionList[index].trxType == "C"
                              ? secondaryAccent
                              : primaryColor,
                          // color: transactionList[index].trxType == "D" ? primaryColor : secondaryAccent,// Adjust the size as needed
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
                    color: transactionList[index].trxType == "C"
                        ? secondaryAccent
                        : primaryColor,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Account',
                        style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "DMSans", color: Colors.grey,),
                      ),
                      Text(
                        transactionList[index].account,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "DMSans", color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: isSkyBluTheme ? primaryColor : secondaryAccent,),
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
                          Icon(Icons.account_balance_wallet_outlined, color: isSkyBluTheme ? primaryColor : secondaryAccent,),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.normal, fontFamily: "DMSans", color: Colors.grey),
                              ),
                              Text(
                                transactionList[index].status,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                  fontFamily: "DMSans",
                                  color: transactionList[index].status == "FAIL"
                                      ? Colors.red
                                      : Colors.green,),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                transactionList[index].trxType == "C"
                                    ? "Debit"
                                    : "Credit",
                                style: TextStyle(
                                  fontFamily: "DMSans",
                                  fontWeight: FontWeight.bold,
                                  color: isSkyBluTheme ? primaryColor : secondaryAccent,
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
  String status;
  String trxType;
  String Ref;
  String desc;
  String account;
  String beneficiary;

  Transaction({required this.date,
    required this.amount,
    required this.trxType,
    required this.status,
    required this.desc,
    required this.account,
    required this.beneficiary,
    required this.Ref});

  Transaction.fromJson(Map<String, dynamic> json)
      : date = formatDate(json["Date"]),
        amount = json["Amount"],
        desc = json["ServiceName"],
        beneficiary = json["ServiceAccountID"],
        Ref = json["MerchantRefNo"],
        trxType = json["TrxType"].trim(),
        account = json["BankAccountID"],
        status = json["Status"];

}


String formatDate(String date) {
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final outputFormat = DateFormat('EEEE, d MMMM y');

  final dateTime = inputFormat.parse(date);
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
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
