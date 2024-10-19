import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/auth/activation_screen.dart';
import 'package:hfbbank/screens/auth/login_screen.dart';
import 'package:hfbbank/theme/theme.dart';

class MenuSection extends StatelessWidget {
  final bool isActive;
  final bool isSkyTheme;

  const MenuSection({super.key, required this.isActive, required this.isSkyTheme});

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
            SizedBox(height: 10,),
            const Text(
              'Agency Banking',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSans",
                  fontSize: 11,
                  color: primaryColor),
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
            SizedBox(height: 10,),
            Text(
              'School Pay',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "DMSans",
                  fontSize: 11,
                  color: primaryColor),
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
                          builder: (context) => LoginScreen(isSkyBlueTheme: isSkyTheme,)))
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ActivationScreen(isSkyBlueTheme: isSkyTheme,)));
                  // context.navigate(
                  // isActive ?
                  // const LoginScreen();
                  // : const ActivationScreen());
                },
                color: Colors.white),
            SizedBox(height: 10,),
            Text(
              'Mobile Banking',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: "DMSans",
                  color: primaryColor),
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    );
  }
}

class MenuSectionLarge extends StatelessWidget {
  final bool isSkyTheme;
  const MenuSectionLarge({required this.isSkyTheme});

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
                context.navigate( ActivationScreen(isSkyBlueTheme: isSkyTheme,));
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
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Rounded corners for the card
      ),
      elevation: 3, // Elevation to create shadow effect
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: color, // Card background color
          borderRadius: BorderRadius.circular(25), // Border radius
        ),
        child: Center(
          child: Container(
            height: 38,
            width: 38,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  );
}
