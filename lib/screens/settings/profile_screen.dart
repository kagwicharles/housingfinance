import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:hfbbank/screens/home/components/extensions.dart';
import 'package:hfbbank/screens/home/home_screen.dart';
import 'package:hfbbank/theme/theme.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../home/home_header.dart';
import '../home/components/custom_drawer.dart';
import 'biometrics.dart';
import 'database_helper.dart';

class ProfileTab extends StatefulWidget {
  final bool isSkyBlueTheme;
  const ProfileTab({required this.isSkyBlueTheme});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _profileRepo = ProfileRepository();
  String? fullName;
  var firstName, lastName, email, ID, image, phone;
  bool _isSelected = false;
  final _moduleRepository = ModuleRepository();
  final _sharedPref = CommonSharedPref();
  String? dpImgString;
  bool isDpSet = false;
  Uint8List? dp;
  // final _moduleRepo = ModuleRepository();
  // List<ModuleItem>? modules;


  @override
  void initState() {
    if (widget.isSkyBlueTheme){
      _isSelected = true;
    }
    getEmail();
    getFirstName();
    getLastNAme();
    getPhone();
    // _fetchModules();
    // TODO: implement initState
    super.initState();
  }

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

  getProfilePicture() async {
    final localImageString = await DatabaseHelper.instance.getProfileImage();
    if (localImageString != null) {
      setState(() {
        dpImgString = localImageString;
        isDpSet = true;
        dp = base64Decode(localImageString);
      });
    }
  }

  // void _fetchModules() async {
  //   List<ModuleItem>? fetchedModules = await _moduleRepo.getModulesById('MAIN');
  //   setState(() {
  //     modules = fetchedModules;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: CustomDrawer(isSkyTheme: widget.isSkyBlueTheme),
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              HomeHeaderSectionApp(
                header: 'App Settings', name: '',
              ),
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                  child: Container(
                    color: _isSelected ? primaryLight : primaryLightVariant,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            ProfilePictureWidget(isSkyBlueTheme: widget.isSkyBlueTheme,),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Text("${firstName} $lastName",
                                  style: const TextStyle(fontFamily: "Manrope",
                                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(email ?? "",
                                  style: TextStyle(fontFamily: "Manrope",
                                      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[600]),),
                                Text(phone ?? "",
                                  style: TextStyle(fontFamily: "Manrope",
                                      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey[600]),),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 24, right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Set App Theme',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Manrope",
                                    fontSize: 14),
                              ),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                            color: Colors.grey[200],
                            width: MediaQuery.of(context).size.width,
                            child:GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.zero,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/sky1.png",
                                      fit: BoxFit.cover,
                                      width: 28,
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      "SkyBlue Mode",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 12,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.bold

                                      ),
                                    ),
                                    const Spacer(),
                                    Transform.scale(
                                      scale: 0.7,
                                      child: Switch(
                                        value: _isSelected,
                                        onChanged: (value) async {
                                          if (_isSelected){
                                            await CommonSharedPref().setSkyBlueTheme(false);
                                          } else {
                                            await CommonSharedPref().setSkyBlueTheme(true);
                                          }
                                          setState(() {
                                            _isSelected = value;
                                          });
                                        },
                                        activeColor: primaryColor,
                                        activeTrackColor: primaryLight,
                                        inactiveThumbColor: primaryColor,
                                        trackOutlineColor: MaterialStateProperty.all(_isSelected ? Colors.white : primaryColor),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 24, right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Account Settings',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Manrope",
                                    fontSize: 14),
                              ),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          color: Colors.grey[200],
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              buildListItem('assets/images/pin_c.png', 'Pin Management', '1'),
                              buildListItem('assets/images/biometrics_c.png', 'Biometrics Login', '2'),
                              buildListItem('assets/images/alias_c.png', 'Set Account Alias', '3'),
                              buildListItem('assets/images/primary_c.png', 'Set Primary Account', '4'),
                              // buildLogoutItem('assets/images/web.png', 'Logout', '5'),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.106383,
                          color: widget.isSkyBlueTheme
                              ? primaryLight
                              : primaryLightVariant,
                        ),
                      ],
                    ),
                  ))
            ])));
  }

  Widget buildListItem(String icon, String title, String count) {
    return GestureDetector(
      onTap: (){
        switch (count){
          case "1":
            _moduleRepository.getModuleById("PIN").then((module) {
              CommonUtils.navigateToRoute(
                  context: context,
                  widget: DynamicWidget(
                    moduleItem: module, isSkyBlueTheme: widget.isSkyBlueTheme,
                  ));
            });
            break;
          case "2":
            context.navigate(
                BiometricsLogin());
            break;
          case "3":
            _moduleRepository.getModuleById("SETALIASNAME").then((module) {
              CommonUtils.navigateToRoute(
                  context: context,
                  widget: DynamicWidget(
                    moduleItem: module, isSkyBlueTheme: widget.isSkyBlueTheme,
                  ));
            });
            break;
          case "4":
            _moduleRepository.getModuleById("SETPRIMARYACCOUNT").then((module) {
              CommonUtils.navigateToRoute(
                  context: context,
                  widget: DynamicWidget(
                    moduleItem: module, isSkyBlueTheme: widget.isSkyBlueTheme,
                  ));
            });
            break;
        }
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              fit: BoxFit.cover,
              width: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold

              ),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogoutItem(String icon, String title, String count) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold

              ),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePictureWidget extends StatefulWidget {
final bool isSkyBlueTheme;
  const ProfilePictureWidget(
      {required this.isSkyBlueTheme});

  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  final _sharedPref = CommonSharedPref();
  File? customerDPFile;
  String? dpImgString;
  bool isDpSet = false;
  Uint8List? dp;
  late Map<String, dynamic> imageData;

  Future<void> _showImageSourceDialog() async {
    _sharedPref.setIsListeningToFocusState(false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Manrope", fontWeight: FontWeight.bold, fontSize: 22),),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _getFromCamera();
              },
              child: const Text("Take Photo",
                style: TextStyle(fontFamily: "Manrope",color: primaryColor),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _getFromGallery();
              },
              child: const Text("Choose from Gallery",
                style: TextStyle(fontFamily: "Manrope",color: primaryColor),),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _sharedPref.setIsListeningToFocusState(true);
              },
              child: const Text("Cancel",
                style: TextStyle(fontFamily: "Manrope",color: primaryColor),),
            ),
          ],
        );
      },
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = (await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0))) as File;

    customerDPFile = croppedImage;
    final Uint8List imageBytes = await croppedImage.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    dpImgString = base64Image;
    // print("Base64 Encoded Image String: $customerPhoto");
    if (isDpSet) {
      updateProfilePicture(dpImgString!);
    } else {
      saveProfilePicture(dpImgString!);
    }
    setState(() {
      isDpSet = true;
      dp = imageBytes;
    });

    _sharedPref.setIsListeningToFocusState(true);
  }

  void saveProfilePicture(String image) {
    final _api_service = APIService();
    _api_service.setDp(image).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        // String results = value.dynamicList.toString();
        DatabaseHelper.instance.insertProfileImage(image);
      } else  {
        AlertUtil.showAlertDialog(context, value.message ?? "Error saving your profile picture. Please try again later");
      }
    });
  }

  void updateProfilePicture(String image) {
    final _api_service = APIService();
    _api_service.updateDp(image).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        // String results = value.dynamicList.toString();
        DatabaseHelper.instance.updateImage(image);
      } else  {
        AlertUtil.showAlertDialog(context, value.message ?? "Error updating your profile picture. Please try again later");
      }
    });
  }

  getProfilePicture() async {
    final localImageString = await DatabaseHelper.instance.getProfileImage();
    if (localImageString != null) {
      setState(() {
        dpImgString = localImageString;
        isDpSet = true;
        dp = base64Decode(localImageString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: isDpSet
          ? Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50), // Circular shape
            child: Image.memory(
              dp!,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.isSkyBlueTheme ? primaryLightVariant : primaryLight, // Or use your app's primary color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      )
          : Stack(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.isSkyBlueTheme ? primaryLightVariant : primaryLight, // Or use your app's primary color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}