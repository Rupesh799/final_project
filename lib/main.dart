import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recyclo/constants/themedata.dart';
import 'package:recyclo/firebase_options.dart';
import 'package:recyclo/models/firebase_user.dart';
import 'package:recyclo/screens/auth_ui/account_setting.dart';
import 'package:recyclo/screens/auth_ui/login.dart';
import 'package:recyclo/screens/auth_ui/signup.dart';
import 'package:recyclo/screens/auth_ui/user_profile.dart';
import 'package:recyclo/screens/basic/home.dart';
import 'package:recyclo/screens/basic/welcome.dart';
import 'package:recyclo/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:recyclo/services/notification_provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "recyclo",
          theme: themeData,
          // initialRoute: 'login_screen',
          routes: {
            'welcome_screen': (context) => Welcome(),
            'signup_screen': (context) => Signup(),
            'login_screen': (context) => Login(),
            'profile_screen': (context) => UserProfile(),
            'home_screen': (context) => Home(),
            'buyer_home_screen': (context) => MyApp(),
            'account_screen': (context) => AccountSetting(),
          },
          home: SplashScreen(),
        ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some delay to show the animation
    Future.delayed(Duration(milliseconds: 2600), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Login()), // Replace with your desired home page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/animation.gif',
          // Replace with your GIF file path
          // placeholder: (context, url) => CircularProgressIndicator(),
          // errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
