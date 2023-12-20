import 'package:flutter/material.dart';
import 'package:hfbbank/theme/theme.dart';

class CreDebCard extends StatefulWidget {
  const CreDebCard({super.key});

  @override
  State<CreDebCard> createState() => _CreDebCardState();
}

class _CreDebCardState extends State<CreDebCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              // color: Colors.white,
                height: 100,
                child: Card(
                  color: primaryLight,
                  child: Row(
                    children: [
                      Container(margin:EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Image.asset('assets/images/income.png'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Credit'),
                                SizedBox(
                                  width: 25,
                                ),
                                Icon(Icons.remove_red_eye_outlined),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text('UGX 1,000,000')
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                Container(height: 100,child: Card(
                  color: primaryLightVariant,
                  child: Row(
                    children: [
                      Container(margin:EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Image.asset('assets/images/outcome.png'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Debit'),
                                SizedBox(
                                  width: 25,
                                ),
                                Icon(Icons.remove_red_eye_outlined),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text('UGX 1,000,000')
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),

    );
  }
}
