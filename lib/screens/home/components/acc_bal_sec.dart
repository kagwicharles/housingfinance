import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class AccBalance extends StatefulWidget {
  const AccBalance({super.key});

  @override
  State<AccBalance> createState() => _AccBalanceState();
}

class _AccBalanceState extends State<AccBalance> {
  final _profileRepo = ProfileRepository();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Accounts',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),
              ),
              // GestureDetector(
              //     onTap: () {
              //       getBalance();
              //     }, child: Icon(Icons.remove_red_eye_outlined)),
            ],
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   'UGX. 1,200,0000.00',
          //   style: TextStyle(
          //       fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }
  void getBalance(){
    List<BankAccount> accounts=[];
    _profileRepo.getUserBankAccounts().then((value) {
      debugPrint('Accounts>>>>>>$value');
      accounts = value;
      String account1 = accounts[0].bankAccountId;
      debugPrint('Accounts>>>>>>$account1');



      _profileRepo.checkMiniStatement(account1).then((value){
        debugPrint('balance>>>>>$value');
      });

    });
  }
}
