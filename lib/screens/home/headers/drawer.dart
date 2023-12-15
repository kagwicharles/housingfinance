import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfbbank/screens/dashboard/dashboard_screen.dart';

Widget mainDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Center(
            child: CircleAvatar(
              child: Image.asset('assets/images/hfb_logo.png'),
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const ListTile(
                leading: Icon(CupertinoIcons.phone_arrow_down_left),
                title: Text(
                  'Contact Us',
                ),
              ),
              InkWell(
                onTap: () {
                  AlertUtil.showAlertDialog(context, 'Logout? ',
                          isConfirm: true)
                      .then((value) {
                    if (value) {
                      Get.offAll(() => const DashBoardScreen());
                    }
                  });
                },
                child: const ListTile(
                  leading: Icon(CupertinoIcons.power),
                  title: Text(
                    'Logout',
                    // style: GoogleFonts.inter(
                    //     textStyle: Styles.textStyleNormalAccent),
                  ),
                ),
              )
            ]))
      ],
    ),
  );
}
