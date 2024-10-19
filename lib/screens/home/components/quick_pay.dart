import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/home/components/quick_pay_completion.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../theme/theme.dart';
import '../headers/header_section.dart';
import '../home_screen.dart';
import 'numberFormatter.dart';

class QuickPay extends StatefulWidget {
  final bool isSkyBlueTheme;
  const QuickPay({Key? key, required this.isSkyBlueTheme}) : super(key: key);

  @override
  State<QuickPay> createState() => _QuickPayState();
}

class _QuickPayState extends State<QuickPay> {
  bool isLoading = true;
  bool itemSelected = false;
  TrxDetails? selectedTrxType;
  List<TrxDetails> trxDetails = [];

  @override
  void initState() {
    getQuickPayTrx();
    super.initState();
  }

  getQuickPayTrx() {
    final _api_service = APIService();
    _api_service.getQuickPayTrx().then((value) {
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          trxDetails = value.dynamicList!.map((item) => TrxDetails.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Alert",
                style: TextStyle(fontFamily: "Manrope", fontWeight: FontWeight.bold),
              ),
              content: Text(
                value.message.toString(),
                style: TextStyle(fontFamily: "Manrope"),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme,)));
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.5,
        progressIndicator: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 30,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            HeaderSectionApp(header: 'Favorites'),
            Expanded(child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                child: Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
                    width: MediaQuery.of(context).size.width,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Choose service",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<TrxDetails>(
                              iconEnabledColor: primaryColor,
                              style: const TextStyle(
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                  hintText: "Select Bundle Validity"
                              ),
                              hint: const Text(
                                'Select an option',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              borderRadius: BorderRadius.zero,
                              value: selectedTrxType,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedTrxType = newValue!;
                                  itemSelected = true;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                              items: trxDetails
                                  .map((trx) => trx.TypeOfMerchant) // Extract TypeOfMerchant strings
                                  .toSet() // Convert to a set to remove duplicates
                                  .map((typeOfMerchant) {
                                return DropdownMenuItem<TrxDetails>(
                                  value: trxDetails
                                      .firstWhere((trx) => trx.TypeOfMerchant == typeOfMerchant),
                                  child: Text(
                                    typeOfMerchant,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: primaryColor,
                                      fontFamily: "Manrope",
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),),
                        const SizedBox(height: 16),
                        itemSelected
                            ? Padding(padding: EdgeInsets.only(bottom: 16, left: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Favorite ${selectedTrxType?.TypeOfMerchant.toString().capitalizeFirstLetter()} Transactions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Manrope",
                                  fontSize: 14),
                            ),
                          ),) : Container(),
                        itemSelected
                            ? Expanded(child: Container(
                          color: Colors.grey[200],
                          child: TrxList(
                            trxList: trxDetails,
                            selectedTypeOfMerchant: selectedTrxType?.TypeOfMerchant ?? '',
                            isSkyBlueTheme: widget.isSkyBlueTheme,
                          ),
                        )) :
                        Expanded(child: Container(color: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,))
                      ],
                    )))),
    // Expanded(child: Container(
    //           height: 600,
    //           color: const Color.fromARGB(255, 219, 220, 221),
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 20),
    //             child: ,
    //           ),
    //         ))
          ],
        ),
      ),
    );
  }
}

class TrxList extends StatelessWidget {
  final List<TrxDetails> trxList;
  final String selectedTypeOfMerchant;
  final bool isSkyBlueTheme;

  TrxList({required this.trxList, required this.selectedTypeOfMerchant, required this.isSkyBlueTheme});

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedTypeOfMerchant.isEmpty
        ? trxList
        : trxList.where((trx) => trx.TypeOfMerchant == selectedTypeOfMerchant).toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Card(
            margin: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            elevation: 2,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Padding(padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Image.asset("assets/images/Favorites.png",
                      height: 20,),
                      SizedBox(width: 8,),
                      Text(
                        "${filteredList[index].MerchantName} - ${filteredList[index].Beneficiary}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Manrope",
                          color: primaryColor,
                        ),
                      ),
                    ],
                  )),
                Divider(
                  color: isSkyBlueTheme ? primaryColor : secondaryAccent,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Manrope",
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                formatAmount(filteredList[index].Amount.toString()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Manrope",
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              CommonUtils.navigateToRoute(
                                context: context,
                                widget: QuickPayTrxCompletion(
                                  TypeOfMerchant: trxList[index].TypeOfMerchant,
                                  MerchantName: trxList[index].MerchantName,
                                  Beneficiary: trxList[index].Beneficiary,
                                  TrxDate: trxList[index].TrxDate,
                                  merchantID: trxList[index].merchantID,
                                  moduleID: trxList[index].moduleID,
                                  INFOFIELD1: trxList[index].INFOFIELD1,
                                  INFOFIELD2: trxList[index].INFOFIELD2,
                                  INFOFIELD3: trxList[index].INFOFIELD3,
                                  INFOFIELD4: trxList[index].INFOFIELD4,
                                  INFOFIELD6: trxList[index].INFOFIELD6,
                                  INFOFIELD7: trxList[index].INFOFIELD7,
                                  INFOFIELD9: trxList[index].INFOFIELD9,
                                  Amount: trxList[index].Amount,
                                  isSkyBlueTheme: isSkyBlueTheme,
                                ),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: primaryColor),
                                width: 110,
                                height: 42,
                                child: const Center(
                                  child: Text('Pay',
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
                      ),
                      SizedBox(height: 8,)
                    ],
                  ),)
              ],
            ),)
          ),
        );
      },
    );
  }
}


class TrxDetails {
  final String moduleID;
  final String merchantID;
  final String TypeOfMerchant;
  final String MerchantName;
  final String Beneficiary;
  final String TrxDate;
  final int Amount;
  final String INFOFIELD1;
  final String INFOFIELD2;
  final String INFOFIELD3;
  final String INFOFIELD4;
  final String INFOFIELD6;
  final String INFOFIELD7;
  final String INFOFIELD9;

  TrxDetails({
    required this.moduleID,
    required this.merchantID,
    required this.TypeOfMerchant,
    required this.MerchantName,
    required this.Beneficiary,
    required this.TrxDate,
    required this.Amount,
    required this.INFOFIELD1,
    required this.INFOFIELD2,
    required this.INFOFIELD3,
    required this.INFOFIELD4,
    required this.INFOFIELD6,
    required this.INFOFIELD7,
    required this.INFOFIELD9,
  });

  factory TrxDetails.fromJson(Map<String, dynamic> json) {
    return TrxDetails(
      moduleID: json['ModuleID'],
      merchantID: json['MerchantID'],
      TypeOfMerchant: json['TypeOfMerchant'],
      MerchantName: json['MerchantName'],
      Beneficiary: json['Beneficiary'],
      TrxDate: json['TrxDate'],
      Amount: json['Amount'],
      INFOFIELD1: json['INFOFIELD1'],
      INFOFIELD2: json['INFOFIELD2'],
      INFOFIELD3: json['INFOFIELD3'],
      INFOFIELD4: json['INFOFIELD4'],
      INFOFIELD6: json['INFOFIELD6'],
      INFOFIELD7: json['INFOFIELD7'],
      INFOFIELD9: json['INFOFIELD9'],
    );
  }
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
