import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/headers/header_section.dart';

class IdentificationDocuments extends StatefulWidget {
  const IdentificationDocuments({super.key});

  @override
  State<IdentificationDocuments> createState() =>
      _IdentificationDocumentsState();
}

class _IdentificationDocumentsState extends State<IdentificationDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Identification Documents'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: []),
        ));
  }
}
