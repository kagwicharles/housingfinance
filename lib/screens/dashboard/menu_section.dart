import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/auth/activation_screen.dart';
import 'package:hfbbank/screens/auth/login_screen.dart';
import 'package:hfbbank/theme/theme.dart';

class MenuSection extends StatelessWidget {
  final bool isActive;

  const MenuSection({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            TopDashItem(
                // title: "Agency Banking",
                image: "assets/images/agency.png",
                color: Colors.white),
            Text(
              'Agency Banking',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: primaryColor),
              textAlign: TextAlign.center,
            )
          ],
        ),
        Column(
          children: [
            TopDashItem(
                // title: "School Pay",
                image: "assets/images/school.png",
                color: Colors.white),
            Text(
              'School Pay',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: primaryColor),
              textAlign: TextAlign.center,
            )
          ],
        ),
        Column(
          children: [
            TopDashItem(
                // title: "Mobile Banking",
                image: 'assets/images/mbank.png',
                ontap: () {
                  isActive
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()))
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ActivationScreen()));
                  // context.navigate(
                  // isActive ?
                  // const LoginScreen();
                  // : const ActivationScreen());
                },
                color: Colors.white),
            Text(
              'Mobile Banking',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: primaryColor),
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    );
  }
}

class MenuSectionLarge extends StatelessWidget {
  const MenuSectionLarge({super.key});

  @override
  Widget build(BuildContext context) => GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 100,
          mainAxisSpacing: 20,
          // childAspectRatio: 1,
        ),
        children: [
          TopDashItem(
              // title: "Agent Banking",
              image: "assets/images/dashimg1.png",
              color: const Color(0xffFCE9E9)),
          TopDashItem(
              // title: "School Pay",
              image: "assets/images/dashimg2.png",
              color: const Color(0xffFFF9D9)),
          TopDashItem(
              // title: "Mobile Banking",
              image: "assets/images/dashimg3.png",
              ontap: () {
                context.navigate(const ActivationScreen());
              },
              color: const Color(0xffD6DBFF))
        ],
      );
}

class TopDashItem extends StatelessWidget {
  final String image;
  final Color color;
  Function()? ontap;

  TopDashItem(
      {super.key, required this.image, required this.color, this.ontap});

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
          height: 80,
          width: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(30)),
          child: Center(
              child: Container(
            height: 40,
            width: 40,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ))));
}
