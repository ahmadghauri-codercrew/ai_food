import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/widgets/others/app_button.dart';
import 'package:ai_food/Utils/widgets/others/app_card_background.dart';
import 'package:ai_food/Utils/widgets/others/app_field.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/Utils/widgets/others/custom_card.dart';
import 'package:ai_food/View/auth/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Utils/widgets/others/custom_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneNumberController = TextEditingController();
  bool _verificationInProgress = false;
  String? verificationIdCheck;
  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      _verificationInProgress = true;
    });

    verificationCompleted(AuthCredential phoneAuthCredential) {
      setState(() {
        _verificationInProgress = false;
      });

      FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((userCredential) {
        setState(() {
          _verificationInProgress = false;
        });
      });
    }

    verificationFailed(FirebaseAuthException authException) {
      setState(() {
        _verificationInProgress = false;
      });
      print("exception_code ${authException.code}");
      print("exception_message ${authException.message}");
      if (authException.code == 'invalid-phone-number' &&
          authException.message!.contains('TOO_SHORT')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Phone number is Invalid. It is TOO SHORT'),
        ));
      } else if (authException.code == 'invalid-phone-number' &&
          authException.message!.contains('TOO_LONG')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Phone number is Invalid. It is TOO LONG'),
        ));
      } else if (authException.code == 'missing-client-identifier') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid captcha. Try again.'),
        ));
      } else if (authException.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'You have been blocked due to unusual activity. Try again later.'),
        ));
      } else if (authException.code == 'quota-exceeded') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The SMS quota for the project has been exceeded.'),
        ));
      } else if (authException.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('The user account has been disabled by an administrator.'),
        ));
      } else if (authException.code == 'invalid-phone-number') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter the phone number in correct format.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${authException.message}'),
        ));
      }
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      setState(() {
        verificationIdCheck = verificationId;
        _verificationInProgress = false;
        print(
            "Check_phone $phoneNumber and verification id $verificationIdCheck");
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification code sent to $phoneNumber'),
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => OTPScreen(
              verificationId: verificationId, mobileNumber: phoneNumber)));
    }

    codeAutoRetrievalTimeout(String verificationId) {
      setState(() {
        verificationIdCheck = verificationId;
        print(
            "Check_phone $phoneNumber and verification id $verificationIdCheck");
      });
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 80),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (error) {
      setState(() {
        _verificationInProgress = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar.appBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                ),
                Icon(Icons.arrow_back_ios, color: AppTheme.appColor),
                AppText.appText(
                  "Back",
                  underLine: true,
                  textColor: AppTheme.appColor,
                  fontSize: 20,
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leadingWidth: screenWidth),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.appText("Forgot Password",
                  fontSize: 25.sp,
                  textColor: AppTheme.appColor,
                  fontWeight: FontWeight.w600),
              AppText.appText(
                "Enter email or number",
                fontSize: 12.sp,
                textColor: AppTheme.appColor,
              ),
              const SizedBox(
                height: 60,
              ),
              Customcard(
                  childWidget: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  CustomAppFormField(
                      texthint: "Email or Mobile number",
                      controller: _phoneNumberController),
                  const SizedBox(
                    height: 190,
                  ),
                  _verificationInProgress
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.appColor,
                            strokeWidth: 4,
                          ),
                        )
                      : AppButton.appButton("Send OTP", onTap: () {
                          if (!_verificationInProgress) {
                            String phoneNumber =
                                _phoneNumberController.text.trim();
                            if (phoneNumber.isNotEmpty) {
                              print(
                                  "Check_phone ${phoneNumber} and verification id $verificationIdCheck");
                              _verifyPhoneNumber(phoneNumber);
                            }
                          }
                        },
                          width: 43.w,
                          height: 5.5.h,
                          border: false,
                          backgroundColor: AppTheme.appColor,
                          textColor: AppTheme.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600)
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
