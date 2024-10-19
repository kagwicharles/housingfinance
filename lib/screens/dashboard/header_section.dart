import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Spacer(),
      Image.asset(
        "assets/images/headerlogo.png",
        fit: BoxFit.cover,
        height: 50,
      ),
      Spacer(),
      GestureDetector(
        onTap: (){

        },
        child: Image.asset(
          "assets/images/notification.png",
          fit: BoxFit.cover,
          width: 18,
        ),
      ),
      SizedBox(width: 35,)
    ],
  );
}
