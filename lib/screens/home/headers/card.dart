import 'dart:ui';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/theme/theme.dart';

class GlassmorphismCreditCard extends StatefulWidget {
  const GlassmorphismCreditCard({super.key});

  @override
  _GlassmorphismCreditCardState createState() =>
      _GlassmorphismCreditCardState();
}

class _GlassmorphismCreditCardState extends State<GlassmorphismCreditCard> {
  final bankRepo = BankAccountRepository();
  List<BankAccount> accounts = [];
  final accountRepo = ProfileRepository();
  bool isLoading = false;

  late double _height;
  late double _width;

  @override
  void initState() {
    // getAccounts();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<BankAccount>?>(
        future: bankRepo.getAllBankAccounts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BankAccount>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else {
            if (snapshot.hasData) {
              debugPrint('Accounts>>>>>>${snapshot.data}');
              accounts = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: accounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: _height * 0.5,
                        width: _width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white.withOpacity(0.2),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(accounts[index].aliasName
                                      ??
                                      'HFB Bank',
                                      style: TextStyle(fontSize: 20,
                                          color: Colors.black.withOpacity(0.75))
                                      ),
                                  const Icon(
                                    Icons.credit_card_sharp,
                                    color: primaryColor,
                                  )
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Account Number',
                                      style: TextStyle(
                                          color:
                                              Colors.black.withOpacity(0.75))),
                                  isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : Container(
                                          // height: 50,
                                          // width: 150,
                                          child: GestureDetector(onTap: () {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            checkBalance(
                                                accounts[index].bankAccountId);

                                          }, child:Text('Check Balance >',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.75)) ,)),
                                  )],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(accounts[index].bankAccountId,
                                      style: TextStyle(
                                          fontSize: 19,
                                          color:
                                              Colors.black.withOpacity(0.75))),
                                ],
                              )
                            ],
                          ),
                        ));
                  });
            } else {
              return const Text("An error occurred");
            }
          }
        });
  }

  checkBalance(String account) {
    accountRepo.checkAccountBalance(account).then((value) {
      setState(() {
        isLoading = false;
      });
      AlertUtil.showAlertDialog(
          context,
          value!.resultsData?.firstWhere((element) =>
                  element["ControlID"] == "BALTEXT")["ControlValue"] ??
              "Not available");
    });
  }
}
