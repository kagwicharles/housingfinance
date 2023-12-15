import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/advert_section.dart';
import 'package:hfbbank/screens/home/headers/drawer.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';
import 'package:hfbbank/theme/theme.dart';

class TransactionTab extends StatefulWidget {
  const TransactionTab({super.key});

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  bool _isValidated = true;
  final _moduleRepo = ModuleRepository();

  @override
  Widget build(BuildContext context) {
    var screen_size = MediaQuery.of(context).size.width<600;
    return screen_size? Scaffold(
        drawer: mainDrawer(context),
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),

          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                 HeaderSectionApp(
                  header: 'Internal Funds Transfer',
                ),
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                      color: primaryLight,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            const Text('select Account/ Card',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,
                              // margin: EdgeInsets.only( left: 20, right: 20
                              // ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownButton<String>(
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: 'account',
                                    child: Text('Primary Account'),
                                  ),
                                ],
                                onChanged: (String? selectedValue) {
                                  // Handle the dropdown value change here
                                },
                                hint: const Text('Select an Account'),
                                value: null, // Initially, no option is selected
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: primaryColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Bank',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 50,
                                // margin: EdgeInsets.only( left: 20, right: 20
                                // ),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Center(
                                    child: Text(('Housing Finance Bank')))),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Account Number',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Center(
                                        child: TextFormField(
                                      controller: null,
                                      initialValue: '12345678',
                                    ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Container(
                                      height: 50,
                                      // margin: EdgeInsets.only( left: 20, right: 20
                                      // ),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.white, width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                          child: _isValidated
                                              ? Text(('Verified'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : Text('Verify',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _isValidated
                                ? Container(
                                    height: 50,
                                    // margin: EdgeInsets.only( left: 20, right: 20
                                    // ),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          child: Icon(Icons.person_rounded),
                                          backgroundColor: primaryColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(('Ngugi Antony Nyaga'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 20,
                            ),
                            CheckboxMenuButton(
                                value: true,
                                onChanged: (value) {},
                                child: Text('Add to favorite')),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                height: 50,
                                // margin: EdgeInsets.only( left: 20, right: 20
                                // ),
                                width: MediaQuery.of(context).size.width,
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   border: Border.all(
                                //       color: Colors.white, width: 1.0),
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Next',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
              ]))
          // child:
        ]))): Container(child: Text('Large Sreen'),);

    // );
    // );
  }
}
