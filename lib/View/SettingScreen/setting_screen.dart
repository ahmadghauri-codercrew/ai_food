import 'dart:io';

import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/Utils/widgets/others/custom_app_bar.dart';
import 'package:ai_food/View/SettingScreen/privacypolicy_screen.dart';
import 'package:ai_food/View/SettingScreen/profile_screen.dart';
import 'package:ai_food/View/SettingScreen/termsofuse_screen.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        backgroundColor: AppTheme.whiteColor,
        centerTitle: true,
        elevation: 5,
        titleText: "Settings",
        titleTextStyle: TextStyle(fontFamily: "Roboto",color: AppTheme.appColor, fontSize: 24),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        child: Column(children: [
          const SizedBox(height: 30),
          GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(),)),
            child: Row(
              children: [
                Icon(Icons.account_circle_outlined,
                    size: 20, color: AppTheme.appColor),
                SizedBox(width: 2.w),
                AppText.appText("Profile",
                    fontSize: 20, textColor: AppTheme.appColor),
              ],
            ),
          ),
          Divider(height: 3.h,color: AppTheme.appColor,thickness: 1.5,),
          GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),)),
            child: Row(
              children: [
                Icon(Icons.privacy_tip_outlined,
                    size: 20, color: AppTheme.appColor),
                SizedBox(width: 2.w),
                AppText.appText("Privacy Policy",
                    fontSize: 20, textColor: AppTheme.appColor),
              ],
            ),
          ),
          Divider(height: 3.h,color: AppTheme.appColor,thickness: 1.5,),
          GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsScreen(),)),
            child: Row(
              children: [
                Image(image: AssetImage("assets/images/Vector.png"),width: 18,height: 18),
                SizedBox(width: 2.w),
                AppText.appText("Terms of Use",
                    fontSize: 20, textColor: AppTheme.appColor),
              ],
            ),
          ),
          Divider(height: 3.h,color: AppTheme.appColor,thickness: 1.5,),
          Row(
            children: [
              Image(image: AssetImage("assets/images/headset.png"),width: 18,height: 18),
              SizedBox(width: 2.w),
              AppText.appText("Contact Us",
                  fontSize: 20, textColor: AppTheme.appColor),
            ],
          ),
          Divider(height: 3.h,color: AppTheme.appColor,thickness: 1.5,),
          Row(
            children: [
              Icon(Icons.logout,
                  size: 20, color: AppTheme.appColor),
              SizedBox(width: 2.w),
              AppText.appText("Log out",
                  fontSize: 20, textColor: AppTheme.appColor),
            ],
          ),
          Divider(height: 3.h,color: AppTheme.appColor,thickness: 1.5,),

        ]),
      ),
    );
  }
}
