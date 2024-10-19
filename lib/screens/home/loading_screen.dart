import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hfbbank/theme/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
      ),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/images/headerlogo.png"),
                    width: 150,
                    height: 150,
                  ).animate(
                    onPlay: (controller) => controller.repeat(), // loop
                  ).shimmer(duration: 15000.ms),
                ],
              ),
            ),
            const Positioned(
              bottom: 24,
              right: 24,
              child: Image(
                image: AssetImage("assets/images/powered_by.png"),
                width: 130,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
