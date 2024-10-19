import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/home/components/skeleton_loader.dart';

import '../../../theme/theme.dart';
import 'lastCrDrLoader.dart';
import 'mini_statement.dart';

class LastCrDrCard extends StatefulWidget {
  final bool isSkyBlueTheme;
  const LastCrDrCard({required this.isSkyBlueTheme});

  @override
  State<LastCrDrCard> createState() => _LastCrDrCardState();
}

class _LastCrDrCardState extends State<LastCrDrCard> {
  var _lastCr = "not available";
  var _lastDr = "not available";
  bool _isLoading = false;
  bool _isCrVisible = false;
  bool _isDrVisible = false;
  bool _lastCrDrFetched = false;
  var lastCrDr = "";
  bool querySuccess = false;
  final _bankAccountRepository = BankAccountRepository();
  List<BankAccount> bankAccounts = [];

  @override
  void initState() {
    fetchBankAccounts();
    super.initState();
  }

  Future<void> fetchBankAccounts() async {
    try {
      List<BankAccount>? accounts = await getBankAccounts(); // Wait for the fetch
      if (accounts != null) {
        setState(() {
          bankAccounts = accounts; // Assign the fetched accounts
        });
      }
    } catch (error) {
      // Handle errors if needed
      debugPrint("Error fetching bank accounts: $error");
    }
  }

  Future<List<BankAccount>?> getBankAccounts() => _bankAccountRepository.getAllBankAccounts();

  Future<String> fetchLastCrDrOnce() async {
    if (!_lastCrDrFetched) {
      _lastCrDrFetched = true;
      lastCrDr = await _getLastCrDr();
      setState(() {
        _isLoading = false;
        querySuccess = true;
      });
    }

    return lastCrDr;
  }

  _getLastCrDr(){
    final _api_service = APIService();
    _api_service.checkRecentCrDr()
        .then((value) {
      if (value != null) {
        if (value.status == StatusCode.success.statusCode) {

          final response = value.dynamicList;
          final amounts = response?.first["Amount"].split("|");

          _lastCr = amounts[1]; // this will be "0"
          _lastDr = amounts[3]; // this will be "2,000.00"

          setState(() {
            _isLoading = false;
          });

        } else {
          setState(() {
            _isLoading = false;
          });

          AlertUtil.showAlertDialog(
              context, value.message ?? "Error");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
      future: fetchLastCrDrOnce(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        double screenHeight = MediaQuery.of(context).size.height;
        Widget child = SizedBox(
          height: screenHeight * 0.25266,
          // height: 190,
          child: Center(child: SkeletonLoader(child: const LastCrDrLoad(),)),
        );
        if (snapshot.hasData) {
          int? count = snapshot.data?.length;
          child = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Credit Card
                      _buildCard(
                        title: 'Credit',
                        amount: _isCrVisible ? 'Ugx $_lastCr' : 'Ugx X,xxx,xxx',
                        icon: "assets/images/income.png",
                        backgroundColor: Color.fromRGBO(214, 228, 255, 1),
                        eyeIcon: _isCrVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                      SizedBox(width: 14,),
                      _buildCard(
                        title: 'Debit',
                        amount: _isDrVisible ? 'Ugx $_lastDr' : 'Ugx X,xxx,xxx',
                        icon: "assets/images/outcome.png",
                        backgroundColor: Colors.yellow[50],
                        eyeIcon: _isDrVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute( builder: (context) => Ministatement(isSkyBlueTheme: widget.isSkyBlueTheme, accounts: bankAccounts,),)
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                      color: Colors.white,
                      shadowColor: Colors.black,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        child: Row(
                          children: [
                            ImageIcon(
                              AssetImage("assets/images/ministate.png"),
                              size: 24,
                              color: primaryColor,// Adjust the size as needed
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  "View Mini-Statement ",
                                  style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  "of your account ",
                                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal, fontSize: 12),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor, size: 24,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              )
          );
        }
        return child;
      });


  // Method to build each card
  Widget _buildCard({
    required String title,
    required String amount,
    required String icon,
    required Color? backgroundColor,
    required IconData eyeIcon,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.416;
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ImageIcon(
              AssetImage(icon),
              size: 28,
              color: title == "Credit" ? primaryColor : secondaryAccent,// Adjust the size as needed
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Manrope",
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 28,),
                  GestureDetector(
                    onTap: (){
                      if (title == "Credit" ){
                        setState(() {
                          _isCrVisible = !_isCrVisible;
                        });
                      } else {
                        setState(() {
                          _isDrVisible = !_isDrVisible;
                        });
                      }
                    },
                    child: Icon(eyeIcon, color: Colors.black54),
                  )
                ],
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Manrope",
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

