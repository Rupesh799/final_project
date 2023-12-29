import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:recyclo/constants/routes.dart';
// import 'package:recyclo/controller/auth_controller.dart';
import 'package:recyclo/screens/auth_ui/user_profile.dart';

// ignore: must_be_immutable
class Otp extends StatefulWidget {
  String phoneNumber;
  // ignore: use_key_in_widget_constructors
  Otp(this.phoneNumber);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // AuthController authController = Get.put(AuthController());

  // @override
  // void initState() {
  //   super.initState();
  //   authController.phoneAuth(widget.phoneNumber);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "recyclo",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "OTP Verification",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              selectionColor: Colors.greenAccent,
            ),
            const SizedBox(height: 30),
            const Text(
              "Enter the OTP below that is sent to your mobile number",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 45,
              child: Pinput(
                length: 6,
                onCompleted: (String input) {
                  // authController.verifyOtp(input);
                },
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'Resend code in ' " ",
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: '30 Seconds',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  Routes.instance
                      .push(widget: const UserProfile(), context: context);
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
