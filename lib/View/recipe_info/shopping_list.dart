import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Utils/resources/res/app_theme.dart';
import '../../Utils/widgets/others/app_text.dart';

class ShoppingList extends StatefulWidget {
  final ingredient;
  final String image;
  final name;
  const ShoppingList(
      {super.key, this.ingredient, required this.image, this.name});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.arrow_back_ios,
                      size: 20, color: AppTheme.whiteColor),
                )),
          ),
        ),
        title: AppText.appText(
          "Shopping List",
          textColor: AppTheme.appColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var screenHeight = constraints.maxHeight;
        var screenWidth = constraints.maxWidth;

        return Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    height: 210,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        image: DecorationImage(
                            image: NetworkImage("${widget.image}"),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    top: 10,
                    child: Container(
                      height: 500,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppTheme.appColor, width: 2),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(70)),
                          color: Colors.amber),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 25, right: 40),
                        child: Column(
                          children: [
                            SizedBox(
                              width: screenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.appText("${widget.name} Ingredients",
                                      textColor: AppTheme.appColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppText.appText(
                                      "Gather these components for culinary excellence",
                                      textColor: AppTheme.appColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
