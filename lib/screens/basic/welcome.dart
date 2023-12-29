import 'package:flutter/material.dart';
// import 'package:recyclo/screens/auth_ui/mbl_number.dart';
// import 'package:recyclo/screens/auth_ui/signup.dart';
// import 'package:recyclo/screens/auth_ui/login.dart';
// import 'package:recyclo/screens/dealer/dealerui.dart';
// import 'package:recyclo/screens/auth_ui/signup.dart';
// import 'package:recyclo/screens/user/userui.dart';

// import '../../constants/routes.dart';
// import 'package:recyclo/constants.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Welcome',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Image.asset("assets/images/welcome.png")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'signup_screen');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      " Seller",
                      style: TextStyle(
                        color: (Colors.white),
                        fontSize: 20,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      " Buyer",
                      style: TextStyle(
                        color: (Colors.white),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
