import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class TypeProducts extends StatefulWidget {
  const TypeProducts({super.key});

  @override
  State<TypeProducts> createState() => _TypeProductsState();
}

class _TypeProductsState extends State<TypeProducts> {
  List<DropdownMenuItem<String>> branches = [
    DropdownMenuItem(value: "", child: Text('data'))
  ];
  List<DropdownMenuItem<String>> currency = [
    DropdownMenuItem(value: "", child: Text('data'))
  ];
  List<DropdownMenuItem<String>> accountType = [
    DropdownMenuItem(value: "", child: Text('data'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Products'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                // height: 60,
                // margin: EdgeInsets.only( left: 20, right: 20
                // ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  items: accountType,
                  onChanged: (String? selectedValue) {
                    // Handle the dropdown value change here
                  },
                  hint: const Text('Select Account Type'),
                  value: null, // Initially, no option is selected
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // height: 60,
                // margin: EdgeInsets.only( left: 20, right: 20
                // ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  items: branches,
                  onChanged: (String? selectedValue) {
                    // Handle the dropdown value change here
                  },
                  hint: const Text('Select Branch'),
                  value: null, // Initially, no option is selected
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // height: 60,
                // margin: EdgeInsets.only( left: 20, right: 20
                // ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  items: currency,
                  onChanged: (String? selectedValue) {
                    // Handle the dropdown value change here
                  },
                  hint: const Text('Select Currency'),
                  value: null, // Initially, no option is selected
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {}
                  },
                  child: Text('Next'))
            ],
          ),
        ),
      ),
    );
  }
}
