import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/auth.dart';
import 'package:hnin_warehouse_app/providers/item.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/screens/add_item_screen.dart';
import 'package:hnin_warehouse_app/screens/auth_screen.dart';
import 'package:hnin_warehouse_app/screens/fluid_nav_bar_screen.dart';
import 'package:hnin_warehouse_app/screens/item_detail_screen.dart';
import 'package:hnin_warehouse_app/screens/manage_item_screen.dart';
import 'package:hnin_warehouse_app/screens/product_overview_screen.dart';
import 'package:hnin_warehouse_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Items>(
          create: null,
          update: (ctx, auth, previousItems) => Items(auth.token, auth.userId,
              previousItems == null ? [] : previousItems.allItems),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(255, 77, 210, 1),
          ),
          home: auth.isAuth
              ? FluidNavBarScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            FluidNavBarScreen.routeName: (ctx) => FluidNavBarScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            AddItemScreen.routeName: (ctx) => AddItemScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ManageItemScreen.routeName: (ctx) => ManageItemScreen(),
            ItemDetailScreen.routeName: (ctx) => ItemDetailScreen(),
          },
        ),
      ),
    );
  }
}
