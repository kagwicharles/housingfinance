import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/theme.dart';
class AboutUsPage extends StatefulWidget {
  final bool isSkyBlueTheme;
  const AboutUsPage({required this.isSkyBlueTheme});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
            backgroundColor: widget.isSkyBlueTheme ? primaryLight : primaryLightVariant,
            body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/arrleft.png",
                          fit: BoxFit.cover,
                          width: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.only(left: 24),
                          child: const Text(
                              "About Us",
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: "DMSans",
                                fontWeight: FontWeight.bold,
                              ),
                          )
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Incorporated as a private company under the Companies Act in December 1967, the Bank has become a household name and has grown in leaps and bounds with a good track record among the pioneers of a mortgage lending. National Housing &amp; Construction Corporation, a parastatal involved in real estate business has 5% shareholding and National Social Security Fund (NSSF) holds 50% and the Government of Uganda holds 45%.\n\n Today, the bank looks back with pride on the business accomplished in the mortgage lending business. Through innovation and placing emphasis on Honesty, Integrity, Efficiency and Customer care, Housing Finance Bank is the leader in the mortgage, holding a 90% market share. Housing Finance Bank is committed to maintaining its profitability and improving delivery of shelter by availing mortgage loan facilities. The company has recorded steady growth in deposits, mortgage assets and shareholder equity.\n\n The Bank\'s public deposits have been steadily increasing over the last six years from Ushs. 20.2 billion in 2003 to Ushs. 78.3 billion in 2008 while its total mortgage asset stands at Ushs 149.9 billion as at End of 2008. With the envisaged upturn in economic activities Housing Finance Bank is prepared to offer better services to clients. We are committed to provide Ugandans with a path to a home of their own through our flexible savings and mortgage schemes',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 24),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: primaryColor),
                          width: MediaQuery.of(context).size.width,
                          height:46,
                          child: GestureDetector(onTap: () {
                            launchUrl(
                                Uri.parse("https://www.craftsilicon.com"),
                                mode: LaunchMode.externalApplication,
                                webViewConfiguration: const WebViewConfiguration(
                                  enableJavaScript: false,
                                ));
                          }, child: const Center(child:Text('Powered By CraftSilicon',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "DMSans",
                                color: Colors.white
                            ),
                          ),),
                          )
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ));
  }

}
