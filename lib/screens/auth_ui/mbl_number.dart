// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:recyclo/constants/routes.dart';
import 'package:recyclo/screens/auth_ui/otp.dart';
// import 'package:get/get.dart';
// import 'package:recyclo/constants/routes.dart';
// import 'package:recyclo/constants/routes.dart';
// import 'package:recyclo/screens/auth_ui/otp.dart';
// import 'package:recyclo/constants/themedata.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  // Default.
  // final countryPicker = const FlCountryCodePicker();

  // CountryCode countryCode =
  //     const CountryCode(name: 'Nepal', code: 'NEP', dialCode: '+977');

  // onSubmit(String? input) {
  //   Routes.instance
  //       .push(widget: Otp(countryCode.dialCode + input!), context: context);
  // }

  TextEditingController countrycode = TextEditingController();

  var phone = "";

  @override
  void initState() {
    countrycode.text = "+977";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Recyclo",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Sell Waste Earn Money",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      spreadRadius: 5,
                      blurRadius: 4,
                    )
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                //  children: [
                //     Expanded(
                //         flex: 1,
                //         // ignore: avoid_unnecessary_containers
                //         child: InkWell(
                //           onTap: () {},
                //           child: const Row(
                //             children: [
                //               // Expanded(
                //               //   // ignore: avoid_unnecessary_containers
                //               //   // child: Container(
                //               //   //   child: countryCode.flagImage(),
                //               //   // ),
                //               // ),

                //               Padding(
                //                 padding: EdgeInsets.only(left: 15),
                //                 child: Text("+977"),
                //               ),
                //               Icon(Icons.arrow_drop_down_rounded),
                //             ],
                //           ),
                //         )),
                //     Container(
                //       width: 1,
                //       height: 50,
                //       color: Color.fromARGB(255, 6, 5, 5).withOpacity(.6),
                //     ),
                //     Expanded(
                //       flex: 3,

                //       // ignore: avoid_unnecessary_containers
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child:  TextField(
                //           //  controller:
                //           // onChanged: (value) {
                //           //   phone = value;
                //           // },
                //           keyboardType: TextInputType.phone,
                //           decoration: InputDecoration(
                //             hintText: 'Enter Phone Number',
                //             border: InputBorder.none,
                //             focusedBorder: InputBorder.none,
                //             enabledBorder: InputBorder.none,
                //             errorBorder: InputBorder.none,
                //             disabledBorder: InputBorder.none,
                //           ),
                //         ),
                //       ),
                //     )
                //   ],

                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: countrycode,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const Text(
                    "|",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      // ignore: unused_label
                      phone:
                      value;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Enter Mobile Number"),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    // ignore: unnecessary_string_interpolations
                    phoneNumber: '${countrycode.text + phone}',
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      Routes.instance.push(widget: Otp(phone), context: context);
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                child: const Text(
                  "Send the code",
                )),
          ],
        ),
      ),
    );
  }
}
