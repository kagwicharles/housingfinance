import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/screens/remoteAccountOpening/rao_screen.dart';
import 'package:hfbbank/screens/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsnConditions extends StatefulWidget {
  final CustomerData customerData;
  const TermsnConditions({Key? key, required this.customerData}) : super(key: key);

  @override
  State<TermsnConditions> createState() => _TermsnConditionsState();
}

class _TermsnConditionsState extends State<TermsnConditions> {
  bool isLoading = true;
  bool _isAccepted = false;
  late InAppWebViewController _webViewController;
  String? termsUrl;

  @override
  void initState() {
    super.initState();
    _checkUrl();
  }

  _checkUrl() async {
    // If widget URL is not provided, check SharedPreferences
    if (widget.customerData.termsUrl.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        termsUrl = prefs.getString('raoProductTermsUrl') ?? '';
        print("TERMSURL " + termsUrl! );
      });
    } else {
      setState(() {
        termsUrl = widget.customerData.termsUrl;
        print("TERMSURL2 " + termsUrl! );

      });
    }
    // Proceed to load the URL in WebView
    if (termsUrl != null && termsUrl!.isNotEmpty) {
      setState(() {
        isLoading = false; // The URL is ready
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            color: primaryLightVariant,
            child: SpinKitSpinningLines(
              color: primaryColor,
              duration: Duration(milliseconds: 2000),
              size: 40,
            ),
          ),
          isLoading
              ? const Center(
            child: SpinKitSpinningLines(
              color: primaryColor,
              duration: Duration(milliseconds: 2000),
              size: 40,
            ), // Show loading indicator while checking URL
          ) : InAppWebView(
            initialUrlRequest: URLRequest(
                url: WebUri.uri(Uri.parse(widget.customerData.termsUrl)) // Use WebUri.uri() here
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                transparentBackground: true,
                javaScriptEnabled: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false; // Hide loading once the page is fully loaded
              });
            },
          ),
          isLoading
              ? const SizedBox.shrink()
              :
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.9), // Slight transparency for visibility over WebView
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        activeColor: primaryColor,
                        side: BorderSide(color: primaryColor, width: 2),
                        value: _isAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isAccepted = value ?? false;
                            widget.customerData.termsAccepted = _isAccepted;
                          });
                        },
                      ),
                      const Text("I accept the terms and conditions",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Manrope",
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

