import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _backgroundLoaded = _loadBackground();
  }

  Future<void> _loadBackground() async {
    // Load the background image here
    await precacheImage(AssetImage("assets/images/background.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _backgroundLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while the background image is being loaded
            return Center(child: CircularProgressIndicator());
          }
          // Once the background image is loaded, display the SuccessDisplayWidget
          return _buildSuccessDisplayWidget();
        },
      ),
    );
  }

  Widget _buildSuccessDisplayWidget() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white.withOpacity(0.3), // Transparent card
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Account Opened Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Manrope", fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your new account number is:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Manrope", fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 15),
                      Text(
                        widget.accountNumber,
                        style: const TextStyle(fontFamily: "Manrope", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.accountNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Account number copied to clipboard",
                                style: TextStyle(fontFamily: "Manrope", fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Please visit any agent or branch to deposit money on your account and start using it",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Manrope", fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 100, // Set the width as desired
                    height: 40, // Set the height as desired
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.merchant == "RAONEW"){
                          Navigator.of(context, rootNavigator: true)
                              .pop(context);
                        }else{
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashBoardScreen(isSkyTheme: widget.isSkyBlueTheme,)));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(secondaryAccent),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
