import 'package:flutter/material.dart';

class LastCrDrLoad extends StatelessWidget{
  const LastCrDrLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 14,),
            Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 80,
                    width: 145,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 80,
                    width: 145,
                  ),
                )
              ],
            ),
            SizedBox(height: 14,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                //set border radius more than 50% of height and width to make circle
              ),
              elevation: 5,
              shadowColor: Colors.black,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        )
       );
  }

}