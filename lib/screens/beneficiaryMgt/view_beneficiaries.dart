import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import '../../theme/theme.dart';
import '../home/headers/header_section.dart';

class ViewBeneficiaries extends StatefulWidget {
  final bool isSkyBlueTheme;

  const ViewBeneficiaries({required this.isSkyBlueTheme});

  @override
  State<StatefulWidget> createState() => _ViewBeneficiaryState();
}

class _ViewBeneficiaryState extends State<ViewBeneficiaries> {
  bool isLoading = false;
  var beneficiaries;
  bool querySuccess = false;

  @override
  void initState() {
    getBeneficiaries();
    super.initState();
  }

  getBeneficiaries() {
    final _api_service = APIService();
    _api_service.getBeneficiaries().then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          isLoading = true;
          if (value.dynamicList != []) {
            querySuccess = true;
            beneficiaries = value.beneficiaries;
          } else {
            querySuccess = false;
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
      backgroundColor: primaryColor,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          HeaderSectionApp(
            header: "View Beneficiaries",
          ),
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
                          child: BeneficiariesList(
                            beneficiaries: beneficiaries,
                            isSkyBlueTheme: widget.isSkyBlueTheme,
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
                setState(() {
                  isLoading = true;
                  querySuccess = false;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class BeneficiariesList extends StatefulWidget {
  final List<dynamic> beneficiaries;
  final bool isSkyBlueTheme;

  BeneficiariesList({required this.beneficiaries, required this.isSkyBlueTheme});

  @override
  _BeneficiariesListState createState() => _BeneficiariesListState();
}

class _BeneficiariesListState extends State<BeneficiariesList> {
  List<Beneficiary> beneficiariesList = [];
  bool isLoading = false;
  bool hasData = true;

  @override
  void initState() {
    super.initState();
    addBeneficiaries(list: widget.beneficiaries);
  }

  void deleteBen(String billerID, String billerName, String account, String alias) {
    final _api_service = APIService();
    _api_service.deleteBen(billerID, billerName, alias, account).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          isLoading = false;
          beneficiariesList.removeWhere((ben) =>
          ben.accountID == account &&
              ben.accountAlias == alias &&
              ben.merchantName == billerName);

          Fluttertoast.showToast(
            msg: "Beneficiary ${alias} deleted successfully",
            toastLength: Toast.LENGTH_LONG, // Duration of the toast (short or long)
            gravity: ToastGravity.BOTTOM,   // Toast position (TOP, CENTER, BOTTOM)
            timeInSecForIosWeb: 1,         // Time duration for iOS (ignored on Android)
            backgroundColor: Colors.black, // Background color of the toast
            textColor: Colors.white,       // Text color of the toast
            fontSize: 16.0,                // Font size of the message
          );

          if (beneficiariesList.isEmpty) {
            hasData = false;
          }
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error Occured! Please try again Later",
          toastLength: Toast.LENGTH_LONG, // Duration of the toast (short or long)
          gravity: ToastGravity.BOTTOM,   // Toast position (TOP, CENTER, BOTTOM)
          timeInSecForIosWeb: 1,         // Time duration for iOS (ignored on Android)
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.white,       // Text color of the toast
          fontSize: 16.0,                // Font size of the message
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
        Center(child: const SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,),)
        : hasData ?
    ListView.builder(
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
      itemCount: beneficiariesList.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
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
                          AssetImage("assets/images/dp.png"),
                          size: 28,
                          color: widget.isSkyBlueTheme ? primaryColor : secondaryAccent, // Adjust the size as needed
                        ),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          beneficiariesList[index].accountAlias,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: "DMSans",
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),),
                  Divider(color: widget.isSkyBlueTheme ? primaryColor : secondaryAccent),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Service Name',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "DMSans",
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        beneficiariesList[index].merchantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "DMSans",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Beneficiary Account',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "DMSans",
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                beneficiariesList[index].accountID,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "DMSans",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
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
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Alert",
                                              style: TextStyle(
                                                  fontFamily: "DMSans",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 18
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Icon(
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
                                          "Are you sure you want to delete beneficiary ${beneficiariesList[index].accountAlias}from ${beneficiariesList[index].merchantName} beneficiaries?",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: "DMSans",
                                              fontSize: 14
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: primaryColor,
                                                fontFamily: "DMSans",
                                                fontSize: 14),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(true); // Allow back navigation
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: APIService.appPrimaryColor, // Set the blue background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12), // Adjust the curvature of the borders
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 34.0), // Optional padding
                                          ),
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontFamily: "DMSans",
                                                fontSize: 14),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            deleteBen(
                                              beneficiariesList[index].rowID,
                                              beneficiariesList[index].merchantName,
                                              beneficiariesList[index].accountID,
                                              beneficiariesList[index].accountAlias,
                                            );
                                            Navigator.of(context)
                                                .pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                "assets/images/delete.png",
                                color: Colors.red[700],
                                fit: BoxFit.cover,
                                width: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),)
                ],
              ),
            ),
          ),
        );
      },
    ) : EmptyUtil();
  }

  void addBeneficiaries({required List<dynamic> list}) {
    setState(() {
      beneficiariesList = list.map((item) => Beneficiary.fromJson(item)).toList();
    });
  }
}


class Beneficiary {
  String merchantName;
  String rowID;
  String accountID;
  String accountAlias;

  Beneficiary({required this.merchantName,
    required this.rowID,
    required this.accountID,
    required this.accountAlias});

  Beneficiary.fromJson(Map<String, dynamic> json)
      : merchantName = json["MerchantName"],
        rowID = json["RowID"].toString(),
        accountID = json["AccountID"],
        accountAlias = json["AccountAlias"];

}

