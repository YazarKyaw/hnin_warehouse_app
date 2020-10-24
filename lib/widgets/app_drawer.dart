import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/auth.dart';
import 'package:hnin_warehouse_app/screens/add_item_screen.dart';
import 'package:hnin_warehouse_app/screens/create_category_screen.dart';
import 'package:hnin_warehouse_app/screens/manage_item_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Color.fromRGBO(255, 77, 210, 1),
            title: Text('HNIN WAREHOUSE'),
            automaticallyImplyLeading: true,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Color.fromRGBO(255, 77, 210, 1),
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontFamily: 'Lato',
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Color.fromRGBO(255, 77, 210, 1),
            ),
            title: Text(
              'Manage Item',
              style: TextStyle(
                fontFamily: 'Lato',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new CreateCategoryScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Color.fromRGBO(255, 77, 210, 1),
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'Lato',
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
