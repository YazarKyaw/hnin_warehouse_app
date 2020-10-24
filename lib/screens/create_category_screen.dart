import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/widgets/app_drawer.dart';
import 'package:hnin_warehouse_app/widgets/category_list.dart';
import 'package:provider/provider.dart';

class CreateCategoryScreen extends StatelessWidget {
  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<Items>(context, listen: false).fetchAndSetCategory(true);
  }

  @override
  Widget build(BuildContext context) {
    String categoryName = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Category'),
        backgroundColor: Color.fromRGBO(255, 77, 210, 1),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          content: TextField(
                            decoration:
                                InputDecoration(labelText: 'Category Name'),
                            onChanged: (text) {
                              categoryName = text;
                            },
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () async {
                                if (categoryName.isEmpty) {
                                  return;
                                } else {
                                  await Provider.of<Items>(context,
                                          listen: false)
                                      .addCategory(categoryName);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                }
                              },
                              child: Text('Create'),
                            ),
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog'),
                              child: Text('Cancel'),
                            ),
                          ],
                        ));
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCategories(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshCategories(context),
                child: Consumer<Items>(
                  builder: (ctx, categoriesData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: categoriesData.categories.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          CategoryList(
                            categoryId: categoriesData.categories[i].categoryId,
                            categoryName:
                                categoriesData.categories[i].categoryName,
                            dateTime: categoriesData.categories[i].dateTime,
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
