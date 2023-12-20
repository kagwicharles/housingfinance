import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';

import '../bridge.dart';

class Reach extends StatefulWidget {
  const Reach({super.key});

  @override
  State<Reach> createState() => _ReachState();
}

class _ReachState extends State<Reach> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _altPhoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _countyController = TextEditingController();
  String platformVersion = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('How do we reach you'),
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
                        decoration: InputDecoration(labelText: 'Email Address'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email Required";
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
                // if(_formKey.currentState!.validate()){
                  _getPlatformVersion();



                // }
              }, child: Text('Next'))
            ]),
          ),
        ));
  }
  Future<void> _getPlatformVersion() async {
    String? version;
    try {
      version = await NativeBridge.getPlatformVersion();
    } catch (e) {
      version = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      platformVersion = version!;
    });
  }
}
