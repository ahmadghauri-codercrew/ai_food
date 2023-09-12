import 'package:ai_food/Constants/app_logger.dart';
import 'package:ai_food/Utils/resources/res/app_assets.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/utils.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/View/recipe_info/recipe_info.dart';
import 'package:ai_food/config/dio/app_dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  final allergies;
  final dietaryRestrictions;
  final type;

  const FavouriteScreen(
      {super.key, this.allergies, this.dietaryRestrictions, this.type});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  var responseData;
  int type = 0;
  bool isLoading = false;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();

    if (widget.type == 1) {
      type = widget.type;
    } else {
      print("bsjbdbd22222$type");

      getSuggestedRecipes(
        allergies: widget.allergies,
        dietaryRestrictions: widget.dietaryRestrictions,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: AppText.appText("Favourite Recipes",
              fontSize: 24,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.appColor)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: width / (2.26 * 238),
              ),
              shrinkWrap: true,
              itemCount: 100,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => RecipeInfo(
                    //     recipeData: responseData[index],
                    //   ),
                    // ));
                  },
                  child: Container(
                    width: width / 2.26,
                    height: 238,
                    decoration: BoxDecoration(
                      color: AppTheme.appColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 8),
                              child: Center(
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // color: AppTheme.appColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: AppTheme.appColor,
                                            // color: AppTheme.appColor,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.favorite,
                                              color: AppTheme.whiteColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // child: ClipRRect(
                                //   borderRadius: BorderRadius.circular(10),
                                //   // child: CachedNetworkImage(
                                //   //   fit: BoxFit.cover,
                                //   //   // imageUrl: "${responseData[index]["image"]}",
                                //   //   imageUrl: AppAssetsImages.appLogo,
                                //   //   height: 130,
                                //   //   width: width,
                                //   //   errorWidget: (context, url, error) =>
                                //   //       const Icon(Icons.error),
                                //   // ),
                                // ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: AppText.appText("hello",
                                // "${responseData[index]["title"]}",
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
    );
  }

  getSuggestedRecipes({allergies, dietaryRestrictions}) async {
    const apiKey = 'd9186e5f351240e094658382be62d948';

    final allergiesAre =
        allergies.isNotEmpty ? "${allergies.join(',').toLowerCase()}" : "";
    final dietaryRestrictionsAre = dietaryRestrictions.isNotEmpty
        ? "${dietaryRestrictions.join(',').toLowerCase()}"
        : "";
    String apiFinalUrl;
    if (allergies.isEmpty && dietaryRestrictions.isNotEmpty) {
      apiFinalUrl =
          'https://api.spoonacular.com/recipes/random?number=8&tags=${dietaryRestrictionsAre}&apiKey=$apiKey';
    } else if (allergies.isNotEmpty && dietaryRestrictions.isEmpty) {
      apiFinalUrl =
          'https://api.spoonacular.com/recipes/random?number=8&tags=${allergiesAre}&apiKey=$apiKey';
    } else if (allergies.isNotEmpty && dietaryRestrictions.isNotEmpty) {
      apiFinalUrl =
          'https://api.spoonacular.com/recipes/random?number=8&tags=${allergiesAre},${dietaryRestrictionsAre}&apiKey=$apiKey';
    } else {
      apiFinalUrl =
          'https://api.spoonacular.com/recipes/random?number=8&apiKey=$apiKey';
    }
    try {
      var response;
      response = await dio.get(path: apiFinalUrl);
      if (response.statusCode == 200) {
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
