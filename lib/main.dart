import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mybixbite/User-Home-Screen/sign-in.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'Controller-Provider/Theme-Controller/theme-controler-provider.dart';
import 'Controller-Provider/User-Controller/user-signup-signin.dart';
import 'Theme/theme-constant.dart';
import 'User-Home-Screen/home-screen.dart';
import 'User-Home-Screen/navigation-home-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => SignUpSignInController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var userLoggedIn;

  @override
  void initState() {
    super.initState();

    userLoggedIn = FirebaseAuth.instance.currentUser;
    if (userLoggedIn == null) {
      userLoggedIn = null;
    } else if (FirebaseAuth.instance.currentUser!.displayName == "User Client") {
      userLoggedIn = "User Client";
    } else if (FirebaseAuth.instance.currentUser!.displayName == "Staff") {
      userLoggedIn = "Staff";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ThemeManager>().themeMode,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: userLoggedIn == "User Client"
          ? NavigationHomeScreen()
          : userLoggedIn == "Staff"
              ? const MyHomePage()
              : const SplashScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInitialValue = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) => setState(() {
          isInitialValue = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserClientLoginPage(),
              ));
        }));

    // Timer(
    //     const Duration(seconds: 3),
    //
    //     // () => Get.to(() => NavigationHomeScreen(),
    //     //     transition: Transition.circularReveal, duration: const Duration(seconds: 2))
    //     () => Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => NavigationHomeScreen(),
    //         )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        color: Colors.teal,
        constraints: BoxConstraints(
          maxWidth: isInitialValue ? 200 : 100,
          maxHeight: isInitialValue ? 200 : 100,
        ),
        child: Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              "assets/images/beryl_logo_clear.png",
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    ));
  }
}
