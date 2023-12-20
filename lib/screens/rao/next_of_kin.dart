import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';

class NextOfKin extends StatefulWidget {
  const NextOfKin({super.key});

  @override
  State<NextOfKin> createState() => _NextOfKinState();
}

class _NextOfKinState extends State<NextOfKin> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _altPhoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _countyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Next of Kin'),
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
                        decoration: InputDecoration(labelText: 'Full Name'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Name Required";
                          }
                          return null;
                        },
                        controller: _emailController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Phone Required";
                          }
                          return null;
                        },
                        controller: _phoneController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Alternative Phone Number'),
                        controller: _altPhoneController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                        InputDecoration(labelText: 'Current Address'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Address Required";
                          }
                          return null;
                        },
                        controller: _addressController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration:
                        InputDecoration(labelText: 'County of Residence'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "County Required";
                          }
                          return null;
                        },
                        controller: _countyController,
                      ),
                    ],
                  )),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () {
                if(_formKey.currentState!.validate()){

                }
              }, child: Text('Next'))
            ]),
          ),
        ));
  }
}
