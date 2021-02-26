import 'package:flutter/material.dart';
import 'package:recipiesApp/src/UI/screens/meal_detail_screen.dart';
import 'package:recipiesApp/src/models/meal.dart';

class MealItem extends StatelessWidget {
  final String imgURL;
  final String id;
  final String title;
  final int duration;
  final EComplexity complexity;
  final EAffordability affordability;

  const MealItem(
      {Key key,
      @required this.id,
      @required this.imgURL,
      @required this.title,
      @required this.duration,
      @required this.complexity,
      @required this.affordability})
      : super(key: key);

  String get complexityText {
    switch (complexity) {
      case EComplexity.Simple:
        return 'Simple';
        break;
      case EComplexity.Challenging:
        return 'Challenging';
        break;
      case EComplexity.Hard:
        return 'Hard';
        break;
      default:
        return "Simple";
    }
  }

  String get affordabilityText {
    switch (affordability) {
      case EAffordability.Affordable:
        return 'Affordable';
        break;
      case EAffordability.Pricey:
        return 'Pricey';
        break;
      case EAffordability.Luxurious:
        return 'Luxurious';
        break;
      default:
        return "Affordable";
    }
  }

  void _selectMeal(BuildContext context) async {
    dynamic mealid = await Navigator.of(context)
        .pushNamed(MealDetailScreen.routeName, arguments: id);
    print(mealid.runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imgURL,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    width: 220,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 26, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(
                        width: 6,
                      ),
                      Text('$duration min')
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(
                        width: 6,
                      ),
                      Text('$complexityText')
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.monetization_on),
                      SizedBox(
                        width: 6,
                      ),
                      Text('$affordabilityText')
                    ],
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
