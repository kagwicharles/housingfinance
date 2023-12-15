import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/dash_logo.png",
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  const Text(
                    "Housing\nFinance\nBank",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ],
              )),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_sharp,
                        color: Colors.white,
                        size: 34,
                      ))))
        ],
      );
}
