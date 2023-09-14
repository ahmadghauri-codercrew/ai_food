import 'package:ai_food/Utils/resources/res/app_assets.dart';
import 'package:ai_food/Utils/utils.dart';
import 'package:ai_food/View/NavigationBar/bottom_navigation.dart';
import 'package:ai_food/View/auth/auth_screen.dart';
import 'package:ai_food/config/keys/pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  // User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      getUserCredentials(context);
    });
    super.initState();
  }
  void getUserCredentials(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefKey.authorization);
    print("auth_token $token");
    if (token != null && token.isNotEmpty) {
      pushReplacement(context, BottomNavView());
    } else {
      pushReplacement(context, const AuthScreen());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2CFEB),
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(
            begin: 50.0,
            end: 500.0,
          ),
          duration: const Duration(seconds: 3),
          curve: Curves.easeInToLinear,
          builder: (context, val, child) {
            return SizedBox(
              width: val,
              height: val,
              child: Image.asset(AppAssetsImages.appLogo),
            );
          },
        ),
      ),
    );
  }
}