import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/screens/home/components/home_page.dart';

import '../../../theme/theme.dart';
import '../home_screen.dart';

class SuccessView extends StatefulWidget {
  final String message;
  final bool isSkyBlueTheme;

  const SuccessView({Key? key, required this.message, required this.isSkyBlueTheme}) : super(key: key);

  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark// Make the status bar transparent
      ),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              // Transparent card
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: primaryColor,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Image(
                        image: AssetImage("assets/images/success.png"),
                        width: 80,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Dear customer, " + widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: 180, // Set the width as desired
                      height: 50, // Set the height as desired
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme,)));
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}
