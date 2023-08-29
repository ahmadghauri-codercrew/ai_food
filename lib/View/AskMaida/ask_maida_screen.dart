import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:flutter/material.dart';
class AskMaidaScreen extends StatefulWidget {
  const AskMaidaScreen({super.key});

  @override
  State<AskMaidaScreen> createState() => _AskMaidaScreenState();
}

class _AskMaidaScreenState extends State<AskMaidaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText.appText("AskMAida", fontSize: 40),
      ),
    );
  }
}