import 'package:flutter/material.dart';

class CustomAlertDialog {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding:
          const EdgeInsets.only(bottom: 16, right: 14, left: 14),
          insetPadding: const EdgeInsets.symmetric(horizontal: 44),
          titlePadding: EdgeInsets.zero,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: Container(
            height: 100,
            color: Colors.blue, // Set your primary color here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Alert",
                  style: TextStyle(
                      fontFamily: "DMSans",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 38,
                )
              ],
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: "Manrope",
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Replace with your APIService color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 34.0),
              ),
              child: const Text(
                "OK",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
