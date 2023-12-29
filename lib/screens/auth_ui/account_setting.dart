import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:recyclo/authentication/authentication_repository.dart';
import 'package:recyclo/screens/auth_ui/login.dart';
import 'package:recyclo/screens/auth_ui/user_profile.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:get/get.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        _user = user;
        _userData = snapshot.data();
      });
    }
  }

  // Logout() async {
  //   await _auth.signOut();
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => Login()));
  // }

  //image upload
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

//Logout conformation

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are You Sure Want to Logout"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void Logout() {
    _showLogoutConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Setting')),
      body: _user != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  image: _image != null
                                      ? DecorationImage(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover)
                                      : null),
                              child: _image == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    )
                                  : null),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData?['fullName'] ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            _userData?['phone'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserProfile()));
                                },
                                child: Text(
                                  "Profile Setting",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.arrow_right,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Row(children: [
                            Icon(
                              Icons.settings,
                              color: Color.fromARGB(255, 40, 125, 112),
                              size: 30,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Settings",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        const Row(children: [
                          Icon(
                            Icons.money,
                            color: Color.fromARGB(255, 40, 125, 112),
                            size: 30,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Rates",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ]),
                        const SizedBox(
                          height: 45,
                        ),
                        const Row(children: [
                          Icon(
                            Icons.info,
                            color: Color.fromARGB(255, 40, 125, 112),
                            size: 30,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "About Us",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ]),
                        const SizedBox(
                          height: 45,
                        ),
                        const Row(children: [
                          Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 40, 125, 112),
                            size: 30,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Contact",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ]),
                        const SizedBox(
                          height: 45,
                        ),
                        InkWell(
                          onTap: () {
                            Logout();
                          },
                          child: const Row(children: [
                            Icon(
                              Icons.logout,
                              color: Color.fromARGB(255, 40, 125, 112),
                              size: 30,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
