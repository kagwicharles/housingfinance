import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';
import 'package:hfbbank/theme/theme.dart';

import '../headers/drawer.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  final _bankAccountRepository = BankAccountRepository();
  final _profileRepository = ProfileRepository();
  var balance;
  bool _isLoading = false;
  List<bool> booleans = [];

  getBalance(String account, index) async {
    await _profileRepository.checkMiniStatement(account).then((value) {
      balance = _profileRepository.getActualBalanceText(value!);
      booleans[index] = false;
      // debugPrint('balance is $balance');
      setState(() {
        // balance = value;
      });
    });
    await AlertUtil.showAlertDialog(context, 'Your Balance is $balance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: mainDrawer(context),
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
               HeaderSectionApp(
                header: 'My Accounts',
              ),
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
                          snapshot.data?.asMap().forEach((element, index) {
                            booleans.add(false);
                          });
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: ListView.builder(
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                          '  ${snapshot.data?[index].bankAccountId}',
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black45,
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
                                                        ? const CircularProgressIndicator(
                                                            color: primaryColor)
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
                                                                width: 100,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            30)),
                                                                    border: Border.all(
                                                                        color:
                                                                            primaryColor)),
                                                                child: const Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    'Check Balance',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .orange,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w300)),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              AlertUtil.showAlertDialog(
                                                                      context,
                                                                      "Continue to view account Ministatement?",
                                                                      isConfirm:
                                                                          true)
                                                                  .then(
                                                                      (value) {
                                                                if (value) {
                                                                  setState(() {
                                                                    booleans[
                                                                            index] =
                                                                        true;
                                                                    // value = balance;
                                                                  });
                                                                  getBalance(
                                                                          snapshot
                                                                              .data![index]
                                                                              .bankAccountId,
                                                                          index)
                                                                      .then((value) {});
                                                                }
                                                              });
                                                            })
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: primaryColor,
                          ));
                        }
                      }),
                ),
              ),
            ],
          ),
        ));
  }

  void checkMiniStatement() {}
}
