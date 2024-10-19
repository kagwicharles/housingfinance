import 'package:flutter/material.dart';

class ModuleLoader extends StatelessWidget{
  const ModuleLoader({super.key});

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
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14,),
            Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
                SizedBox(width: 14,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    //set border radius more than 55% of height and width to make circle
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: const SizedBox(
                    height: 55,
                    width: 60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 44,),
          ],
        )
    );
  }

}