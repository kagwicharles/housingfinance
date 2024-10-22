import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/dashboard/dashboard_screen.dart';

import '../../theme/theme.dart';
import '../home/home_screen.dart';

class SuccessDisplayWidget extends StatefulWidget {
  final String accountNumber;
  final String merchant;
  final bool isSkyBlueTheme;

  const SuccessDisplayWidget({Key? key, required this.accountNumber,
    required this.merchant,
    required this.isSkyBlueTheme
  }) : super(key: key);

  @override
  _SuccessDisplayWidgetState createState() => _SuccessDisplayWidgetState();
}

class _SuccessDisplayWidgetState extends State<SuccessDisplayWidget> {
  late final Future<void> _backgroundLoaded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
      color: primaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white, // White card for contrast
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green, // Icon color for success
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Account Opened Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black87, // Darker text for better contrast
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your new account number is:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 18,
                      color: Colors.black54, // Softer text for subheadings
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.accountNumber,
                        style: const TextStyle(
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87, // Bold account number
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: primaryColor), // More vibrant color for copy icon
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.accountNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Account number copied to clipboard",
                                style: TextStyle(
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Visit any agent or branch to deposit funds and start using your account. Use the Agent or Branch locator on the Dashboard page to see our branches or agents near you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: 120, // Slightly larger button
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.merchant == "RAONEW") {
                          Navigator.of(context, rootNavigator: true).pop(context);
                        } else {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen(isSkyTheme: widget.isSkyBlueTheme)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        backgroundColor: primaryColor, // Gradient or deep color for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded button
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )
        ),
      ),
    ));
  }
}
