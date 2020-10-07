import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/widgets/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.greenAccent,
      ),
      home: AuthScreen(),
      routes: {
        AuthScreen.routeName: (ctx) => AuthScreen(),
      },
    );
  }
}
