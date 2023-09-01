import 'package:ai_food/Constants/app_logger.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/utils.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/View/HomeScreen/search_recipes_screen.dart';
import 'package:ai_food/View/recipe_info/recipe_info.dart';
import 'package:ai_food/config/dio/app_dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final responseData;
  const HomeScreen({Key? key, this.responseData}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  var responseData;
  bool loading = false;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getSuggestedRecipes();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            push(context, const SearchRecipesScreen());
          },
          child: Container(
            width: width,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xffd9c4ef),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Search",
                    style: TextStyle(fontSize: 16),
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
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: width,
        // color: Colors.blueGrey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppText.appText("Recommended:",
                  fontSize: 20, textColor: AppTheme.appColor),
              responseData == null
                  // ? SizedBox()
                  ? Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.appColor,
                        ),
                      ),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        childAspectRatio:
                            width / (2.26 * 238), // Width-to-height ratio
                      ),
                      shrinkWrap: true,
                      itemCount: responseData.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RecipeInfo(
                                recipeData: responseData[index],
                              ),
                            ));
                          },
                          child: Container(
                            width: width / 2.26,
                            height: 238,
                            decoration: BoxDecoration(
                              color: AppTheme.appColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 8),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "${responseData[index]["image"]}",
                                            height: 130,
                                            width: width,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: AppText.appText(
                                        "${responseData[index]["title"]}",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        textColor: AppTheme.whiteColor,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    textAlign: TextAlign.justify,
                                    maxLines: 3,
                                    "This is Product. This is Product. This is Product. This is Product. This is Product.",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppTheme.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  getSuggestedRecipes({allergies, context}) async {
    const apiKey = 'd9186e5f351240e094658382be62d948';
    final apiUrl =
        'https://api.spoonacular.com/recipes/random?number=8&intolerances=$allergies&apiKey=$apiKey';

    loading = true;

    try {
      var response;
      response = await dio.get(path: apiUrl);
      if (response.statusCode == 200) {
        print("jfdjbjeb${responseData}");
        loading = false;
        setState(() {
          responseData = response.data["recipes"];
        });
      } else {
        showSnackBar(context, "Something Went Wrong!");
      }
    } catch (e) {
      print(e);
    }
  }
}
