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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/app_logger.dart';
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
  bool isLoading = false;

  String errormessageLoginsEmail = "";
  bool hintTextColorCondition = false;
  bool hintTextColor2Condition = false;

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
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
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.appText("Forgot Password",
                      fontSize: 32,
                      textColor: AppTheme.appColor,
                      fontWeight: FontWeight.w600),
                  AppText.appText("Enter email",
                      fontSize: 16,
                      textColor: AppTheme.appColor,
                      fontWeight: FontWeight.w600),
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Customcard(
                        childWidget: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: Form(
                            key: _formKey,
                            child: CustomAppFormField(
                                onChanged: (value) {
                                  setState(() {
                                    hintTextColor2Condition = false;
                                    errormessageLoginsEmail = "";

                                  });},

                                errorText: errormessageLoginsEmail,
                                errorStyle: TextStyle(
                                  color: hintTextColor2Condition == false
                                      ? AppTheme.appColor
                                      : Colors.red,
                                ),
                                focusedErrorBorder:
                                UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: hintTextColor2Condition == false
                                          ? AppTheme.appColor
                                          : Colors.red,
                                    )),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                    hintTextColor2Condition == false
                                        ? AppTheme.appColor
                                        : Colors.red,
                                  ),
                                ),

                                texthint: "Enter email",
                                cursorColor:
                                hintTextColor2Condition == false
                                    ? AppTheme.appColor
                                    : Colors.red,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.appColor
                                      .withOpacity(0.6),
                                ),
                                controller: _textController),
                          ),
                        ),
                        _verificationInProgress || isLoading == true
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator(
                                  color: AppTheme.appColor,
                                  strokeWidth: 4,
                                ),
                              )
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: AppButton.appButton("Send OTP",
                                    onTap: () {
                                  String inputText =
                                      _textController.text.trim();
                                  final emailRegExp = RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

                                  if (_formKey.currentState!.validate()) {
                                    if(_textController.text.isNotEmpty){
                                      forgetPassword(text: inputText);
                                    }
                                    else{
                                      setState(() {
                                        errormessageLoginsEmail= "Enter email";
                                        hintTextColor2Condition=  true;

                                      });
                                    }
                                  }
                                },
                                    width: 44.w,
                                    height: 40,
                                    border: false,
                                    blurContainer: true,
                                    backgroundColor: AppTheme.appColor,
                                    textColor: AppTheme.whiteColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600))
                      ],
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void forgetPassword({text}) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> params = {
      "email": text,
    };

    final response =
        await dio.post(path: AppUrls.forgetPasswordUrl, data: params);

    if (response.statusCode == 200) {
      var responseData = response.data;

      if (responseData["status"] == false) {
        setState(() {
          isLoading = false;
        });
        String responsemessage = responseData["message"];
        print("jidmaosmdo${responsemessage}");
        String errormessageconst = "The selected email is invalid.";
        String errormessageconst2 = "The email must be a valid email address.";
        if (responsemessage == errormessageconst || responsemessage == errormessageconst2) {
          setState(() {
            errormessageLoginsEmail = responseData["messsage"] ?? "Invalid email";
            hintTextColor2Condition = true;
          });
        }
        return;
      } else {
        showSnackBar(context, "Reset password OTP has been sent to your email");
        setState(() {
          isLoading = false;
        });
        pushReplacement(
            context,
            OTPScreen(
              email: text,
            ));
      }
    } else {
      if (response.statusCode == 402) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "${response.statusMessage}");
      } else {
        setState(() {
          isLoading = false;
        });
        print('API request failed with status code: ${response.statusCode}');
        showSnackBar(context, "${response.statusMessage}");
      }
    }
  }
}
