import 'package:ai_food/Model/auth_methods.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/utils.dart';
import 'package:ai_food/Utils/widgets/others/app_button.dart';
import 'package:ai_food/Utils/widgets/others/app_field.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/Utils/widgets/others/custom_card.dart';
import 'package:ai_food/View/auth/otp_screen.dart';
import 'package:ai_food/View/auth/set_password_screen.dart';
import 'package:ai_food/config/app_urls.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/app_logger.dart';
import '../../Utils/widgets/others/custom_app_bar.dart';
import '../../config/dio/app_dio.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _textController = TextEditingController();
  bool _verificationInProgress = false;
  String? verificationIdCheck;
  final _formKey = GlobalKey<FormState>();

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

  void resetYourPassword(String controller) async {
    setState(() {
      _verificationInProgress = true;
    });
    String res = await AuthMethods().forgotPassword(
      sendEmail: controller,
    );

    if (res == 'success') {
      showSnackBar(context, res);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reset Password'),
            content:
                const Text('Kindly check your email to reset your password!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SetPasswordSreen())),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        _verificationInProgress = false;
      });
    } else {
      if (controller.isEmpty) {
        showSnackBar(context, "Email Address cannot be Empty!");
        setState(() {
          _verificationInProgress = false;
        });
      }
      // reg expression for email validation
      else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
          .hasMatch(controller)) {
        showSnackBar(context, "Please Enter a valid Email");
        setState(() {
          _verificationInProgress = false;
        });
      } else if (controller != FirebaseAuth.instance) {
        showSnackBar(context, "Email doesn't exist!");
        setState(() {
          _verificationInProgress = false;
        });
      }
      print('Error!');
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText("Forgot Password",
                          fontSize: 32,
                          textColor: AppTheme.appColor,
                          fontWeight: FontWeight.w600),
                      AppText.appText("Enter email or number",
                          fontSize: 16,
                          textColor: AppTheme.appColor,
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Customcard(
                                childWidget: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                ),
                                CustomAppFormField(
                                  onTap: () {
                                    _formKey.currentState!.reset();
                                    forgetPassword(
                                        emailController: _textController);
                                  },
                                  texthint: "Email or Mobile number",
                                  hintStyle: TextStyle(
                                      color: AppTheme.appColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  controller: _textController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your email or mobile number";
                                    }
                                    final isEmailValid = RegExp(
                                            r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]')
                                        .hasMatch(value);
                                    final isMobileValid =
                                        RegExp(r'^\d{10}$').hasMatch(value);

                                    if (!isEmailValid && !isMobileValid) {
                                      return "Please enter a valid email or mobile number";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .330,
                                ),
                                _verificationInProgress
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppTheme.appColor,
                                          strokeWidth: 4,
                                        ),
                                      )
                                    : AppButton.appButton("Send OTP",
                                        onTap: () {
                                        String inputText =
                                            _textController.text.trim();
                                        final emailRegExp = RegExp(
                                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

                                        if (_formKey.currentState!.validate()) {
                                          if (emailRegExp.hasMatch(inputText)) {
                                            resetYourPassword(inputText);
                                          } else {
                                            if (!_verificationInProgress) {
                                              if (inputText.isNotEmpty) {
                                                _verifyPhoneNumber(inputText);
                                              }
                                            }
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  forgetPassword({emailController}) async {
    final url = AppUrls.baseUrl + AppUrls.forgetPasswordUrl;
    final dio =
        Dio(); // Assuming you have imported and configured Dio properly.
    try {
      final response = await dio.post(
        url,
        data: emailController,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success') {
          showSnackBar(context, responseData['message']);
        } else {
          print("API Error: ${responseData['message']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print(
              "Dio Error: ${e.response?.statusCode} - ${e.response!.statusMessage}");
          print("Response Data: ${e.response!.data}");
        } else {
          print("Dio Error: ${e.message}");
        }
      } else {
        print("Generic Error: $e");
      }

      showSnackBar(context, "An error occurred: $e");
    }
  }
}

//   forgetPassword({emailController}) async {
//     final url = AppUrls.baseUrl + AppUrls.forgetPasswordUrl;
//     final response;
//     try {
//       response = await dio.post(
//         path: url,
//         data: emailController,
//       );
//       print(response['status']);
//       if (response.statusCode == 200) {
//         showSnackBar(context, "${response[1]['message']}");
//         print(response['status']);
//       } else {
//         print("error${response['status']}");
//       }
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       print(e.toString());
//     }
//   }
// }
