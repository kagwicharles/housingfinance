import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/home/headers/notifications.dart';

class HeaderSectionApp extends StatelessWidget {
  final String header;
  Color? color;
  HeaderSectionApp({super.key, required this.header});

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment : MainAxisAlignment.spaceBetween,
        children: <Widget>[
           InkWell(onTap: (){
             // Scaffold.of(context).openDrawer();
             Navigator.of(context).pop();
          },child: Icon(Icons.arrow_back_sharp, size: 24,color: Colors.white,)),
          Spacer(),
           Text(
            header,
            style: TextStyle(fontSize: 15,
                fontFamily: "DMSans",
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8),
            child:       GestureDetector(
              onTap: (){

              },
              child: Image.asset(
                "assets/images/notification.png",
                fit: BoxFit.cover,
                width: 18,
              ),
            ),),
          // )
        ],
      )));
}
