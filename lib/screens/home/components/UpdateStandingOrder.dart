import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/home/components/success_view.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../theme/theme.dart';


class UpdateStandingOrder extends StatefulWidget {
  final String dbAcc, crAcc, amount, siid, noOfEx, firstEx, trFrqID, lastEx,nextEx, regEx;

  UpdateStandingOrder({
    required this.dbAcc,
    required this.crAcc,
    required this.amount,
    required this.siid,
    required this.noOfEx,
    required this.firstEx,
    required this.trFrqID,
    required this.lastEx,
    required this.nextEx,
  required this.regEx});

  @override
  State<UpdateStandingOrder> createState() => _UpdateStandingOrderState();
}

class _UpdateStandingOrderState extends State<UpdateStandingOrder> {
  TextEditingController frequencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController nextExController = TextEditingController();
  TextEditingController dbAccController = TextEditingController();
  TextEditingController crAccController = TextEditingController();
  final _pinController = TextEditingController();
  final _bankRepository = BankAccountRepository();
  late Future<List<BankAccount>?> bankAccountsFuture;
  bool isSubmitting = false;
  bool isObscured = true;

  @override
  void initState() {
    bankAccountsFuture = _bankRepository.getAllBankAccounts();
    frequencyController.text = widget.trFrqID;
    amountController.text = widget.amount;
    nextExController.text = widget.nextEx;
    dbAccController.text = widget.dbAcc;
    crAccController.text = widget.crAcc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
        inAsyncCall: isSubmitting, // Set this variable to true when you want to show the loading indicator
        opacity: 0.5, // Customize the opacity of the background when the loading indicator is displayed
        progressIndicator: LoadUtil(),
    child:ListView(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    //set border radius more than 50% of height and width to make circle
                  ),
                  color: primaryColor,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Image(
                            image: AssetImage("assets/images/back_arrow.png"),
                            width: 25,
                          ),
                        ),
                        const Expanded(
                            child: Text(
                              "Update Standing Order",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Manrope",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(width: 25),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
                height: 600,
                color: const Color.fromARGB(255, 219, 220, 221),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 4,
                        surfaceTintColor: Colors.white,
                        margin: const EdgeInsets.only(top: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.only(top: 16, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.zero
                                  ),
                                  child:
                                  TextFormField(
                                    enabled: false,
                                    controller: dbAccController,
                                    onChanged: (value) {
                                      setState(() {
                                        // widget.customerData.lastName = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Debit Account'",
                                      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 80, 170), fontFamily: "Manrope"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintText: 'Debit Account',
                                      hintStyle: TextStyle(
                                          fontFamily: "Manrope", fontSize: 12, color: Colors.grey),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    // onChanged and initialValue can be added as needed
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.only(top: 16, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.zero
                                  ),
                                  child: TextFormField(
                                    enabled: false,
                                    controller: crAccController,
                                    onChanged: (value) {
                                      setState(() {
                                        // widget.customerData.lastName = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Credit Account",
                                      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 80, 170), fontFamily: "Manrope"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintText: 'Credit Account',
                                      hintStyle: TextStyle(
                                          fontFamily: "Manrope", fontSize: 12, color: Colors.grey),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    // onChanged and initialValue can be added as needed
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.only(top: 16, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.zero
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: frequencyController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        frequencyController.text = value!;
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'D',
                                        child: Text('Daily'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'W',
                                        child: Text('Weekly'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'F',
                                        child: Text('Fortnightly'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'M',
                                        child: Text('Monthly'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Q',
                                        child: Text('Quarterly'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'H',
                                        child: Text('Half Yearly'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Y',
                                        child: Text('Yearly'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'O',
                                        child: Text('One Time'),
                                      ),
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: "PIN",
                                      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 80, 170), fontFamily: "Manrope"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintText: 'Frequency',
                                      hintStyle: TextStyle(
                                        fontFamily: "Manrope",
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.only(top: 16, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.zero
                                  ),
                                  child:
                                  TextFormField(
                                    enabled: true,
                                    controller: amountController,
                                    onChanged: (value) {
                                      setState(() {
                                        amountController.text = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Amount",
                                      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 80, 170), fontFamily: "Manrope"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintText: 'Amount',
                                      hintStyle: TextStyle(
                                          fontFamily: "Manrope", fontSize: 12, color: Colors.grey),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(color: Colors.white)),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    // onChanged and initialValue can be added as needed
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.only(top: 16, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.zero
                                  ),
                                  child: WidgetFactory.buildTextField(
                                    context,
                                    TextFormFieldProperties(
                                      isEnabled: true,
                                      isObscured: isObscured,
                                      controller: _pinController,
                                      textInputType: TextInputType.number,
                                      inputDecoration: InputDecoration(
                                        labelText: "PIN",
                                        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 80, 170), fontFamily: "Manrope"),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        hintText: "Enter PIN",
                                        suffixIconColor: primaryColor,
                                        suffixIcon: IconButton(
                                          icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              isObscured = !isObscured;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                        (value) {
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                WidgetFactory.buildButton(context, () {
                                  if (_pinController.text.length < 4) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Alert",
                                            style: TextStyle(
                                                fontFamily: "Manrope", fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                            "Please enter a valid pin",
                                            style: TextStyle(
                                              fontFamily: "Manrope",
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
                                  }else{
                                    setState(() {
                                      isSubmitting = true;
                                    });
                                    _updateSO(widget.siid, widget.noOfEx, widget.firstEx,
                                        frequencyController.text, widget.lastEx, widget.nextEx,
                                        widget.regEx, widget.dbAcc, widget.crAcc, amountController.text);
                                  }
                                }, "Update Standing Order",
                                    color: const Color.fromRGBO(129, 190, 65, 1)),
                                SizedBox(
                                  height: 20,
                                )
                              ]
                          ),
                        ),
                      ),
                    ),
                ))
          ],
        )
        )
    );
  }


  _updateSO(String siid,
      String noOfEx,
      String firstEx,
      String trFrqID,
      String lastEx,
      String nextEx,
      String regEx,
      String drAcc,
      String crAcc,
      String amount){
    final _api_service = APIService();
    _api_service.updateStandingOrder(siid, noOfEx, _formatDate(firstEx), trFrqID, _formatDate(lastEx),
      _formatDate(nextEx), regEx, drAcc, crAcc, amount, CryptLib.encryptField(_pinController.text)).then((value) {
      if (value.status == StatusCode.success.statusCode) {

        setState(() {
          isSubmitting = false;
        });
        CommonUtils.navigateToRoute(
            context: context, widget: SuccessView(message: value.message.toString(), isSkyBlueTheme: true,));
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Manrope", fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Failed to update your Standing order Please try again later",
                style: TextStyle(
                  fontFamily: "Manrope",
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
                      isSubmitting = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
  
  _formatDate(String date){
    DateFormat originalFormat = DateFormat("dd/MM/yyyy");
    DateTime parsedDate = originalFormat.parse(date);

    // Format the parsed date into the desired format
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = newFormat.format(parsedDate);
    
    return formattedDate;
  }
}
