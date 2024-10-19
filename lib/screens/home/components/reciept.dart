import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';



class TrxReceipt extends StatefulWidget {
  final List<dynamic>? recieptDetails;
  final bool isSkyBlueTheme;

  const TrxReceipt({
    required this.recieptDetails,
    required this.isSkyBlueTheme
  });

  @override
  State<TrxReceipt> createState() => _TrxReceiptState();
}

class _TrxReceiptState extends State<TrxReceipt> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ClipPath(
                          clipper: PointsClipper(),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0))),
                              padding: const EdgeInsets.only(
                                  bottom: 12, left: 12, right: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Padding(padding: EdgeInsets.all(16),
                                    child: Image(
                                      image: AssetImage("assets/images/success.png"),
                                      width: 100,
                                    ),),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                              color: Colors.grey[300],
                                            )),
                                        const Text(
                                          "Success",
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.recieptDetails?.length ?? 0,
                          itemBuilder: (context, index) {
                            final title = widget.recieptDetails![index]['Title'];
                            final value = widget.recieptDetails![index]['Value'];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1, // Adjust flex as needed to control the space
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: "Manrope",
                                          fontWeight: FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.visible, // Ensure overflow is visible to allow wrapping
                                        softWrap: true, // Enable word wrap
                                        maxLines: null,
                                      ),
                                    ),
                                    const SizedBox(width: 15), // Space between the two text widgets
                                    Expanded(
                                      flex: 1, // Adjust flex as needed to control the space
                                      child: Text(
                                        value,
                                        overflow: TextOverflow.visible, // Ensure overflow is visible to allow wrapping
                                        softWrap: true, // Enable word wrap
                                        maxLines: null,
                                        style: const TextStyle(
                                          fontFamily: "Manrope",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Thank you for using ${APIService.appLabel}",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 136, 188, 51))
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ScreenHome(isSkyBlueTheme: widget.isSkyBlueTheme,)));
                                            },
                                            child: const Text("Done"))),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ])))),
                  const SizedBox(),
                ],
              ))),
      backgroundColor: APIService.appPrimaryColor,
    );
  }
}

class PointsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 20;

    while (x < size.width) {
      x += increment;
      y = (y == size.height) ? size.height * .97 : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}
