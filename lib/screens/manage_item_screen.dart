import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/widgets/manage_item.dart';
import 'package:provider/provider.dart';

import 'add_item_screen.dart';

class ManageItemScreen extends StatelessWidget {
  static const routeName = '/manage_item_screen';
  final String categoryId;
  ManageItemScreen({this.categoryId});
  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<Items>(context, listen: false)
        .fetchAndSetItems(filterByUser: true, itemCategoryId: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        backgroundColor: Color.fromRGBO(255, 77, 210, 1),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (ctx) => AddItemScreen(
                    categoryId: categoryId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshItems(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshItems(context),
                    child: Consumer<Items>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              ManageItem(
                                productsData.items[i].id,
                                productsData.items[i].itemName,
                                productsData.items[i].itemCode,
                                productsData.items[i].imageUrl,
                                categoryId,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
