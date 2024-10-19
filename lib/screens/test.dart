// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:provider/provider.dart';

const primaryColor = Color(0xff2532A1);
const secondaryAccent = Color(0xffF6B700);
const primaryLight= Color(0xffD3EFFF);
const primaryLightVariant= Color(0xffFFF9D9);

class TestListWidget extends StatefulWidget {

  TestListWidget({
    super.key,
  });

  @override
  State<TestListWidget> createState() => _TestListWidgetState();
}

class _TestListWidgetState extends State<TestListWidget> {
  final _moduleRepository = ModuleRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
color: primaryColor,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.network(
                        "https://uat.craftsilicon.com/image/FTB/ftb_v3/mobile_money.png",
                        width: 20,
                      ),
                    )),
                SizedBox(height: 4,),
                Text(
                  "Mobile Money",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  shadowColor: Colors.black,
                  child: Padding(
                      padding: EdgeInsets.all(15),
                      child: MenuItemImage(
                        imageUrl: "https://uat.craftsilicon.com/image/FTB/ftb_v3/mobile_money.png",
                        iconSize: 20,
                      ),)),
              SizedBox(
                height: double.parse("4"),
              ),
              Flexible(
                  child: MenuItemTitle(
                      title: "Title",
                      textSize: 11,
                      fontWeight:FontWeight.bold
                  ))
            ],
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
