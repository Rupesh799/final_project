// seller.dart
import 'package:flutter/material.dart';
import 'package:recyclo/screens/auth_ui/signup.dart';

class SellerSignup extends StatefulWidget {
  const SellerSignup({Key? key}) : super(key: key);

  @override
  State<SellerSignup> createState() => _SellerSignupState();
}

class _SellerSignupState extends State<SellerSignup> {
  bool isShowPassword = true;

  String fullName = "", email = "", phone = "", password = "", wastetype = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Full Name",
                prefixIcon: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 8, 149, 128),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                if (value != null) {
                  if (value.contains('@') && value.endsWith('.com')) {
                    return null;
                  }
                  return 'Enter a valid email address';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(
                  Icons.mail,
                  color: Color.fromARGB(255, 8, 149, 128),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(
                  Icons.call,
                  color: Color.fromARGB(255, 8, 149, 128),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: passwordController,
              obscureText: isShowPassword,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                if (value.trim().length < 8) {
                  return 'Password must be at least 8 characters in length';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Create Password",
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 8, 149, 128),
                ),
                suffixIcon: TextButton(
                  onPressed: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                  child: const Icon(
                    Icons.visibility,
                    color: Color.fromARGB(255, 8, 149, 128),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                    fullName = nameController.text;
                    email = emailController.text;
                    phone = phoneController.text;
                    password = passwordController.text;
                  });
              }
            },
            child: const Text(
              "SignUp",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}