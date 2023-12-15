import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';

import '../../../theme/theme.dart';

class Ministatement extends StatefulWidget {
  const Ministatement({Key? key}) : super(key: key);

  @override
  State<Ministatement> createState() => _MinistatementState();
}

class _MinistatementState extends State<Ministatement> {
  final _bankAccountRepository = BankAccountRepository();
  final _profileRepository = ProfileRepository();
  bool _isLoading = false;
  List<bool> booleans = [];

  getMiniStatement(String account, index) async {
    await _profileRepository
        .checkMiniStatement(account, merchantID: "STATEMENT")
        .then((value) {
      setState(() {
        booleans[index] = false;
      });
      debugPrint('ministmst${value?.dynamicList}');
      if (value?.status == StatusCode.success.statusCode) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) =>
                Statement(ministatement: value?.dynamicList))));
      } else {
        AlertUtil.showAlertDialog(context, value?.message ?? "Error");
      }
    });
  }

  @override
  void initState() {
    // getMiniStatement(account, index)
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              HeaderSectionApp(header: 'Ministatement'),
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  child: Container(
                    color: primaryLight,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<List<BankAccount>?>(
                        future: _bankAccountRepository.getAllBankAccounts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<BankAccount>?> snapshot) {
                          debugPrint('snapbank...${snapshot.data}');

                          if (snapshot.hasData) {
                            var statement = snapshot.data ?? [];
                            statement.asMap().forEach((index, account) {
                              booleans.add(false);
                            });
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 10,
                                          left: 8,
                                          right: 8,
                                        ),
                                        height: 50,
                                        // width: 350,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,

                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                height: 60,
                                                // width: 120,
                                                margin: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/hfb_logo.png'),
                                                    Text(
                                                        '  ${snapshot.data?[index].aliasName}',
                                                        // '${snapshot.data?[index].bankAccountId}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ],
                                                )),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 8, left: 8, right: 8),
                                              // width: 60,
                                              // height: 40,
                                              child: Row(
                                                children: [
                                                  booleans[index]
                                                      ? const SpinKitCircle(
                                                          color: primaryColor,
                                                        )
                                                      : InkWell(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                                    // topRight: Radius.circular(30),
                                                                    // bottomRight: Radius.circular(30)
                                                                    ),
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                width: 124,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(
                                                                                30)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .orange)),
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  'Check Statement',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .orange,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                )),
                                                          ),
                                                          onTap: () {
                                                            AlertUtil.showAlertDialog(
                                                                    context,
                                                                    "Continue to view MiniStatement?",
                                                                    isConfirm:
                                                                        true)
                                                                .then((value) {
                                                              if (value) {
                                                                setState(() {
                                                                  booleans[
                                                                          index] =
                                                                      true;
                                                                });
                                                                getMiniStatement(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .bankAccountId,
                                                                    index);
                                                              }
                                                            });
                                                          })
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Divider(),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return LoadUtil();
                          }
                        }),
                    // ListView(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   children: [
                    //     Container(
                    //       child: Column(
                    //         children: [
                    //           Container(
                    //             margin: const EdgeInsets.only(
                    //               top: 10,
                    //               left: 8,
                    //               right: 8,
                    //             ),
                    //             height: 50,
                    //             // width: 350,
                    //             width: MediaQuery.of(context)
                    //                     .size
                    //                     .width *
                    //                 0.85,
                    //
                    //             child: Row(
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.start,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Container(
                    //                     height: 60,
                    //                     // width: 120,
                    //                     margin: const EdgeInsets.only(
                    //                         left: 8),
                    //                     child: Row(
                    //                       children: [
                    //                         Image.asset(
                    //                             'assets/images/db_.png'),
                    //                         Text(
                    //                           'Current Account',
                    //                           style: GoogleFonts.inter(
                    //                               textStyle: const TextStyle(
                    //                                   color: Colors
                    //                                       .black45,
                    //                                   fontSize: 14,
                    //                                   fontWeight:
                    //                                       FontWeight
                    //                                           .w400)),
                    //                         )
                    //                       ],
                    //                     )),
                    //                 Container(
                    //                   margin: const EdgeInsets.only(
                    //                       top: 8, left: 8, right: 8),
                    //                   // width: 60,
                    //                   // height: 40,
                    //                   child: Row(
                    //                     children: [
                    //                       ClipRRect(
                    //                         borderRadius:
                    //                             const BorderRadius
                    //                                 .only(),
                    //                         child: Container(
                    //                           alignment:
                    //                               Alignment.center,
                    //                           width: 68,
                    //                           height: 40,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius: const BorderRadius
                    //                                       .only(
                    //                                   topLeft: Radius
                    //                                       .circular(
                    //                                           30),
                    //                                   bottomLeft: Radius
                    //                                       .circular(
                    //                                           30)),
                    //                               border: Border.all(
                    //                                   color: Colors
                    //                                       .green)),
                    //                           child: Text(
                    //                             textAlign:
                    //                                 TextAlign.center,
                    //                             'Statement',
                    //                             style: GoogleFonts.inter(
                    //                                 textStyle: const TextStyle(
                    //                                     color: Colors
                    //                                         .green,
                    //                                     fontSize: 10,
                    //                                     fontWeight:
                    //                                         FontWeight
                    //                                             .w300)),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       ClipRRect(
                    //                         borderRadius: const BorderRadius
                    //                                 .only(
                    //                             // topRight: Radius.circular(30),
                    //                             // bottomRight: Radius.circular(30)
                    //                             ),
                    //                         child: Container(
                    //                           alignment:
                    //                               Alignment.center,
                    //                           padding:
                    //                               const EdgeInsets
                    //                                       .only(
                    //                                   right: 10),
                    //                           width: 68,
                    //                           height: 40,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius: const BorderRadius
                    //                                       .only(
                    //                                   topRight: Radius
                    //                                       .circular(
                    //                                           30),
                    //                                   bottomRight: Radius
                    //                                       .circular(
                    //                                           30)),
                    //                               border: Border.all(
                    //                                   color: Colors
                    //                                       .orange)),
                    //                           child: Text(
                    //                             textAlign:
                    //                                 TextAlign.center,
                    //                             'Balance',
                    //                             style: GoogleFonts.inter(
                    //                                 textStyle: const TextStyle(
                    //                                     color: Colors
                    //                                         .orange,
                    //                                     fontSize: 10,
                    //                                     fontWeight:
                    //                                         FontWeight
                    //                                             .w300)),
                    //                           ),
                    //                         ),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Divider(),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Align(
                    //     alignment: Alignment.bottomRight,
                    //     child: InkWell(
                    //       onTap: null,
                    //       child: Container(
                    //         margin: EdgeInsets.only(
                    //           bottom: 9,
                    //         ),
                    //         child: Text(
                    //           'View All Accounts   ',
                    //           style: GoogleFonts.inter(
                    //               textStyle: const TextStyle(
                    //                   color: Colors.black,
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w600)),
                    //         ),
                    //       ),
                    //     ))
                  ))
            ],
          ),
        ));
  }
}

class Statement extends StatefulWidget {
  List<dynamic>? ministatement;

  Statement({required this.ministatement, super.key});

  @override
  State<StatefulWidget> createState() => _Statement();
}

class _Statement extends State<Statement> {
  List<Transaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    addTransactions(list: widget.ministatement);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('listmini${widget.ministatement}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text("Ministatement"),
      ),
      body: ListView.separated(
        itemCount: transactionList.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Transaction date"),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        transactionList[index].date,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Amount"),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(transactionList[index].amount,
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  )
                ],
              ));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  addTransactions({required list}) {
    list?.forEach((item) {
      transactionList.add(Transaction.fromJson(item));
    });
  }
}

class Transaction {
  String date;
  String amount;

  Transaction({required this.date, required this.amount});

  Transaction.fromJson(Map<String, dynamic> json)
      : date = json["Date"],
        amount = json["Amount"];
}
