import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/home/headers/notifications.dart';

class HeaderSectionApp extends StatelessWidget {
  final String header;
  Color? color;
  HeaderSectionApp({super.key, required this.header});

  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.all(10),child: Container(

    // height: MediaQuery.of(context).size.height*0.24,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          // const Expanded(
          // flex: 1,
          // child: Row(
          //   // mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
           InkWell(onTap: (){
             Scaffold.of(context).openDrawer();

          },child: Icon(Icons.menu, size: 34,color: Colors.white,)),
          const SizedBox(
            width: 14,
          ),
           Text(
            header,
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          // ],

          // Expanded(
          // flex: 1,
          // child:
          Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                  onPressed: () {
                    Get.to(()=>NotificationsClass());

                  },
                  icon: const Icon(
                    Icons.notifications_sharp,
                    color: Colors.white,
                    size: 34,
                  )))
          // )
        ],
      )));
}
