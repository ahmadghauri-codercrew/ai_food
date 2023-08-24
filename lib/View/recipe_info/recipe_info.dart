import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/Utils/widgets/others/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecipeInfo extends StatefulWidget {
  const RecipeInfo({super.key});

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    AppText.appText("Preparation",
        textColor: AppTheme.appColor,
        fontSize: 16,
        fontWeight: FontWeight.w600),
    AppText.appText("Ingredients",
        textColor: AppTheme.appColor,
        fontSize: 16,
        fontWeight: FontWeight.w600),
    AppText.appText("Links",
        textColor: AppTheme.appColor,
        fontSize: 16,
        fontWeight: FontWeight.w600),
  ];

  final List<Widget> _tabViews = [
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 30,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText("${index + 1}.", fontSize: 14),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: AppText.appText(
                              "befjbjebfjelkrgrg;gi3ighi5hgpi5hgihibgiiorigbrigibiogrgbigbriogbiorbgibriggoigbiiojbf")),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    ),
    Center(child: Text('Tab 2 content')),
    Center(child: Text('Tab 3 content')),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: AppTheme.appColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.arrow_back_ios, color: AppTheme.whiteColor),
                )),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("Recipe Name",
                      textColor: AppTheme.appColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                  Row(
                    children: [
                      Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: AppTheme.appColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: Icon(Icons.shopping_cart_outlined,
                              color: AppTheme.whiteColor)),
                      SizedBox(width: 10),
                      Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: AppTheme.appColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: Icon(Icons.favorite_border_outlined,
                              color: AppTheme.whiteColor)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 400,
              width: screenWidth,
              child: Stack(children: [
                Positioned(
                  top: 100,
                  child: Container(
                    height: 270,
                    width: 55.w,
                    decoration: BoxDecoration(
                        color: AppTheme.appColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 60,
                  child: Container(
                    height: 250,
                    width: 70.w,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/logo.png"))),
                  ),
                ),
                Positioned(
                    top: 320,
                    left: 65.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.punch_clock,
                              color: AppTheme.appColor,
                            ),
                            const SizedBox(
                              width: 5, 
                            ),
                            AppText.appText("25-30 min",
                                textColor: AppTheme.appColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              color: AppTheme.appColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            AppText.appText("2-3 Persons",
                                textColor: AppTheme.appColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)
                          ],
                        )
                      ],
                    )),
              ]),
            ),
            Container(
              height: 350,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: AppTheme.appColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs,
                    controller: _tabController,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _tabViews,
                      controller: _tabController,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
