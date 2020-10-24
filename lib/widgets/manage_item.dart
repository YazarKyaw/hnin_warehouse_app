import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/screens/add_item_screen.dart';
import 'package:hnin_warehouse_app/screens/item_detail_screen.dart';
import 'package:hnin_warehouse_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

class ManageItem extends StatelessWidget {
  final String id;
  final String itemName;
  final String imageUrl;
  final String itemCode;
  final String categoryId;
  ManageItem(
      this.id, this.itemName, this.itemCode, this.imageUrl, this.categoryId);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (ctx) => ItemDetailScreen(
                  id: id,
                  detailByItem: true,
                )));
      },
      child: ListTile(
        title: Text(itemCode),
        subtitle: Text(itemName),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (ctx) => new AddItemScreen(
                        categoryId: categoryId,
                        itemId: id,
                      ),
                    ),
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Items>(context, listen: false)
                        .deleteItem(categoryId, id);
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
            ],
          ),
        ),
      ),
    );
  }
}
