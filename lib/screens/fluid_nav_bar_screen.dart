import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/screens/add_item_screen.dart';
import 'package:hnin_warehouse_app/screens/favorite_screen.dart';
import 'package:hnin_warehouse_app/screens/manage_item_screen.dart';
import 'package:hnin_warehouse_app/screens/product_overview_screen.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class FluidNavBarScreen extends StatefulWidget {
  static const routeName = '/fluid_nav_bar_screen';
  @override
  _FluidNavBarScreenState createState() => _FluidNavBarScreenState();
}

class _FluidNavBarScreenState extends State<FluidNavBarScreen> {
  Widget _child;
  @override
  void initState() {
    // TODO: implement initState
    _child = ProductOverviewScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(255, 77, 210, 1),
        extendBody: true,
        body: _child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(iconPath: "assets/images/home.svg",
                //backgroundColor: Colors.white,
                extras: {"label": "home"}),
            FluidNavBarIcon(iconPath: "assets/images/favorite.svg",
                //backgroundColor: Colors.white,
                extras: {"label": "favorite"})
          ],
          onChange: _handleNavigationChange,
          style: FluidNavBarStyle(
            iconUnselectedForegroundColor: Color.fromRGBO(255, 77, 210, 1),
            iconBackgroundColor: Colors.white,
            iconSelectedForegroundColor: Color.fromRGBO(255, 77, 210, 1),
            barBackgroundColor: Color.fromRGBO(255, 77, 210, 1),
          ),
          scaleFactor: 1.5,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras["label"],
            child: item,
          ),
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = ProductOverviewScreen();
          break;
        case 1:
          _child = FavoriteScreen();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
