import 'package:ai_food/Constants/apikey.dart';
import 'package:ai_food/Constants/app_logger.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/utils.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/View/recipe_info/recipe_info.dart';
import 'package:ai_food/config/app_urls.dart';
import 'package:ai_food/config/dio/app_dio.dart';
import 'package:ai_food/config/dio/spoonacular_app_dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class resultContainer extends StatefulWidget {
  final data;
  final apiRecipeId;

  const resultContainer({super.key, this.data, required this.apiRecipeId});

  @override
  State<resultContainer> createState() => _resultContainerState();
}

class _resultContainerState extends State<resultContainer> {
  late AppDio dio;
  late SpoonAcularAppDio spoonDio;
  AppLogger logger = AppLogger();
  bool seeDetails = false;

  @override
  void initState() {
    dio = AppDio(context);
    spoonDio = SpoonAcularAppDio(context);

    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2.26,
      height: 225,
      decoration: BoxDecoration(
        color: AppTheme.appColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "${widget.data['image']}",
                      height: 130,
                      width: width,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: AppText.appText("${widget.data['title']}",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  textColor: AppTheme.whiteColor,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            seeDetails == false
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        seeDetails = true;
                      });
                      var inputString = widget.data['link'];

                      RegExp urlRegex = RegExp(
                          r'https:\/\/spoonacular\.com\/recipes\/(.+)-(\d+)');

                      final match = urlRegex.firstMatch(inputString);

                      if (match != null) {
                        String? substring = match.group(1);
                        String? digits = match.group(2);
                        getRecipeInformation(id: digits,link: inputString);

                        print("Substring: $substring");
                        print("Digits: $digits");
                      } else {
                        print("No match found");
                      }
                    },
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppTheme.whiteColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText(
                              "See details",
                              textColor: AppTheme.appColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.appColor,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.whiteColor),
                  )
          ],
        ),
      ),
    );
  }

  getRecipeInformation({id,link}) async {
    var response;
    var url =
        "${AppUrls.spoonacularBaseUrl}/recipes/$id/information?includeNutrition=false&apiKey=$apiKey";
    var url2 =
        "${AppUrls.spoonacularBaseUrl}/recipes/$id/information?includeNutrition=false&apiKey=$apiKey2";
     response = await spoonDio.get(path: url);

    if (response.statusCode == 200) {
      setState(() {
        seeDetails = false;
      });
      final idAsInt = int.tryParse(id.toString());
      final bool isFav = widget.apiRecipeId!.contains(idAsInt);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RecipeInfo(
          recipeData: response.data,
          isFav: isFav ? 1 : 0,
          urlLinkFromAskMaida : link,
        ),
      ));
    } else if (response.statusCode == 402) {
       response = await spoonDio.get(path: url2);
       if(response.statusCode == 402){
         setState(() {
           seeDetails = false;
         });
         showSnackBar(context, "402");
         setState(() {
           seeDetails = false;
         });
       }else{
         setState(() {
           seeDetails = false;
         });
         final idAsInt = int.tryParse(id.toString());
         final bool isFav = widget.apiRecipeId!.contains(idAsInt);
         Navigator.of(context).push(MaterialPageRoute(
           builder: (context) => RecipeInfo(
             recipeData: response.data,
             isFav: isFav ? 1 : 0,
             urlLinkFromAskMaida : link,
           ),
         ));
       }

    } else {
      print('API request failed with status code: ${response.statusCode}');
    }
  }
}
