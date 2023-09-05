import 'package:ai_food/Utils/widgets/others/contact_us_pop_up.dart';
import 'package:ai_food/Utils/widgets/others/custom_logout_pop_up.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              showCustomAlert(context);
            },
            child: Text("Click")),
      ),
    );
  }
}
