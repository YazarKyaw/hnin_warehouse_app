import 'package:flutter/material.dart';
import 'package:hnin_warehouse_app/providers/items.dart';
import 'package:hnin_warehouse_app/widgets/item_data.dart';
import 'package:provider/provider.dart';

class ItemGird extends StatelessWidget {
  final bool favoriteStatus;
  final String filterString;
  ItemGird({this.favoriteStatus, this.filterString = ''});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Items>(context);
    var products =
        favoriteStatus ? productsData.favoriteItems : productsData.allItems;
    if (filterString.isNotEmpty) {
      if (filterString == 'HomeUp') {
        products = productsData.filterItem(filterString);
      }
      if (filterString == 'Warehouse') {
        products = productsData.filterItem(filterString);
      }
      if (filterString == 'ShopBack') {
        products = productsData.filterItem(filterString);
      }
      if (filterString == 'yk') {
        products = productsData.filterItemByList(filterString);
      }
      if (filterString == 'ymk') {
        products = productsData.filterItemByList(filterString);
      }
      if (filterString == 'nymk') {
        products = productsData.filterItemByList(filterString);
      }
      if (filterString == 'All') {
        products = productsData.allItems;
      }
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ItemData(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
