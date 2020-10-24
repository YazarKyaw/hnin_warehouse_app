import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/screens/add_item_screen.dart';
import 'package:hnin_warehouse_app/screens/manage_item_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final DateTime dateTime;

  CategoryList({this.categoryId, this.categoryName, this.dateTime});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return Card(
      elevation: 10,
      color: Color.fromRGBO(255, 128, 179, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (ctx) => ManageItemScreen(categoryId: categoryId),
          ));
        },
        child: ListTile(
          title: Text(
            categoryName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy').format(dateTime),
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                await Provider.of<Items>(context, listen: false)
                    .deleteCategory(categoryId);
              } catch (error) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Deleting failed!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
    );
  }
}
