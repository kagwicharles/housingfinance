import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  final bool isSkyBlueTheme;
  const ContactUs({required this.isSkyBlueTheme});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  @override
  void dispose() {
    // Re-enable system UI when disposing the widget
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent.
      statusBarIconBrightness: Brightness.light, // Dark icons for light background.
      statusBarBrightness: Brightness.light, // For iOS devices.
    ));
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Light icons
      ),
      child: Scaffold(
        backgroundColor: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Top-left aligned content
              Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 24,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/images/arrleft.png",
                    fit: BoxFit.cover,
                    width: 24,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                left: 42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.010,
                    ),
                    Text(
                      "Feel free to get in touch with us",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "DMSans",
                          color: Colors.grey[600]),
                      softWrap: true,
                    ),
                    Text(
                      "Any time, Any where",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "DMSans",
                          color: Colors.grey[600]),
                      softWrap: true,
                    )
                  ],
                ),
              ),
              // Centered content
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Image.asset('assets/images/hfb_logo.png'),
                      backgroundColor: Colors.blueAccent, // Use your primary color here
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Physical Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "DMSans",
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text('Investment House',
                      style: TextStyle(
                        fontFamily: "DMSans",
                      ),),
                    const Text('Plot 4 Wampewo Avenue, Kololo',
                      style: TextStyle(
                        fontFamily: "DMSans",
                      ),),
                    const Text('Fax: +256-414-232792',
                      style: TextStyle(
                        fontFamily: "DMSans",
                      ),),
                    const SizedBox(height: 5,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 34),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialMediaButton.facebook(
                          onTap: (){
                            launchUrl(
                                Uri.parse("https://www.facebook.com/HousingFinanceBank"),
                                mode: LaunchMode.externalApplication,
                                webViewConfiguration: const WebViewConfiguration(
                                  enableJavaScript: false,
                                ));
                          },),
                        SizedBox(width: 20),
                        SocialMediaButton.twitter(
                            onTap: (){
                          launchUrl(
                              Uri.parse("https://x.com/housingfinanceU"),
                              mode: LaunchMode.externalApplication,
                              webViewConfiguration: const WebViewConfiguration(
                                enableJavaScript: false,
                              ));
                        }),
                        SizedBox(width: 20),
                        SocialMediaButton.google(
                            onTap: (){
                          launchUrl(
                              Uri.parse("https://www.housingfinance.co.ug"),
                              mode: LaunchMode.externalApplication,
                              webViewConfiguration: const WebViewConfiguration(
                                enableJavaScript: false,
                              ));
                        }),
                        SizedBox(width: 20),
                        SocialMediaButton.instagram(onTap: (){
                          launchUrl(
                              Uri.parse("https://www.instagram.com/housingfinancebank?igsh=OWdoYW5vdjd1czQ4"),
                              mode: LaunchMode.externalApplication,
                              webViewConfiguration: const WebViewConfiguration(
                                enableJavaScript: false,
                              ));
                        }),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.18,
                  right: 34,
                  left: 34,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryColor),
                      width: MediaQuery.of(context).size.width,
                      height:46,
                      child: GestureDetector(onTap: () {
                        launchUrl(
                            Uri.parse("https://www.housingfinance.co.ug/about-us/privacy-notice/"),
                            mode: LaunchMode.externalApplication,
                            webViewConfiguration: const WebViewConfiguration(
                              enableJavaScript: false,
                            ));
                      }, child: const Center(child:Text('View Our Privacy Policy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "DMSans",
                            color: Colors.white
                        ),
                      ),),
                      )
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
