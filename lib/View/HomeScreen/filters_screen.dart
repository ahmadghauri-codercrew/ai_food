import 'package:ai_food/Controller/provider/login_provider.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/View/profile/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  final index;
  const FilterScreen({super.key, this.index});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

//ends of Kitchen Resources

class _FilterScreenState extends State<FilterScreen> {
  int? count;

//start of allergies
  List allergies = [
    "Dairy",
    "Peanut",
    "Seafood",
    "Sesame",
    "Wheat",
    "Soy",
    "Sulfite",
    "Gluten",
    "Egg",
    "Grain",
    "Tree nut",
    "Shellfish",
  ];
//ends of allergies
//start of dietary Restrictions
  List dietaryRestrictions = [
    "Gluten free",
    "ketogenic",
    "Vegetarian",
    "Lacto-Vegetarian",
    "Ovo-Vegetarian",
    "Vegan",
    "Pescetarian",
    "Paleo",
    "Primal",
    "Low FODMAP",
    "Whole30",
    "Shellfish",
  ];
//ends of dietary Restrictions

//start of Preferred Protein
  List<String> preferredProtein = [
    "Fish",
    "Seafood",
    "Lean beef",
    "Skim milk",
    "Skim yogurt",
    "Eggs",
    "Lean port",
    "Low-fat cheese",
    "Beans",
    "Skinless, white meat-poultry",
  ];
//ends of Preferred Protein

//start of Regional Delicacy
  List<String> regionalDelicacy = [
    'Italian Pizza',
    'Mexican Tacos',
    'Japanese Sushi',
    'Chinese Dumplings',
    'Indian Curry',
    'French Baguette',
    'Italian Pasta',
    'Thai Pad Thai',
    'Greek Souvlaki',
    'American Burger',
  ];
//ends of Regional Delicacy

//start of Kitchen Resources
  List<String> kitchenResources = [
    'Blender',
    'Colander',
    'Chef\'s knife',
    'Cutting board',
    'Frying pan',
    'Knife',
    'Immersion blender',
    'Salad Spinner',
    'Peeler',
    'Parchment paper',
    'Stock pot',
    'Spoon',
    'Sheet pan',
    'Measuring cup',
    'Measuring spoon',
    'Whisk',
    'Tongs',
    'Wooden spoon',
    'Bowl',
    'Oven',
    'Microwave',
    'Food processor',
    'Slow cooker',
  ];

  @override
  void initState() {
    // TODO: implement initState
    count = widget.index;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FilterListProvider>(context, listen: false);
    print("jfvbjebfjbefb$count");
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(
                          count == 0
                              ? "Allergies"
                              : count == 1
                                  ? "Dietary Restrictions"
                                  : count == 2
                                      ? "Preffered Proteins"
                                      : count == 3
                                          ? "Regioanl Delicacy"
                                          : "Kitchen Resources",
                          textColor: AppTheme.whiteColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        height: 5,
                      ),
                      AppText.appText("Lorem ipsum is just dummy text",
                          textColor: AppTheme.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)
                    ],
                  )
                ],
              ),
            ),
            wrapFilters(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (count == 0) {
                      setState(() {
                        count = 1;
                      });
                    } else if (count == 1) {
                      setState(() {
                        count = 2;
                      });
                    } else if (count == 2) {
                      setState(() {
                        count = 3;
                      });
                    } else if (count == 3) {
                      setState(() {
                        count = 4;
                      });
                    } else if (count == 4) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppTheme.appColor,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget wrapFilters() {
    final provider = Provider.of<FilterListProvider>(context, listen: true);

    return count == 0
        ? Wrap(
            runSpacing: 10,
            spacing: 10,
            children: allergies.map((allergy) {
              return CustomContainer(
                borderColor: AppTheme.whiteColor,
                containerColor: provider.addAllergies.contains(allergy)
                    ? AppTheme.whiteColor
                    : AppTheme.appColor,
                text: allergy,
                textColor: provider.addAllergies.contains(allergy)
                    ? AppTheme.appColor
                    : AppTheme.whiteColor,
                onTap: () {
                  if (provider.addAllergies.contains(allergy)) {
                    provider.removeAllergy(allergy);
                  } else if(!provider.addAllergies.contains(allergy)){
                    provider.addAllergy(allergy);
                  }
                },
              );
            }).toList(),
          )
        : count == 1
        ? Wrap(
            spacing: 10,
            runSpacing: 10,
            children: dietaryRestrictions.map((restriction) {
              return CustomContainer(
                borderColor: AppTheme.whiteColor,
                containerColor:
                    provider.addDietaryRestrictions.contains(restriction)
                        ? AppTheme.whiteColor
                        : AppTheme.appColor,
                textColor:
                    provider.addDietaryRestrictions.contains(restriction)
                        ? AppTheme.appColor
                        : AppTheme.whiteColor,
                text: restriction,
                onTap: () {
                  setState(() {
                    if (provider.addDietaryRestrictions
                        .contains(restriction)) {
                      provider.removeDietary(restriction);
                    } else {
                      provider.addDietary(restriction);
                    }
                  });
                },
              );
            }).toList(),
          )
        : count == 2
            ? Wrap(
                spacing: 10,
                runSpacing: 10,
                children: preferredProtein.map((protein) {
                  return CustomContainer(
                    borderColor: AppTheme.whiteColor,
                    containerColor:
                        provider.addPreferredProtein.contains(protein)
                            ? AppTheme.whiteColor
                            : AppTheme.appColor,
                    textColor:
                        provider.addPreferredProtein.contains(protein)
                            ? AppTheme.appColor
                            : AppTheme.whiteColor,
                    text: protein,
                    onTap: () {
                      setState(() {
                        if (provider.addPreferredProtein
                            .contains(protein)) {
                          provider.removeProteins(protein);
                        } else {
                          provider.addproteins(protein);
                        }
                      });
                    },
                  );
                }).toList(),
              )
            : count == 3
                ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: regionalDelicacy.map((delicacy) {
                      return CustomContainer(
                        borderColor: AppTheme.whiteColor,
                        containerColor:
                            provider.addRegionalDelicacy.contains(delicacy)
                                ? AppTheme.whiteColor
                                : AppTheme.appColor,
                        textColor:
                            provider.addRegionalDelicacy.contains(delicacy)
                                ? AppTheme.appColor
                                : AppTheme.whiteColor,
                        text: delicacy,
                        onTap: () {
                          setState(() {
                            if (provider.addRegionalDelicacy
                                .contains(delicacy)) {
                              provider.removeRegional(delicacy);
                            } else {
                              provider.addRegional(delicacy);
                            }
                          });
                        },
                      );
                    }).toList(),
                  )
                : count == 4
                    ? Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: kitchenResources.map((resources) {
                          return CustomContainer(
                            borderColor: AppTheme.whiteColor,
                            containerColor: provider.addKitchenResources
                                    .contains(resources)
                                ? AppTheme.whiteColor
                                : AppTheme.appColor,
                            textColor: provider.addKitchenResources
                                    .contains(resources)
                                ? AppTheme.appColor
                                : AppTheme.whiteColor,
                            text: resources,
                            onTap: () {
                              setState(() {
                                if (provider.addKitchenResources
                                    .contains(resources)) {
                                  provider.removeKitchenResource(resources);
                                } else {
                                  provider.addKitchenResource(resources);
                                }
                              });
                            },
                          );
                        }).toList(),
                      )
                    : SizedBox();
  }
}
