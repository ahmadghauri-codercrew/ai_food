import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/View/auth/GoogleSignIn/authentication.dart';
import 'package:ai_food/providers/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Utils/widgets/others/app_button.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    final googleSignInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: googleSignInProvider.isSigningIn
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffB38ADE)),
              ),
            )
          : Center(
              child: AppButton.appButtonWithLeadingImage(
                "Continue with Google",
                onTap: () async {
                  googleSignInProvider.setSigningIn(true);
                  try {
                    await Authentication.initializeFirebase(context: context);
                    await Authentication.signInWithGoogle(context: context);
                    googleSignInProvider.setSigningIn(false);
                  } catch (e) {
                    googleSignInProvider.setSigningIn(false);
                    print("fbjkbfjeblfbekb$e");
                  }
                },
                fontSize: 20,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.appColor,
                height: 48,
                imagePath: "assets/images/google_logo.png",
              ),
            ),
    );
  }
}
