import 'dart:ui';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/home/components/numberFormatter.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccBalance extends StatefulWidget {
  const AccBalance({super.key});

  @override
  State<AccBalance> createState() => _AccBalanceState();
}

class _AccBalanceState extends State<AccBalance> {
  final _profileRepo = ProfileRepository();
  bool _accountVisible = false;
  final _bankRepository = BankAccountRepository();
  List<BankAccount> bankAccounts = [];
  int selectedIndex = 0;
  var _currentValue;
  String bal = "";
  String balance = "";
  String lastCheckDate = "";
  bool _isLoading = true;
  bool _balanceFetched = false;
  bool querySuccess = false;
  bool isListViewVisible = false;

  late Future<List<BankAccount>?> _futureBankAccounts;

  Future<List<BankAccount>?> getBankAccounts() => _bankRepository.getAllBankAccounts();

  @override
  void initState() {
    super.initState();
    _futureBankAccounts = getBankAccounts();
    _loadPreferences();
  }

  Future<String> fetchBalanceOnce(String accountId) async {
    if (!_balanceFetched) {
      _balanceFetched = true;
      // Call your balance method
      balance = await getBalance(accountId);
      setState(() {
        _isLoading = false;
        querySuccess = true;
      });
    }

    return balance;
  }

  // Load the saved booleans from shared preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accountVisible = prefs.getBool('accountVisible') ?? false;  // Default to false if not found
      isListViewVisible = prefs.getBool('isListViewVisible') ?? false;
    });
  }

  // Save the booleans to shared preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('accountVisible', _accountVisible);
    await prefs.setBool('isListViewVisible', isListViewVisible);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BankAccount>?>(
      future: _futureBankAccounts, // Future called once
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching accounts"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No accounts found"));
        } else {
          bankAccounts = snapshot.data!;
          fetchBalanceOnce(bankAccounts.first.bankAccountId);
          return Container(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 26),
                    const Text(
                      "Total Account Balance",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Manrope",
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _accountVisible = !_accountVisible;
                        });
                      },
                      child: Icon(
                        _accountVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 50,
                    padding: const EdgeInsets.only(left: 34),
                    child: const SpinKitSpinningLines(
                      color: primaryColor,
                      duration: Duration(milliseconds: 2000),
                      size: 30,
                    ),
                  ),
                )
                    : querySuccess
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 26),
                    Text(
                      _accountVisible ? balance : "UGX XXX,XXX,XXX",
                      style: const TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 26),
                    Text(
                      "UGX XXX,XXX,XXX",
                      style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                querySuccess
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 26),
                    Text(
                      _accountVisible ? "Last Checked: $lastCheckDate" : "",
                      style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16),
                isListViewVisible ? _buildListView(context) : _buildHorizontalScrollView(context),
                const SizedBox(height: 16),
              ],
            ),
          );
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<List<BankAccount>?>(
  //     future: getBankAccounts(), // Fetch bank accounts
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         // While the future is being fetched, show a loading indicator
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         // If there’s an error, display an error message
  //         return const Center(child: Text("Error fetching accounts"));
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         // If no data or empty list, display a message
  //         return const Center(child: Text("No accounts found"));
  //       } else {
  //         // Once accounts are fetched, display the balance
  //         bankAccounts = snapshot.data!;
  //         fetchBalanceOnce(bankAccounts[0].bankAccountId);
  //         // getBalance(bankAccounts[0].bankAccountId);
  //         return Container(
  //           padding: EdgeInsets.zero,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 8),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(width: 26),
  //                   const Text(
  //                     "Total Account Balance",
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontFamily: "Manrope",
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   GestureDetector(
  //                     onTap: (){
  //                       setState(() {
  //                         toggleAccountVisible();
  //                       });
  //                     },
  //                     child: Icon(
  //                       _accountVisible
  //                           ? Icons.visibility_outlined
  //                           : Icons.visibility_off_outlined,
  //                       color: primaryColor,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               _isLoading ? Align(
  //                   alignment: Alignment.centerLeft,
  //                   child:  Container(
  //                     width: 50,
  //                     padding: EdgeInsets.only(left: 34),
  //                     child: const SpinKitSpinningLines(color: primaryColor,
  //                       duration: Duration(milliseconds: 2000),
  //                       size: 30,),
  //                   )
  //               ) : querySuccess ?
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(width: 26),
  //                   Text(
  //                     _accountVisible ? balance : "UGX XXX,XXX,XXX",
  //                     style: const TextStyle( fontFamily: "Manrope",
  //                         fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  //                   )
  //                 ],
  //               ) : const Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(width: 26),
  //                   Text(
  //                     "UGX XXX,XXX,XXX",
  //                     style: TextStyle(fontFamily: "Manrope",
  //                         fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  //                   )
  //                 ],
  //               ),
  //               querySuccess ?
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(width: 26),
  //                   Text(
  //                     _accountVisible ? "Last Checked: $lastCheckDate" : "",
  //                     style: TextStyle(fontFamily: "Manrope",
  //                         fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[600]),
  //                   ),
  //                 ],
  //               ) : SizedBox(height: 0,),
  //               const SizedBox(height: 16),
  //               isListViewVisible ? _buildListView(context) : _buildHorizontalScrollView(context),
  //               const SizedBox(height: 16),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // Method to show horizontal scroll view (like a tab)
  Widget _buildHorizontalScrollView(BuildContext context) {
    return Container(
      height: 60, // Height for the strip
      color: Colors.grey[200], // Background color of the strip
      child: Row(
        children: [
          Expanded(child: ListView.builder(
            scrollDirection: Axis.horizontal, // Horizontal scroll
            itemCount: bankAccounts.length, // Add an extra item for the tab (instead of calendar icon)
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 18),
                child: selectedIndex == index ?
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedIndex = index;
                          getBalance(bankAccounts[index].bankAccountId);
                          _isLoading = true;
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          //set border radius more than 50% of height and width to make circle
                        ),
                        elevation: 2,
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          child: Center(
                            child: Text(
                              bankAccounts[index].bankAccountId, // Display account name
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                ) :
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                      getBalance(bankAccounts[index].bankAccountId);
                      _isLoading = true;
                    });
                  },
                  child: Container(
                    padding: index == 0 ? EdgeInsets.only(left: 10) : EdgeInsets.only(left: 0),
                    child: Center(
                      child: Text(
                        bankAccounts[index].bankAccountId,
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                )
              );
            },
          ),),
          GestureDetector(
            onTap: (){
                    setState(() {
                      // isListViewVisible = true;
                      toggleListViewVisible();// Switch to list view on tap
                    });
            },
            child: Image.asset(
              "assets/images/list.png",
              fit: BoxFit.cover,
              width: 28,
              color: primaryColor,
            ),
          ),
          SizedBox(width: 24,)
        ],
      )
    );
  }

  // Method to show ListView (as a dropdown)
  Widget _buildListView(BuildContext context) {
    var dropdownPicks = bankAccounts
        .fold<Map<String, dynamic>>(
        {},
            (acc, curr) => acc
          ..[curr.bankAccountId] = curr.bankAccountId)
        .entries
        .map((item) => DropdownMenuItem(
      value: item.key,
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet_outlined,
      color: primaryColor),
          SizedBox(width: 20,),
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontFamily: "DMSans",
            ),
          )
        ],
      ),
    ))
        .toList();
    dropdownPicks.toSet().toList();
    if (dropdownPicks.isNotEmpty) {
      _currentValue = dropdownPicks[0].value;
    }
    return Container(
      height: 60, // Set height for dropdown list
      color: Colors.grey[200], // Background color for the list
      child: Row(
        children: [
          Expanded(child: Container(
            margin: EdgeInsets.only(left: 14, top: 6, bottom: 6, right: 95),
              padding: EdgeInsets.only(left: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 2,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black,
              child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.zero),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0)
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
                    querySuccess = false;
                    _currentValue = value.toString();
                    getBalance(_currentValue);


                    setState(() {
                      _isLoading = true;
                    });
                    // account = _currentValue;
                  }),
            )
          ),),
          GestureDetector(
            onTap: (){
              setState(() {
                // isListViewVisible = false;
                toggleListViewVisible();
              });
            },
            child: Image.asset(
              "assets/images/tab.png",
              fit: BoxFit.cover,
              width: 18,
              color: primaryColor,
            ),
          ),
          SizedBox(width: 30,)
        ],
      ),
    );
  }

  // void getAccounts(){
  //   List<BankAccount> accounts=[];
  //   _profileRepo.getUserBankAccounts().then((value) {
  //     debugPrint('Accounts>>>>>>$value');
  //     accounts = value;
  //     String account1 = accounts[0].bankAccountId;
  //     debugPrint('Accounts>>>>>>$account1');
  //
  //
  //     // _profileRepo.checkMiniStatement(account1).then((value){
  //     //   debugPrint('balance>>>>>$value');
  //     // });
  //
  //   });
  // }

  getBalance(String account){
      _profileRepo.checkAccountBalance(account).then((value){
        setState(() {
          _isLoading = true;
        });
        if (value != null) {
          if (value.status ==
              StatusCode.success.statusCode) {
            bal = value.resultsData?.firstWhere((e) =>
            e["ControlID"] ==
                "BALTEXT")["ControlValue"] ??
                "Not available";

            setState(() {
              String formatedBal = formatCurrency(removeDecimalPointAndZeroes(bal));
              String wholeBal = formatedBal.split('.')[0];
              balance = "UGX $wholeBal";
            });

            lastCheckDate = value.resultsData?.firstWhere((e) =>
            e["ControlID"] ==
                "BALFOOTER")["ControlValue"] ??
                "Not available";

            setState(() {
              querySuccess = true;
              _isLoading = false;
            });

          } else {
            setState(() {
              querySuccess = false;
              _isLoading = false;
            });
            AlertUtil.showAlertDialog(
                context, value.message ?? "Error");
          }
        }
      });
    }

  String removeDecimalPointAndZeroes(String value) {
    double parsedValue = double.tryParse(value) ?? 0.0;
    return parsedValue.toInt().toString();
  }

  void toggleAccountVisible() {
    setState(() {
      _accountVisible = !_accountVisible;
    });
    _savePreferences();  // Save the updated value
  }

  void toggleListViewVisible() {
    setState(() {
      isListViewVisible = !isListViewVisible;
    });
    _savePreferences();  // Save the updated value
  }
}
