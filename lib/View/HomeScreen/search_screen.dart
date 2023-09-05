import 'package:ai_food/Constants/app_logger.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/utils.dart';
import 'package:ai_food/Utils/widgets/others/app_button.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/View/HomeScreen/home_screen.dart';
import 'package:ai_food/View/HomeScreen/recipe_params_screen.dart';
import 'package:ai_food/View/NavigationBar/bottom_navigation.dart';
import 'package:ai_food/config/dio/app_dio.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final TextEditingController _searchController = TextEditingController();
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              bottom: 10,
              top: 10,
            ),
            child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: AppTheme.appColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.arrow_back_ios,
                      size: 20, color: AppTheme.whiteColor),
                )),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
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
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    push(context, const RecipeParamScreen());
                  },
                  child: Container(
                      width: 180,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppTheme.appColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: AppTheme.whiteColor,
                            ),
                            AppText.appText(
                              "Advanced Search",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: AppTheme.whiteColor,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getFood() async {
    var searchtext = _searchController.text;
    const apiKey = 'd9186e5f351240e094658382be62d948';

    final apiUrl =
        'https://api.spoonacular.com/recipes/complexSearch?query=$searchtext&apiKey=$apiKey';

    final response = await dio.get(path: apiUrl);

    if (response.statusCode == 200) {
      pushReplacement(
          context,
          BottomNavView(
            type: 1,
            data: response.data["results"],
          ));
      _searchController.clear();
    } else {
      print('API request failed with status code: ${response.statusCode}');
    }
  }
}
