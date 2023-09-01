import 'package:ai_food/Controller/provider/login_provider.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/widgets/others/app_button.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/View/HomeScreen/filters_screen.dart';
import 'package:ai_food/View/profile/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class SearchRecipesScreen extends StatefulWidget {
  const SearchRecipesScreen({Key? key}) : super(key: key);

  @override
  State<SearchRecipesScreen> createState() => _SearchRecipesScreenState();
}

class _SearchRecipesScreenState extends State<SearchRecipesScreen> {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final TextEditingController _searchController = TextEditingController();
  bool showFoodStyle = false;
  bool showServingSize = false;

  List foodStyle = [
    'Italian cuisine',
    'Mexican cuisine',
    'Greek cuisine',
    'Spanish cuisine',
    'Indian cuisine',
    'Japanese cuisine',
    'American cuisine',
    'Turkish cuisine',
    'French cuisine',
    'Chinese cuisine',
    'Brazilian cuisine',
    'Thai cuisine',
  ];
  List<String> addFoodStyle = [];
//ends of food style

//start serving size
  List servingSize = [
    '1-2 Persons',
    '2-3 Persons',
    '3-4 Persons',
    '4-5 Persons',
    '5-6 Persons',
    '6+ Persons',
  ];
  List<String> addServingSize = [];
//ends of serving size
  @override
  void initState() {
    print("Usama is a pro developer ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final provider = Provider.of<FilterListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xffd9c4ef),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: width * 0.65,
                  child: TextFormField(
                    controller: _searchController,
                    autofocus: true,
                    cursorColor: AppTheme.appColor,
                    style: TextStyle(color: AppTheme.appColor),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: AppTheme.whiteColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a recipe';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.disabled;
                      });
                    },
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xffb38ade),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100)),
                ),
                child: const Icon(Icons.search_outlined, size: 40),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              AppText.appText(
                "Food Choices:",
                fontSize: 22,
                fontWeight: FontWeight.w800,
                textColor: AppTheme.appColor,
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showFoodStyle = !showFoodStyle;
                          showServingSize = false;
                          setState(() {});
                        },
                        child: Container(
                          height: 55,
                          width: 227,
                          decoration: BoxDecoration(
                              // color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: AppTheme.appColor, width: 2)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.appText(
                                    addFoodStyle.isEmpty
                                        ? "Food Style"
                                        : addFoodStyle[0].toString(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppTheme.appColor),
                                !showFoodStyle
                                    ? Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: AppTheme.appColor,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        color: AppTheme.appColor,
                                        size: 30,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          showServingSize = !showServingSize;
                          showFoodStyle = false;
                          setState(() {});
                        },
                        child: Container(
                          height: 55,
                          width: 227,
                          decoration: BoxDecoration(
                              // color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: AppTheme.appColor, width: 2)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.appText(
                                    addServingSize.isEmpty
                                        ? "Serving Size"
                                        : addServingSize[0].toString(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppTheme.appColor),
                                !showServingSize
                                    ? Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: AppTheme.appColor,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        color: AppTheme.appColor,
                                        size: 30,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      customFilterRow(name: "Allergies", index: 0),
                      const SizedBox(
                        height: 20,
                      ),
                      customFilterRow(name: "Dietry restrictions", index: 1),
                      const SizedBox(
                        height: 20,
                      ),
                      customFilterRow(name: "Preffered Protein", index: 2),
                      const SizedBox(
                        height: 20,
                      ),
                      customFilterRow(name: "Regional delicacy", index: 3),
                      const SizedBox(
                        height: 20,
                      ),
                      customFilterRow(name: "Kitchen resources", index: 4)
                    ],
                  ),
                  showServingSize
                      ? Padding(
                          padding: const EdgeInsets.only(top: 123.0),
                          child: customServingSize(),
                        )
                      : const SizedBox.shrink(),
                  showFoodStyle
                      ? Padding(
                          padding: const EdgeInsets.only(top: 55.0),
                          child: customFoodStyle(),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: AppButton.appButton(
                  "Generate",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  textColor: Colors.white,
                  height: 50,
                  width: 180,
                  backgroundColor: AppTheme.appColor,
                  onTap: () {
                    provider.dellAllergy();
                  },
                ),
              ),

              Container(
                height: 200,
                color: Colors.amber,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    final provider =
                        Provider.of<FilterListProvider>(context, listen: true);

                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          AppText.appText("${provider.addAllergies}",
                              textColor: AppTheme.appColor, fontSize: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          AppText.appText("${provider.addDietaryRestrictions}",
                              textColor: AppTheme.appColor, fontSize: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          AppText.appText("${provider.addPreferredProtein}",
                              textColor: AppTheme.appColor, fontSize: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          AppText.appText("${provider.addRegionalDelicacy}",
                              textColor: AppTheme.appColor, fontSize: 20),
                          const SizedBox(
                            height: 20,
                          ),
                          AppText.appText("${provider.addKitchenResources}",
                              textColor: AppTheme.appColor, fontSize: 20),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customFoodStyle() {
    return Card(
      color: AppTheme.appColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        child: SizedBox(
          width: 227,
          height: 260,
          child: GestureDetector(
            onTap: () {
              // This handles the tap outside the list
              setState(() {
                showFoodStyle = false;
              });
            },
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: foodStyle.length,
              itemBuilder: (context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      showFoodStyle = false;
                      addFoodStyle.insert(0, foodStyle[index]);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.appColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppText.appText(
                          "${foodStyle[index]}",
                          fontSize: 18,
                          textColor: AppTheme.whiteColor,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2.0,
                                color: AppTheme.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customServingSize() {
    return Card(
      color: AppTheme.appColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        child: SizedBox(
          width: 227,
          height: 260,
          child: GestureDetector(
            onTap: () {
              // This handles the tap outside the list
              setState(() {
                showFoodStyle = false;
              });
            },
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: servingSize.length,
              itemBuilder: (context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      showServingSize = false;
                      addServingSize.insert(0, servingSize[index]);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.appColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppText.appText(
                          "${servingSize[index]}",
                          fontSize: 18,
                          textColor: AppTheme.whiteColor,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2.0,
                                color: AppTheme.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customFilterRow({name, index}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FilterScreen(
            index: index,
          ),
        ));
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            // color: Colors.redAccent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppTheme.appColor, width: 2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("$name",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.appColor),
              Icon(
                Icons.keyboard_arrow_right,
                color: AppTheme.appColor,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
