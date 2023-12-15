import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:profile/profile.dart';

import '../headers/drawer.dart';
import '../headers/header_section.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _profileRepo = ProfileRepository();
  String? fullName;
  var firstName;
  var lastName;
  var email;
  var ID;
  var image;
  var phone;

  getFirstName() {
    _profileRepo.getUserInfo(UserAccountData.FirstName).then((value) {
      setState(() {
        debugPrint(">>>${value.toString()}");

        firstName = value;
      });
    });
  }

  getLastNAme() {
    _profileRepo.getUserInfo(UserAccountData.LastName).then((value) {
      setState(() {
        debugPrint(">>>${value.toString()}");

        lastName = value;
      });
    });
  }

  getEmail() {
    _profileRepo.getUserInfo(UserAccountData.EmailID).then((value) {
      setState(() {
        debugPrint(">>>${value.toString()}");

        email = value;
      });
    });
  }
  getPhone() {
    _profileRepo.getUserInfo(UserAccountData.Phone).then((value) {
      setState(() {
        debugPrint(">>>${value.toString()}");

        phone = value;
      });
    });
  }

  @override
  void initState() {
    getEmail();
    getFirstName();
    getLastNAme();
    getPhone();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: mainDrawer(context),
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),
           HeaderSectionApp(
            header: 'Profile',
          ),
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              child: Container(
                color: primaryLight,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                      // child: Image.network(image),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("${firstName} $lastName"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(email ?? ""),
                    // Text("email"),
                    SizedBox(
                      height: 10,
                    ),

                    Text(phone ?? ""),
                  ],
                ),
              ))
        ])));
  }
}
