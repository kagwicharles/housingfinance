import 'package:flutter/material.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:social_media_buttons/social_media_button.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 30,
                  child: Image.asset('assets/images/hfb_logo.png'),
                  backgroundColor: primaryColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Physical Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  'Investment House',
                ),
                Text(
                  'Plot 4 Wampewo Avenue, Kololo',
                ),
                Text(
                  'Fax: +256-414-232792',
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialMediaButton.facebook(url:""),
                    SizedBox(
                      width: 20,
                    ),
                    SocialMediaButton.twitter(url:""),
                    SizedBox(
                      width: 20,
                    ),
                    SocialMediaButton.google(
                      url: "www.housingfinance.co.ug",
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SocialMediaButton.instagram(url: "",),
                    SizedBox(
                      width: 20,
                    ),
                    SocialMediaButton.linkedin(url: "" ,),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
              //Head Office
              // Investment House
              // Plot 4 Wampewo Avenue, Kololo
              // Fax: +256-414-232792
            ),
          )),
    );
  }
}
