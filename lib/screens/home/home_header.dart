import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/home/headers/notifications.dart';

class HomeHeaderSectionApp extends StatelessWidget {
  final String header;
  final String name;
  Color? color;
  HomeHeaderSectionApp({super.key
    , required this.header
    , required this.name});

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // SizedBox(width: 8,),
          InkWell(onTap: (){
            Scaffold.of(context).openDrawer();

          },child: Icon(Icons.menu, size: 24,color: Colors.white,)),
          Spacer(),
          name == ''?
          Text(
            "$header" ,
            style: TextStyle(fontSize: 15,
                fontFamily: "DMSans",
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ) :
          Text(
            "$header, $name" ,
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
          // SizedBox(width: 4,),
        ],
      )));
}
