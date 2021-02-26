import 'package:flutter/material.dart';
import 'package:recipiesApp/data/dummy_data.dart';
import 'package:recipiesApp/src/UI/screens/categories_screen.dart';
import 'package:recipiesApp/src/UI/screens/category_meals_screen.dart';
import 'package:recipiesApp/src/UI/screens/filters_screen.dart';
import 'package:recipiesApp/src/UI/screens/meal_detail_screen.dart';
import 'package:recipiesApp/src/UI/screens/tabs_screen.dart';
import 'package:recipiesApp/src/models/meal.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false
  };

  List<Meal> _availableMeals = DUMMY_MEALS;

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((m) {
        if (_filters['gluten'] && !m.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !m.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !m.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] && !m.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recipe App",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (c) => TabsScreen(),
        CategoryMealsScreen.routeName: (c) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (c) => MealDetailScreen(),
        FiltersScreen.routeName: (c) => FiltersScreen(_filters, _setFilters),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => CategoriesScreen(),
        );
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => CategoriesScreen(),
      ),
    );
  }
}
