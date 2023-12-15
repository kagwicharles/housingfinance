import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _incomeController = TextEditingController();
  TextEditingController _employmentTypeController = TextEditingController();
  TextEditingController _employerNameController = TextEditingController();
  TextEditingController _placeofWorkController = TextEditingController();
  TextEditingController _natureBusinessController = TextEditingController();
  TextEditingController _periodBusinessController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Souce of Income'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              // SizedBox(height: 10,),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Annual Income'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Income Required";
                          }
                          return null;
                        },
                        controller: _incomeController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Employment Type'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Employment Type Required";
                          }
                          return null;
                        },
                        controller: _employmentTypeController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Employer Name'),
                        controller: _employerNameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Occupation'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Occupation Required";
                          }
                          return null;
                        },
                        controller: _occupationController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Place of Work'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Place of Work Required";
                          }
                          return null;
                        },
                        controller: _placeofWorkController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Nature of Business'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Nature of Business Required";
                          }
                          return null;
                        },
                        controller: _natureBusinessController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Period of Employment'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Period Required";
                          }
                          return null;
                        },
                        controller: _periodBusinessController,
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: Text('Next'))
            ]),
          ),
        ));
  }
}
