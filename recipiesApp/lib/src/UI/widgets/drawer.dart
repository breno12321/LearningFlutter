import 'package:flutter/material.dart';
import 'package:recipiesApp/src/UI/screens/filters_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Drawer(
          elevation: 5,
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                color: Theme.of(context).accentColor,
                child: Text(
                  'Cookin UP!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.restaurant,
                  size: 26,
                ),
                title: Text(
                  "Meals",
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 26,
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(FiltersScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
